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

  static Resolvers create(Ref<Resolvers> ref) {
    return Resolvers(
      eventResolver: (nevent) async {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
        final post = await PartialNote(
          'Test post content',
          createdAt: DateTime.now(),
        ).signWith(DummySigner(),
            withPubkey:
                'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be');
        await ref.read(storageNotifierProvider.notifier).save({post});
        return (event: post, onTap: null);
      },
      profileResolver: (npub) async {
        await Future.delayed(const Duration(seconds: 1));
        final profile = await PartialProfile(
          name: 'Pip',
          pictureUrl: 'https://m.primal.net/IfSZ.jpg',
        ).signWith(DummySigner());
        return (profile: profile, onTap: null);
      },
      emojiResolver: (identifier) async {
        await Future.delayed(const Duration(seconds: 1));
        return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
      },
      hashtagResolver: (identifier) async {
        await Future.delayed(const Duration(seconds: 1));
        return () {};
      },
    );
  }
}

final resolversProvider = Provider<Resolvers>((ref) {
  return Resolvers.create(ref);
});
