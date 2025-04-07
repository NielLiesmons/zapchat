import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTab extends ConsumerStatefulWidget {
  const ChatTab({super.key});

  static TabData tabData(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Chats',
      icon: const AppEmojiContentType(contentType: 'chat'),
      content: Builder(
        builder: (context) {
          return const ChatTab();
        },
      ),
    );
  }

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  late final Future<Community> _community;
  late final Future<ChatMessage> _lastMessage;

  @override
  void initState() {
    super.initState();
    _community = PartialCommunity(
      "Test",
    ).signWith(DummySigner(), withPubkey: 'testpubkey123');

    _lastMessage = PartialChatMessage(
      'Test message',
      createdAt: DateTime.now(),
    ).signWith(DummySigner(), withPubkey: 'testpubkey123');
  }

  @override
  Widget build(BuildContext context) {
    return tabData(context, ref).content;
  }

  TabData tabData(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Chats',
      icon: const AppEmojiContentType(contentType: 'chat'),
      content: Builder(
        builder: (context) {
          return FutureBuilder<Community>(
            future: _community,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return AppContainer(
                  alignment: Alignment.center,
                  child: const AppLoadingDots(),
                );
              }

              return FutureBuilder<ChatMessage>(
                future: _lastMessage,
                builder: (context, messageSnapshot) {
                  if (!messageSnapshot.hasData) {
                    return AppContainer(
                      alignment: Alignment.center,
                      child: const AppLoadingDots(),
                    );
                  }

                  return Column(
                    children: [
                      AppCommunityHomePanel(
                        community: snapshot.data!,
                        lastChatMessage: messageSnapshot.data!,
                        mainCount: 5,
                        contentCounts: {
                          'chat': 2,
                          'post': 2,
                          'article': 1,
                        },
                        onNavigateToChat: (communikey) {
                          context.push('/community/testpubkey123');
                        },
                        onNavigateToContent: (communikey, contentType) {
                          context.push('/content/testpubkey123/$contentType');
                        },
                        onResolveEvent: (nevent) async {
                          // Simulate network delay
                          await Future.delayed(const Duration(seconds: 1));
                          final post = await PartialNote(
                            'Test post content',
                            createdAt: DateTime.now(),
                          ).signWith(DummySigner(),
                              withPubkey:
                                  'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be');
                          await ref
                              .read(storageNotifierProvider.notifier)
                              .save({post});
                          return (event: post, onTap: null);
                        },
                        onResolveProfile: (npub) async {
                          await Future.delayed(const Duration(seconds: 1));
                          return (
                            profile: await PartialProfile(
                              name: 'Pip',
                              pictureUrl: 'https://m.primal.net/IfSZ.jpg',
                            ).signWith(DummySigner()),
                            onTap: null
                          );
                        },
                        onResolveEmoji: (identifier) async {
                          await Future.delayed(const Duration(seconds: 1));
                          return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
