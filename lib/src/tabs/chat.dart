import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/messages.dart';
import '../providers/chat_screen.dart';

class ChatTab extends ConsumerWidget {
  const ChatTab({super.key});

  TabData tabData(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final messages = ref.watch(messagesProvider.notifier);
    final chatData = ref.watch(chatScreenDataProvider);

    return TabData(
      label: 'Chats',
      icon: const AppEmojiContentType(contentType: 'chat'),
      content: Builder(
        builder: (context) {
          return Column(
            children: [
              for (final npub in chatData.keys)
                AppChatHomePanel(
                  npub: chatData[npub]!.npub,
                  profileName: chatData[npub]!.profileName,
                  profilePicUrl: chatData[npub]!.profilePicUrl,
                  lastMessage: messages.getLastMessage(npub)?.message ?? '',
                  lastMessageProfileName:
                      messages.getLastMessage(npub)?.profileName,
                  lastMessageTimeStamp:
                      messages.getLastMessage(npub)?.timestamp ??
                          DateTime.now(),
                  mainCount: chatData[npub]!.mainCount,
                  contentCounts: chatData[npub]!.contentCounts,
                  onNavigateToChat: (context, _) {
                    context.push('/chat/$npub');
                  },
                  onNavigateToContent: (context, npub, contentType) {
                    context.push('/content/$npub/$contentType');
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      tabData(context, ref).content;
}
