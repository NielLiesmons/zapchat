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
      await Future.delayed(const Duration(seconds: 1));
      final post = await PartialNote(
        'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
        createdAt: DateTime.now(),
      ).signWith(DummySigner(ref));
      await ref.read(storageNotifierProvider.notifier).save({post});
      return (model: post, onTap: null);
    }),
    profileResolver: (identifier) =>
        profileCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(seconds: 1));
      final profile = await PartialProfile(
        name: 'Pip',
        pictureUrl: 'https://m.primal.net/IfSZ.jpg',
      ).signWith(DummySigner(ref));
      return (profile: profile, onTap: null);
    }),
    emojiResolver: (identifier) => emojiCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(seconds: 1));
      return 'https://cdn.satellite.earth/cbcd50ec769b65c03bc780f0b2d0967f893d10a29f7666d7df8f2d7614d493d4.png';
    }),
    hashtagResolver: (identifier) =>
        hashtagCache.getOrCreate(identifier, () async {
      await Future.delayed(const Duration(seconds: 1));
      return () {};
    }),
  );
});
