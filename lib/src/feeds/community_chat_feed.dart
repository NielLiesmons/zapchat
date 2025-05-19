import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityChatFeed extends ConsumerWidget {
  final Community community;

  const CommunityChatFeed({
    super.key,
    required this.community,
  });

  List<List<ChatMessage>> _groupMessages(List<ChatMessage> messages) {
    final groups = <List<ChatMessage>>[];
    List<ChatMessage>? currentGroup;
    String? currentPubkey;
    DateTime? lastMessageTime;

    for (final message in messages) {
      final shouldStartNewGroup = currentGroup == null ||
          currentPubkey != message.author.value?.pubkey ||
          lastMessageTime!.difference(message.createdAt).inMinutes.abs() > 21;

      if (shouldStartNewGroup) {
        currentGroup = [message];
        groups.add(currentGroup);
        currentPubkey = message.author.value?.pubkey;
      } else {
        currentGroup.add(message);
      }
      lastMessageTime = message.createdAt;
    }

    return groups;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvers = ref.read(resolversProvider);

    final state = ref.watch(query<ChatMessage>());

    if (state case StorageLoading()) {
      return const Center(child: AppLoadingFeed(type: LoadingFeedType.chat));
    }

    final messages = state.models;

    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet'),
      );
    }

    final messageGroups = _groupMessages(messages);

    final currentProfile = ref.watch(Profile.signedInProfileProvider);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s6),
      child: Column(
        children: [
          for (final group in messageGroups)
            Column(
              children: [
                AppMessageStack(
                  messages: group,
                  onResolveEvent: resolvers.eventResolver,
                  onResolveProfile: resolvers.profileResolver,
                  onResolveEmoji: resolvers.emojiResolver,
                  onResolveHashtag: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return () {};
                  },
                  isOutgoing: group.first.author.value?.pubkey ==
                      currentProfile?.pubkey,
                  onReply: (event) =>
                      context.push('/reply-to/${event.id}', extra: event),
                  onActions: (event) =>
                      context.push('/actions/${event.id}', extra: event),
                  onReactionTap: (reaction) {},
                  onZapTap: (zap) {},
                  onLinkTap: (url) {},
                ),
                const AppGap.s8(),
              ],
            ),
          const AppGap.s8(),
        ],
      ),
    );
  }
}
