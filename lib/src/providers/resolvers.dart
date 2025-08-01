import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';

class Resolvers {
  final NostrEventResolver eventResolver;
  final NostrProfileResolver profileResolver;
  final NostrEmojiResolver emojiResolver;
  final NostrHashtagResolver hashtagResolver;
  final TopThreeReplyProfilesResolver topThreeReplyProfilesResolver;
  final TotalReplyProfilesResolver totalReplyProfilesResolver;

  const Resolvers({
    required this.eventResolver,
    required this.profileResolver,
    required this.emojiResolver,
    required this.hashtagResolver,
    required this.topThreeReplyProfilesResolver,
    required this.totalReplyProfilesResolver,
  });
}

class TopThreeReplyProfilesNotifier extends StateNotifier<List<Profile>> {
  TopThreeReplyProfilesNotifier(super.profiles);
}

class TotalReplyProfilesNotifier extends StateNotifier<int> {
  TotalReplyProfilesNotifier(super.count);
}

typedef TopThreeReplyProfilesResolver
    = StateNotifierProvider<TopThreeReplyProfilesNotifier, List<Profile>>
        Function(Model model);
typedef TotalReplyProfilesResolver
    = StateNotifierProvider<TotalReplyProfilesNotifier, int> Function(
        Model model);

// Add cache classes
class _ResolverCache<T> {
  final Map<String, Future<T>> _cache = {};

  Future<T> getOrCreate(String key, Future<T> Function() create) {
    return _cache.putIfAbsent(key, create);
  }

  void clear() {
    _cache.clear();
  }
}

final resolversProvider = Provider<Resolvers>((ref) {
  final eventCache = _ResolverCache<({Model model, VoidCallback? onTap})>();
  final hashtagCache = _ResolverCache<void Function()?>();

  return Resolvers(
    eventResolver: (identifier) => eventCache.getOrCreate(identifier, () async {
      // Handle nostr: prefix and extract the actual identifier
      String eventId = identifier;
      if (identifier.startsWith('nostr:')) {
        eventId = identifier.substring(6); // Remove 'nostr:' prefix
      }

      // Handle nevent1... format - decode to get the actual event ID
      if (eventId.startsWith('nevent1')) {
        try {
          final decoded = Utils.decodeShareableIdentifier(eventId);
          if (decoded is EventData) {
            eventId = decoded.eventId;
          }
        } catch (e) {
          print('Failed to decode nevent1: $e');
          // Skip this identifier if decoding fails
          eventId = '';
        }
      }

      // Query for any model with this ID
      final models = await ref.read(storageNotifierProvider.notifier).query(
            RequestFilter(ids: {eventId}).toRequest(),
          );

      // Trigger background sync to keep looking for the event
      ref.read(storageNotifierProvider.notifier).query(
            RequestFilter(ids: {eventId}).toRequest(),
            source: RemoteSource(),
          );

      return (model: models.firstOrNull as Model, onTap: null);
    }),
    profileResolver: (identifier) async {
      // Handle nostr: prefix and extract the actual identifier
      String cleanIdentifier = identifier;
      if (identifier.startsWith('nostr:')) {
        cleanIdentifier = identifier.substring(6); // Remove 'nostr:' prefix
      }

      // Handle npub and nprofile formats - decode to get the actual pubkey
      String pubkey = cleanIdentifier;
      if (cleanIdentifier.startsWith('npub') ||
          cleanIdentifier.startsWith('nprofile')) {
        try {
          final decoded = Utils.decodeShareableIdentifier(cleanIdentifier);
          if (decoded is ProfileData) {
            pubkey = decoded.pubkey;
          }
        } catch (e) {
          // Continue with original identifier
        }
      }

      // Query from local storage and custom relays simultaneously
      final models = await ref.read(storageNotifierProvider.notifier).query(
            RequestFilter<Profile>(authors: {pubkey}).toRequest(),
            source: LocalAndRemoteSource(
              relayUrls: {
                'wss://relay.vertexlab.io',
                'wss://nostr.band',
              },
              stream: true,
              background: true,
            ),
          );

      return (profile: models.firstOrNull, onTap: null);
    },
    emojiResolver: (identifier, model) async {
      final emojiTags = model.event.tags
          .where((tag) => tag.isNotEmpty && tag[0] == 'emoji')
          .toList();

      for (final tag in emojiTags) {
        if (tag.length >= 3 && tag[1] == identifier) {
          return tag[2];
        }
      }
      return '';
    },
    hashtagResolver: (identifier) =>
        hashtagCache.getOrCreate(identifier, () async {
      return () {};
    }),
    topThreeReplyProfilesResolver: (model) =>
        StateNotifierProvider<TopThreeReplyProfilesNotifier, List<Profile>>(
            (ref) {
      final replies = ref
          .watch(query<Comment>(
            where: (comment) => comment.parentModel.value?.id == model.id,
          ))
          .models
          .cast<Comment>();

      print('Found ${replies.length} replies for model ${model.id}');

      final uniqueProfiles = replies
          .map((reply) => reply.author.value)
          .where((profile) => profile != null)
          .toSet()
          .take(3)
          .cast<Profile>()
          .toList();

      print('Found ${uniqueProfiles.length} unique profiles');
      return TopThreeReplyProfilesNotifier(uniqueProfiles);
    }),
    totalReplyProfilesResolver: (model) =>
        StateNotifierProvider<TotalReplyProfilesNotifier, int>((ref) {
      final replies = ref
          .watch(query<Comment>(
            where: (comment) => comment.parentModel.value?.id == model.id,
          ))
          .models
          .cast<Comment>();

      final uniqueProfilesCount = replies
          .map((reply) => reply.author.value)
          .where((profile) => profile != null)
          .toSet()
          .length;

      return TotalReplyProfilesNotifier(uniqueProfilesCount);
    }),
  );
});
