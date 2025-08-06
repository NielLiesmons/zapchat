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
  bool _isLoadingMore = false;
  int _loadedCount = 0;
  bool _hasInitialized = false; // Flag to prevent re-initialization
  bool _hasReachedEnd = false; // Flag to prevent loading when no more messages
  bool _isInitializing = true; // Flag to prevent loading during initialization
  List<ChatMessage> _visibleMessages =
      []; // Keep track of visible messages separately
  DateTime? _lastLoadTime; // Track when we last loaded messages
  static const Duration _loadCooldown = Duration(
      milliseconds: 1000); // Increase cooldown to prevent rapid loading
  int _consecutiveEmptyResults = 0; // Track consecutive empty results
  static const int _maxConsecutiveEmpty =
      3; // Stop after 3 consecutive empty results
  static const int _maxMessagesToLoad =
      500; // Maximum messages to load to prevent infinite loops

  @override
  void initState() {
    super.initState();
    // Don't add scroll listener until initialization is complete
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Don't load during initialization
    if (_isInitializing) {
      return;
    }

    // Check if we need to load more messages when scrolling to the top (since ListView is reversed)
    // Only trigger if we're very close to the top to prevent excessive loads
    if (_scrollController.position.pixels <= 100 &&
        !_isLoadingMore &&
        !_hasReachedEnd &&
        _visibleMessages.length < _maxMessagesToLoad &&
        (_lastLoadTime == null ||
            DateTime.now().difference(_lastLoadTime!) > _loadCooldown)) {
      print('Loading more messages...');
      _loadMoreMessages();
    }
  }

  void _loadMoreMessages() async {
    print(
        '_loadMoreMessages called, _isLoadingMore: $_isLoadingMore, _hasReachedEnd: $_hasReachedEnd, messages: ${_visibleMessages.length}');

    // Multiple safety checks to prevent infinite loading
    if (_isLoadingMore || _hasReachedEnd) {
      print('Skipping load: already loading or reached end');
      return;
    }

    if (_visibleMessages.length >= _maxMessagesToLoad) {
      print(
          'Reached maximum message limit ($_maxMessagesToLoad) - stopping loads');
      setState(() {
        _hasReachedEnd = true;
      });
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _lastLoadTime = DateTime.now();
    });

    try {
      if (_visibleMessages.isNotEmpty) {
        final oldestMessage = _visibleMessages.last;

        // Load older messages
        final newMessages =
            await ref.read(storageNotifierProvider.notifier).query(
                  RequestFilter<ChatMessage>(
                    tags: {
                      '#h': {widget.community.event.pubkey}
                    },
                    limit: 21,
                    until: oldestMessage.createdAt,
                  ).toRequest(),
                  source: LocalAndRemoteSource(background: true),
                );

        if (newMessages.isNotEmpty) {
          _consecutiveEmptyResults = 0; // Reset counter when we get results
          final newMessagesList =
              newMessages.cast<ChatMessage>().reversed.toList();

          // Simple duplicate check - only add messages we don't already have
          final existingIds = _visibleMessages.map((m) => m.id).toSet();
          final uniqueNewMessages = newMessagesList
              .where((msg) => !existingIds.contains(msg.id))
              .toList();

          if (uniqueNewMessages.isNotEmpty) {
            setState(() {
              _visibleMessages.addAll(uniqueNewMessages);
              print(
                  'Added ${uniqueNewMessages.length} unique messages, total: ${_visibleMessages.length}');
            });
          } else {
            // All messages are duplicates, we've reached the end
            setState(() {
              _hasReachedEnd = true;
              print(
                  'Reached end of messages - all new messages are duplicates');
            });
          }
        } else {
          // No more messages available
          _consecutiveEmptyResults++;
          if (_consecutiveEmptyResults >= _maxConsecutiveEmpty) {
            setState(() {
              _hasReachedEnd = true;
              print(
                  'Reached end of messages - no more older messages available after $_consecutiveEmptyResults consecutive empty results');
            });
          } else {
            print(
                'Empty result $_consecutiveEmptyResults/$_maxConsecutiveEmpty - will try again');
          }
        }
      }
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
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

    // Use reactive query only for initial loading
    if (!_hasInitialized) {
      final chatMessagesState = ref.watch(query<ChatMessage>(
        limit: 21,
        tags: {
          '#h': {widget.community.event.pubkey}
        },
        and: (msg) => {msg.author},
      ));

      if (chatMessagesState case StorageData(:final models)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _visibleMessages = models.cast<ChatMessage>().toList();
            _hasInitialized = true;
            _isInitializing = false; // Allow scroll-based loading now
            print(
                'Initialized _visibleMessages with ${_visibleMessages.length} messages');

            // Add scroll listener only after initialization is complete
            _scrollController.addListener(_onScroll);
          });
        });
      }

      if (chatMessagesState case StorageLoading()) {
        return const LabLoadingFeed(type: LoadingFeedType.chat);
      }

      if (chatMessagesState case StorageError()) {
        return LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s12),
          child: LabModelEmptyStateCard(
            contentType: "chat",
            onCreateTap: () =>
                context.push('/create/message', extra: widget.community),
          ),
        );
      }

      return const LabLoadingFeed(type: LoadingFeedType.chat);
    }

    // Show empty state if no messages
    if (_visibleMessages.isEmpty) {
      return LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s12),
        child: LabModelEmptyStateCard(
          contentType: "chat",
          onCreateTap: () =>
              context.push('/create/message', extra: widget.community),
        ),
      );
    }

    return _buildChatList(theme, activePubkey, resolvers);
  }

  Widget _buildChatList(
      LabThemeData theme, String? activePubkey, Resolvers resolvers) {
    return LabContainer(
      height: MediaQuery.of(context).size.height / theme.system.scale -
          (12 +
              (LabPlatformUtils.isMobile
                  ? MediaQuery.of(context).padding.top
                  : 20)),
      child: CustomScrollView(
        reverse: true,
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 1000,
        slivers: [
          // Bottom padding for input area
          SliverToBoxAdapter(
            child: SizedBox(
                height: 172 +
                    MediaQuery.of(context).padding.bottom +
                    (LabPlatformUtils.isMobile ? 0 : 10)),
          ),
          // Messages list
          SliverList.builder(
            itemCount: _visibleMessages.length,
            itemBuilder: (context, index) {
              final message = _visibleMessages[index];
              final isOutgoing = message.author.value?.pubkey == activePubkey;

              // For reversed list: visual "previous" is actually next in array, visual "next" is actually previous in array
              final isSameSenderAsPrevious = _isSameSenderAsNext(
                  _visibleMessages, index); // Visual previous = array next
              final isSameSenderAsNext = _isSameSenderAsPrevious(
                  _visibleMessages, index); // Visual next = array previous

              // Create a unique key for this message
              final messageKey = GlobalKey();
              _messageKeys[message.id] = messageKey;

              try {
                return RepaintBoundary(
                  key: ValueKey(message.id),
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
                    onProfileTap: (profile) => context
                        .push('/profile/${profile.npub}', extra: profile),
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
        ],
      ),
    );
  }
}
