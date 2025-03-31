import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTab extends ConsumerWidget {
  const ChatTab({super.key});

  TabData tabData(BuildContext context, WidgetRef ref) {
    final messagesState = ref.watch(query(kinds: {9}));
    final messages = messagesState.models.cast<ChatMessage>();
    // final chatData = ref.watch(chatScreenDataProvider);

    return TabData(
      label: 'Chats',
      icon: const AppEmojiContentType(contentType: 'chat'),
      content: Builder(
        builder: (context) {
          return Column(
            children: [
              for (final message in messages)
                AppChatHomePanel(
                  npub: message.author.value!.npub,
                  profileName: message.author.value!.nameOrNpub,
                  profilePicUrl: message.author.value!.pictureUrl!,
                  lastMessage: message.content,
                  // TODO: Can't find how to diff sender/recipient with NIP-C7
                  lastMessageProfileName: message.author.value!.nameOrNpub,
                  lastMessageTimeStamp: message.createdAt,
                  // TODO: This stuff should be accessed via relationships
                  mainCount: 21,
                  contentCounts: {},
                  onNavigateToChat: (context, _) {
                    context.push('/chat/${message.author.value!.npub}');
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
