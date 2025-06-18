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
  final ScrollController _scrollController = ScrollController();
  String? _lastOutgoingMessageId;
  final Map<String, GlobalKey> _messageKeys = {};
  bool _showScrollButton = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = maxScroll - currentScroll;

    setState(() {
      _showScrollButton = delta > 40;
    });
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.0, // Align to top
    );

    return true;
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
    final theme = LabTheme.of(context);
    final resolvers = ref.read(resolversProvider);

    final state = ref.watch(query<ChatMessage>());
    final cashuZapsState = ref.watch(query<CashuZap>());

    if (state case StorageLoading()) {
      return const Center(child: LabLoadingFeed(type: LoadingFeedType.chat));
    }

    final messages = state.models;
    final cashuZaps = cashuZapsState.models;

    if (messages.isEmpty && cashuZaps.isEmpty) {
      return const Center(
        child: Text('No messages yet'),
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

    // Check for new outgoing messages
    if (activeProfile != null) {
      for (final event in allEvents) {
        if (event.isMessage) {
          final messageGroup = event.model as List<ChatMessage>;
          final message = messageGroup.first;
          if (message.author.value?.pubkey == activeProfile.pubkey &&
              message.id != _lastOutgoingMessageId) {
            // Found a new outgoing message
            _lastOutgoingMessageId = message.id;
            // Schedule scroll after the build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToMessage(message.id);
            });
            break;
          }
        }
      }
    }

    // The Chat feed is placed inside a container with a fixed height
    // This is needed because we're in an LabScreen widgetthat by default scroll in the other direction and cannot really allow for fine-grained scroll automation.
    return LabContainer(
      height: MediaQuery.of(context).size.height / theme.system.scale -
          184 -
          (LabPlatformUtils.isMobile
              ? MediaQuery.of(context).padding.top / theme.system.scale +
                  MediaQuery.of(context).padding.bottom / theme.system.scale
              : 26.0),
      padding: const LabEdgeInsets.all(LabGapSize.s6),
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            physics: ScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: allEvents.length + 1, // +1 for the divider
            itemBuilder: (context, index) {
              if (index == 0) {
                return const LabNewMessagesDivider(text: '8 New Mssages');
              }
              final event = allEvents[index - 1];
              return Column(
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
                          onReply: (event) => context
                              .push('/reply-to/${event.id}', extra: event),
                          onActions: (event) => context
                              .push('/actions/${event.id}', extra: event),
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
              );
            },
          ),
          Positioned(
            right: 10,
            bottom: 6,
            child: _showScrollButton
                ? LabFloatingButton(
                    icon: LabIcon.s12(
                      theme.icons.characters.arrowDown,
                      outlineThickness: LabLineThicknessData.normal().medium,
                      outlineColor: theme.colors.white66,
                    ),
                    onTap: () {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
