import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';

class Resolvers {
  final NostrEventResolver eventResolver;
  final NostrProfileResolver profileResolver;
  final NostrEmojiResolver emojiResolver;
  final NostrHashtagResolver hashtagResolver;

  const Resolvers({
    required this.eventResolver,
    required this.profileResolver,
    required this.emojiResolver,
    required this.hashtagResolver,
  });
}

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
  final profileCache =
      _ResolverCache<({Profile profile, VoidCallback? onTap})>();
  final emojiCache = _ResolverCache<String>();
  final hashtagCache = _ResolverCache<void Function()?>();

  return Resolvers(
    eventResolver: (identifier) => eventCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(milliseconds: 50));
      final state = ref.watch(query<ChatMessage>());
      if (state is StorageState<ChatMessage> && state.models.isNotEmpty) {
        return (model: state.models.first, onTap: null);
      }
      // Fallback to creating a new note if no articles are available
      final message = await PartialChatMessage(
        'This is a :emeoji: Nostr message. Just for testing, nothing special. \n\nIt\'s mainly to test the profile colors in chat widgets.',
        createdAt: DateTime.now(),
      ).signWith(DummySigner(ref));
      await ref.read(storageNotifierProvider.notifier).save({message});
      return (model: message, onTap: null);
    }),
    profileResolver: (identifier) =>
        profileCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(milliseconds: 50));
      print('Resolving profile for identifier: $identifier');
      final profile = ref.watch(Profile.signedInProfileProvider);
      print('Current profile: $profile');

      if (profile == null) {
        print('Creating dummy profile for: $identifier');
        // Create a dummy profile instead of throwing
        final dummyProfile = Profile.fromMap({
          'pubkey': identifier,
          'content': '{}',
          'created_at': DateTime.now().toSeconds(),
        }, ref);
        return (
          profile: dummyProfile,
          onTap: () {
            // Dummy function - you can implement actual navigation later
            print('Profile tapped: $identifier');
          }
        );
      }
      return (
        profile: profile,
        onTap: () {
          // Dummy function - you can implement actual navigation later
          print('Profile tapped: ${profile.name}');
        }
      );
    }),
    emojiResolver: (identifier) => emojiCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(milliseconds: 50));
      return switch (identifier.toLowerCase()) {
        'nostr' =>
          'https://cdn.satellite.earth/cbcd50ec769b65c03bc780f0b2d0967f893d10a29f7666d7df8f2d7614d493d4.png',
        'beautiful' =>
          'https://image.nostr.build/f1ac401d3f222908d2f80df7cfadc1d73f4e0afa3a3ff6e8421bf9f0b37372a6.gif', // Replace with actual URL
        _ =>
          'https://cdn.satellite.earth/cbcd50ec769b65c03bc780f0b2d0967f893d10a29f7666d7df8f2d7614d493d4.png', // Default fallback
      };
    }),
    hashtagResolver: (identifier) =>
        hashtagCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(milliseconds: 50));
      return () {};
    }),
  );
});
