import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class SimpleCommunityTest extends ConsumerWidget {
  const SimpleCommunityTest({super.key});

  // Helper function to determine message stack grouping
  (bool, bool) getMessageStackInfo(List<ChatMessage> messages, int index) {
    if (messages.isEmpty) return (false, false);

    final currentMessage = messages[index];
    final isFirstInStack = index == messages.length - 1 ||
        messages[index + 1].author.value?.pubkey !=
            currentMessage.author.value?.pubkey ||
        messages[index + 1]
                .createdAt
                .difference(currentMessage.createdAt)
                .inMinutes >
            5;

    final isLastInStack = index == 0 ||
        messages[index - 1].author.value?.pubkey !=
            currentMessage.author.value?.pubkey ||
        currentMessage.createdAt
                .difference(messages[index - 1].createdAt)
                .inMinutes >
            5;

    return (isFirstInStack, isLastInStack);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('🔄 SimpleCommunityTest build() called at ${DateTime.now()}');

    final messagesState = ref.watch(
      query<ChatMessage>(
        and: (msg) => {msg.author, msg.reactions, msg.zaps},
        limit: 1000,
        source: LocalAndRemoteSource(background: true),
      ),
    );

    print(
        '📊 Messages state: ${messagesState.runtimeType} with ${messagesState.models.length} models');

    return LabScaffold(
      body: Column(
        children: [
          // Simple header
          LabContainer(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
            ),
            child: const LabText.bold16(
              'Message Content Test',
              color: Color(0xFFFFFFFF),
            ),
          ),

          // Messages list with actual content
          Expanded(
            child: switch (messagesState) {
              StorageLoading() => const Center(
                  child: LabLoadingDots(),
                ),
              StorageError() => Center(
                  child: LabText.reg14(
                    'Error: ${messagesState.exception}',
                    color: const Color(0xFFB3B3B3),
                  ),
                ),
              StorageData() => ListView.builder(
                  itemCount: messagesState.models.length,
                  itemBuilder: (context, index) {
                    print(
                        '📝 Building message item $index at ${DateTime.now()}');
                    final message = messagesState.models[index];
                    final isOutgoing = message.author.value?.pubkey ==
                        ref.read(Signer.activePubkeyProvider);

                    // Get stack grouping info
                    final (isFirstInStack, isLastInStack) =
                        getMessageStackInfo(messagesState.models, index);

                    // return LabMessageBubble(
                    //   message: message,
                    //   isOutgoing: isOutgoing,
                    //   isFirstInStack: isFirstInStack,
                    //   isLastInStack: isLastInStack,
                    //   onResolveEvent: (id) async => (model: null, onTap: null),
                    //   onResolveProfile: (id) async =>
                    //       (profile: null, onTap: null),
                    //   onResolveEmoji: (id, message) async => '',
                    //   onResolveHashtag: (id) async => () {},
                    //   onReply: (model) {
                    //     print('Reply for: ${model.id}');
                    //   },
                    //   onActions: (model) {
                    //     print('Actions for: ${model.id}');
                    //   },
                    //   onReactionTap: (reaction) {},
                    //   onZapTap: (zap) {},
                    //   onLinkTap: (url) {},
                    //   onProfileTap: (profile) {
                    //     print('Profile tap for: ${profile.name}');
                    //   },
                    //   activePubkey: ref.read(Signer.activePubkeyProvider),
                    // );
                    return LabText(message.content);
                  },
                ),
            },
          ),
        ],
      ),
    );
  }
}
