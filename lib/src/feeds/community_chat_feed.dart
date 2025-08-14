import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/communities_provider.dart';

class CommunityChatFeed extends ConsumerWidget {
  final Community community;
  final EdgeInsets? padding;
  final bool reverse;
  final ScrollController? controller;
  final Function(ChatMessage)? onMessageTap;
  final Function(ChatMessage)? onMessageReply;
  final Function(ChatMessage)? onMessageActions;
  final Function(ChatMessage)? onMessageResend;
  final bool showPublishingState;
  final String? publishingMessageId;

  const CommunityChatFeed({
    super.key,
    required this.community,
    this.padding,
    this.reverse = true,
    this.controller,
    this.onMessageTap,
    this.onMessageReply,
    this.onMessageActions,
    this.onMessageResend,
    this.showPublishingState = false,
    this.publishingMessageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvers = ref.read(resolversProvider);
    final activePubkey = ref.watch(Signer.activePubkeyProvider);

    // Use centralized communities provider for zero-delay access to hot cached data
    final messages = ref.watch(communityMessagesProvider(community.id));

    print(
        '🏘️ CommunityChatFeed using centralized provider - Community: ${community.name}, Messages: ${messages.length}');

    if (messages.isEmpty) {
      return LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s16),
        child: LabModelEmptyStateCard(
          contentType: "chat",
          onCreateTap: () => context.push('/create/message', extra: community),
        ),
      );
    }

    // Wrap entire feed in RepaintBoundary for better performance
    return RepaintBoundary(
      child: ListView.builder(
        controller: controller,
        reverse: false,
        padding: padding ?? EdgeInsets.zero,
        itemCount: messages.length,
        // Performance optimizations for smooth scrolling
        addAutomaticKeepAlives: false, // Don't keep off-screen items alive
        addRepaintBoundaries: true, // Prevent unnecessary repaints
        cacheExtent: 1000.0, // Cache more items for smoother scrolling
        // Scroll performance optimizations
        physics: const ClampingScrollPhysics(), // Better scroll physics
        itemBuilder: (context, index) {
          final message = messages[index];
          final isOutgoing = message.author.value?.pubkey == activePubkey;

          // Use your existing LabMessageBubble with all its built-in logic
          return RepaintBoundary(
            key: ValueKey(
                '${message.id}_$index'), // Better key for ListView optimization
            child: LabMessageBubble(
              message: message,
              isOutgoing: isOutgoing,
              isFirstInStack: _isFirstInStack(messages, index),
              isLastInStack: _isLastInStack(messages, index),
              isPublishing: showPublishingState &&
                  isOutgoing &&
                  message.id == publishingMessageId,
              onSendAgain: onMessageResend != null &&
                      isOutgoing &&
                      message.event.relays.isEmpty &&
                      message.id == publishingMessageId
                  ? (model) => onMessageResend!(model as ChatMessage)
                  : null,
              onActions: onMessageActions != null
                  ? (model) => onMessageActions!(model as ChatMessage)
                  : (model) => context.push('/actions/${model.id}',
                      extra: (model: model, community: community)),
              onReply: onMessageReply != null
                  ? (model) => onMessageReply!(model as ChatMessage)
                  : (model) => context.push('/reply-to/${model.id}',
                      extra: (model: model, community: community)),
              onResolveEvent: resolvers.eventResolver,
              onResolveProfile: resolvers.profileResolver,
              onResolveEmoji: resolvers.emojiResolver,
              onResolveHashtag: resolvers.hashtagResolver,
              onLinkTap: (url) {
                // Handle link tap
                print('Link tapped: $url');
              },
              onProfileTap: (profile) {
                // Handle profile tap
                context.push('/profile/${profile.npub}', extra: profile);
              },
              activePubkey: activePubkey,
            ),
          );
        },
      ),
    );
  }

  /// Use your existing logic for determining message stack grouping
  bool _isFirstInStack(List<ChatMessage> messages, int index) {
    if (index >= messages.length - 1) return true;

    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];

    // Check if next message is from same author within 21 minutes
    if (currentMessage.author.value?.pubkey ==
        nextMessage.author.value?.pubkey) {
      final timeDiff = nextMessage.createdAt
          .difference(currentMessage.createdAt)
          .inMinutes
          .abs();
      return timeDiff > 21;
    }

    return true;
  }

  bool _isLastInStack(List<ChatMessage> messages, int index) {
    if (index <= 0) return true;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    // Check if previous message is from same author within 21 minutes
    if (currentMessage.author.value?.pubkey ==
        previousMessage.author.value?.pubkey) {
      final timeDiff = currentMessage.createdAt
          .difference(previousMessage.createdAt)
          .inMinutes
          .abs();
      return timeDiff > 21;
    }

    return true;
  }
}
