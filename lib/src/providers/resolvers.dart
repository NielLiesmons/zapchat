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
  final eventCache = _ResolverCache<({Model? model, VoidCallback? onTap})>();
  final hashtagCache = _ResolverCache<void Function()?>();

  return Resolvers(
    eventResolver: (identifier) => eventCache.getOrCreate(identifier, () async {
      // Handle nostr: prefix and extract the actual identifier
      String eventId = identifier;
      if (identifier.startsWith('nostr:')) {
        eventId = identifier.substring(6); // Remove 'nostr:' prefix
      }

      // Handle nevent1, naddr1, and note1 formats - decode to get the actual data
      if (eventId.startsWith('nevent1')) {
        try {
          final decoded = Utils.decodeShareableIdentifier(eventId);
          if (decoded is EventData) {
            eventId = decoded.eventId;
          } else {
            throw Exception('Invalid nevent1 format');
          }
        } catch (e) {
          print('Failed to decode nevent1: $e');
          // Check if this might be a hex ID with nevent1 prefix (malformed)
          if (eventId.length == 7 + 64) {
            // nevent1 + 64 hex chars
            final hexPart = eventId.substring(7);
            if (RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(hexPart)) {
              print('Extracting hex ID from malformed nevent1: $hexPart');
              eventId = hexPart;
            } else {
              throw Exception('Invalid nevent1 format: $eventId');
            }
          } else {
            throw Exception('Invalid nevent1 format: $eventId');
          }
        }
      } else if (eventId.startsWith('naddr1')) {
        try {
          final decoded = Utils.decodeShareableIdentifier(eventId);
          if (decoded is AddressData) {
            // For naddr, we need to query by kind, author, and d-tag
            if (decoded.kind == null ||
                decoded.author == null ||
                decoded.identifier == null) {
              throw Exception('Invalid naddr1 data: missing required fields');
            }

            // Check if this kind is registered in the models package
            final knownKinds = {
              0, // Profile
              1, // Note
              3, // ContactList
              4, // DirectMessage
              6, // Repost
              7, // Reaction
              9, // ChatMessage
              11, // ForumPost
              145, // Mail
              1018, // PollResponse
              1068, // Poll
              1055, // Book
              10456, // Group
              30617, // Repository
              32767, // Job
              9321, // CashuZap
              33333, // Service
              30402, // Product
              37060, // Task
            };

            if (knownKinds.contains(decoded.kind)) {
              // Try to query for models only for known kinds
              try {
                final models =
                    await ref.watch(storageNotifierProvider.notifier).query(
                          RequestFilter(
                            kinds: {decoded.kind!},
                            authors: {decoded.author!},
                            tags: {
                              '#d': {decoded.identifier!}
                            },
                          ).toRequest(),
                        );

                // Trigger background sync
                ref.read(storageNotifierProvider.notifier).query(
                      RequestFilter(
                        kinds: {decoded.kind!},
                        authors: {decoded.author!},
                        tags: {
                          '#d': {decoded.identifier!}
                        },
                      ).toRequest(),
                      source: RemoteSource(),
                    );

                final model = models.firstOrNull as Model?;
                if (model != null) {
                  return (model: model, onTap: null);
                }
              } catch (e) {
                print(
                    'Failed to query for naddr model with kind ${decoded.kind}: $e');
              }
            } else {
              print(
                  'Skipping query for unregistered kind ${decoded.kind} (naddr: ${decoded.identifier})');
            }

            // If we get here, either no model was found or the kind is unknown
            print(
                'Addressable event not found or unknown kind: ${decoded.identifier}');
            return (model: null, onTap: null);
          } else {
            throw Exception('Invalid naddr1 format');
          }
        } catch (e) {
          print('Failed to decode naddr1: $e');
          throw Exception('Invalid naddr1 format: $eventId');
        }
      } else if (eventId.startsWith('note1')) {
        try {
          final decoded = Utils.decodeShareableIdentifier(eventId);
          if (decoded is EventData) {
            eventId = decoded.eventId;
          } else {
            throw Exception('Invalid note1 format');
          }
        } catch (e) {
          print('Failed to decode note1: $e');
          // Check if this might be a hex ID with note1 prefix (malformed)
          if (eventId.length == 5 + 64) {
            // note1 + 64 hex chars
            final hexPart = eventId.substring(5);
            if (RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(hexPart)) {
              print('Extracting hex ID from malformed note1: $hexPart');
              eventId = hexPart;
            } else {
              throw Exception('Invalid note1 format: $eventId');
            }
          } else {
            throw Exception('Invalid note1 format: $eventId');
          }
        }
      }

      // Try to query for models first (for known kinds)
      try {
        final models = await ref.watch(storageNotifierProvider.notifier).query(
              RequestFilter(ids: {eventId}).toRequest(),
            );

        // Trigger background sync to keep looking for the event
        ref.read(storageNotifierProvider.notifier).query(
              RequestFilter(ids: {eventId}).toRequest(),
              source: RemoteSource(),
            );

        final model = models.firstOrNull as Model?;
        if (model != null) {
          return (model: model, onTap: null);
        }
      } catch (e) {
        print('Failed to query for model with kind, likely unknown kind: $e');
      }

      // If we get here, either no model was found or the kind is unknown
      // Return null to indicate the event couldn't be resolved
      print('Event not found or unknown kind: $eventId');
      return (model: null, onTap: null);
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
