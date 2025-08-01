import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityChatFeed extends ConsumerStatefulWidget {
  final Community community;

  const CommunityChatFeed({
    super.key,
    required this.community,
  });

  @override
  ConsumerState<CommunityChatFeed> createState() => _CommunityChatFeedState();
}

class _CommunityChatFeedState extends ConsumerState<CommunityChatFeed> {
  final Map<String, GlobalKey> _messageKeys = {};
  final ScrollController _scrollController = ScrollController();
  List<String> _previousMessageIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls to a specific message by its ID if it exists in the feed
  /// Returns true if the message was found and scrolled to, false otherwise
  Future<bool> scrollToMessage(String messageId) async {
    final key = _messageKeys[messageId];
    if (key?.currentContext == null) {
      return false;
    }

    await Scrollable.ensureVisible(
      key!.currentContext!,
      duration: LabDurationsData.normal().normal,
      curve: Curves.easeOut,
      alignment: 0.0, // Align to top
    );

    return true;
  }

  /// Checks if the message at the given index has the same sender as the previous message
  bool _isSameSenderAsPrevious(List<ChatMessage> messages, int index) {
    if (index <= 0) return false;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    final currentPubkey = currentMessage.author.value?.pubkey;
    final previousPubkey = previousMessage.author.value?.pubkey;

    if (currentPubkey != previousPubkey) return false;

    // Check if within 21 minutes
    final timeDiff = currentMessage.createdAt
        .difference(previousMessage.createdAt)
        .inMinutes
        .abs();
    return timeDiff <= 21;
  }

  /// Checks if the message at the given index has the same sender as the next message
  bool _isSameSenderAsNext(List<ChatMessage> messages, int index) {
    if (index >= messages.length - 1) return false;

    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];

    final currentPubkey = currentMessage.author.value?.pubkey;
    final nextPubkey = nextMessage.author.value?.pubkey;

    if (currentPubkey != nextPubkey) return false;

    // Check if within 21 minutes
    final timeDiff = nextMessage.createdAt
        .difference(currentMessage.createdAt)
        .inMinutes
        .abs();
    return timeDiff <= 21;
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final activePubkey = ref.watch(Signer.activePubkeyProvider);
    final resolvers = ref.read(resolversProvider);

    // Query for chat messages specifically for this community using h tag filtering
    // Use the same pattern as Threads feed for consistency

    final chatMessagesState = ref.watch(query<ChatMessage>(
        limit: 21,
        tags: {
          '#h': {widget.community.event.pubkey}
        },
        and: (msg) => {msg.author}));
    final queryEndTime = DateTime.now();

    // Background remote sync temporarily disabled for debugging

    // Handle loading state
    if (chatMessagesState case StorageLoading()) {
      return const LabLoadingFeed(type: LoadingFeedType.chat);
    }

    if (chatMessagesState case StorageError()) {
      return const LabLoadingFeed(type: LoadingFeedType.chat);
    }

    List<ChatMessage> messages = chatMessagesState.models.toList();

    if (messages.isEmpty) {
      return LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s12),
        child: LabModelEmptyStateCard(
          contentType: "chat",
          onCreateTap: () =>
              context.push('/create/message', extra: widget.community),
        ),
      );
    }

    // Simple auto-scroll for new outgoing messages
    if (activePubkey != null) {
      // Count individual outgoing messages
      final currentOutgoingCount = messages
          .where((message) => message.author.value?.pubkey == activePubkey)
          .length;

      if (currentOutgoingCount > _previousMessageIds.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToBottom();
          }
        });
      }
    }

    // Update previous message IDs
    _previousMessageIds = messages.map((m) => m.id).toList();

    return LabContainer(
      height: MediaQuery.of(context).size.height / theme.system.scale -
          (16 +
              (LabPlatformUtils.isMobile
                  ? MediaQuery.of(context).padding.top
                  : 20)),
      child: ListView.builder(
        reverse: true,
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        cacheExtent: 500, // Reduce cache to prevent memory issues
        itemCount: messages.length + 1, // +1 for the bottom padding
        itemBuilder: (context, index) {
          // If this is the first item (which is now the bottom due to reverse), return bottom padding
          if (index == 0) {
            return const SizedBox(height: 160);
          }

          final messageIndex =
              index - 1; // Adjust index since we added padding at the beginning
          final message = messages[messageIndex];
          final isOutgoing = message.author.value?.pubkey == activePubkey;

          // For reversed list: visual "previous" is actually next in array, visual "next" is actually previous in array
          final isSameSenderAsPrevious = _isSameSenderAsNext(
              messages, messageIndex); // Visual previous = array next
          final isSameSenderAsNext = _isSameSenderAsPrevious(
              messages, messageIndex); // Visual next = array previous

          // Create a unique key for this message
          final messageKey = GlobalKey();
          _messageKeys[message.id] = messageKey;

          try {
            return RepaintBoundary(
              child: LabMessageBubble(
                key: messageKey,
                message: message,
                isFirstInStack:
                    !isSameSenderAsPrevious, // First in stack for both incoming and outgoing
                isLastInStack:
                    !isSameSenderAsNext, // Last in stack if no next message from same sender
                isOutgoing: isOutgoing,
                onResolveEvent: resolvers.eventResolver,
                onResolveProfile: resolvers.profileResolver,
                onResolveEmoji: resolvers.emojiResolver,
                onResolveHashtag: (identifier) async {
                  return () {};
                },
                onReply: (event) => context.push('/reply-to/${event.id}',
                    extra: (model: event, community: widget.community)),
                onActions: (event) => context.push('/actions/${event.id}',
                    extra: (model: event, community: widget.community)),
                onReactionTap: (reaction) {},
                onZapTap: (zap) {},
                onLinkTap: (url) {},
                onProfileTap: (profile) =>
                    context.push('/profile/${profile.npub}', extra: profile),
              ),
            );
          } catch (e) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: Text('Error rendering message: ${e.toString()}'),
            );
          }
        },
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: LabDurationsData.normal().normal,
        curve: Curves.easeOut,
      );
    }
  }
}
