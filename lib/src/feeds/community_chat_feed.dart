import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityChatFeed extends ConsumerStatefulWidget {
  final Community community;
  final ScrollController? scrollController;

  const CommunityChatFeed({
    super.key,
    required this.community,
    this.scrollController,
  });

  @override
  ConsumerState<CommunityChatFeed> createState() => _CommunityChatFeedState();
}

class _CommunityChatFeedState extends ConsumerState<CommunityChatFeed> {
  final Map<String, GlobalKey> _messageKeys = {};
  List<String> _previousMessageIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

  /// Scrolls to the bottom of the chat
  void _scrollToBottom() {
    // Use the passed scroll controller or find one through context
    if (widget.scrollController != null) {
      widget.scrollController!
          .jumpTo(widget.scrollController!.position.maxScrollExtent);
    } else {
      final scrollable = Scrollable.of(context);

      scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    }
  }

  List<List<ChatMessage>> _groupMessages(List<ChatMessage> messages) {
    final groups = <List<ChatMessage>>[];
    List<ChatMessage>? currentGroup;
    String? currentPubkey;
    DateTime? lastMessageTime;

    // Sort messages by timestamp in ascending order (oldest first)
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

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

    // Reverse each group so newest messages are at the bottom
    for (final group in groups) {
      group.reversed.toList();
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final resolvers = ref.read(resolversProvider);

    final state = ref.watch(query<ChatMessage>());
    final cashuZapsState = ref.watch(query<CashuZap>());

    if (state case StorageLoading()) {
      return const Center(child: LabLoadingFeed(type: LoadingFeedType.chat));
    }

    final messages = state.models;
    final cashuZaps = cashuZapsState.models;

    if (messages.isEmpty && cashuZaps.isEmpty) {
      return LabModelEmptyStateCard(
        contentType: "chat",
        onCreateTap: () =>
            context.push('/create/message', extra: widget.community),
      );
    }

    // Group messages by author and time
    final messageGroups = _groupMessages(messages);

    final activeProfile = ref.watch(Signer.activeProfileProvider);

    // Create a single list of all events (messages and zaps) with their timestamps
    final allEvents = <({dynamic model, DateTime timestamp, bool isMessage})>[
      ...messageGroups.map((group) =>
          (model: group, timestamp: group.first.createdAt, isMessage: true)),
      ...cashuZaps.map(
          (zap) => (model: zap, timestamp: zap.createdAt, isMessage: false)),
    ];

    // Sort all events by timestamp (oldest first)
    allEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Simple auto-scroll for new outgoing messages
    if (activeProfile != null) {
      // Count individual outgoing messages (not groups)
      final currentOutgoingCount = messages
          .where(
              (message) => message.author.value?.pubkey == activeProfile.pubkey)
          .length;

      if (currentOutgoingCount > _previousMessageIds.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToBottom();
          }
        });
      }

      // Update the count
      _previousMessageIds =
          List.generate(currentOutgoingCount, (index) => 'msg_$index');
    }

    return Column(
      children: [
        const LabNewMessagesDivider(text: '8 New Messages'),
        ...allEvents.map((event) => Column(
              key: ValueKey(event.isMessage
                  ? (event.model as List<ChatMessage>).first.id
                  : (event.model as CashuZap).id),
              children: [
                if (event.isMessage)
                  Builder(
                    builder: (context) {
                      final messageId =
                          (event.model as List<ChatMessage>).first.id;
                      _messageKeys[messageId] = GlobalKey();
                      return LabMessageStack(
                        key: _messageKeys[messageId],
                        messages: event.model as List<ChatMessage>,
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                        onResolveHashtag: (identifier) async {
                          await Future.delayed(const Duration(seconds: 1));
                          return () {};
                        },
                        isOutgoing: (event.model as List<ChatMessage>)
                                .first
                                .author
                                .value
                                ?.pubkey ==
                            activeProfile?.pubkey,
                        onReply: (event) =>
                            context.push('/reply-to/${event.id}', extra: event),
                        onActions: (event) =>
                            context.push('/actions/${event.id}', extra: event),
                        onReactionTap: (reaction) {},
                        onZapTap: (zap) {},
                        onLinkTap: (url) {},
                        onProfileTap: (profile) => context
                            .push('/profile/${profile.npub}', extra: profile),
                      );
                    },
                  )
                else
                  LabZapBubble(
                    cashuZap: event.model as CashuZap,
                    onResolveEvent: resolvers.eventResolver,
                    onResolveProfile: resolvers.profileResolver,
                    onResolveEmoji: resolvers.emojiResolver,
                    onResolveHashtag: (identifier) async {
                      await Future.delayed(const Duration(seconds: 1));
                      return () {};
                    },
                    isOutgoing:
                        (event.model as CashuZap).author.value?.pubkey ==
                            activeProfile?.pubkey,
                    onReply: (event) =>
                        context.push('/reply-to/${event.id}', extra: event),
                    onActions: (event) =>
                        context.push('/actions/${event.id}', extra: event),
                    onReactionTap: (reaction) {},
                    onZapTap: (zap) {},
                    onLinkTap: (url) {},
                    onProfileTap: (profile) => context
                        .push('/profile/${profile.npub}', extra: profile),
                  ),
                const LabGap.s8(),
              ],
            )),
      ],
    );
  }
}
