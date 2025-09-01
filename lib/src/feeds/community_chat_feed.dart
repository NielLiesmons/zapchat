import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

import '../modals & bottom bars/chat_bottom_bar.dart';
// import '../providers/communities_provider.dart';
import '../providers/resolvers.dart';
import '../providers/url_launcher_provider.dart';

class CommunityChatFeed extends ConsumerStatefulWidget {
  final Community community;
  final String? activePubkey;

  const CommunityChatFeed({
    super.key,
    required this.community,
    this.activePubkey,
  });

  @override
  ConsumerState<CommunityChatFeed> createState() => _CommunityChatFeedState();
}

class _CommunityChatFeedState extends ConsumerState<CommunityChatFeed> {
  final GlobalKey<MorphingChatBottomBarState> _bottomBarKey =
      GlobalKey<MorphingChatBottomBarState>();

  // Local UI state
  bool _isBottomBarExpanded = false;
  ChatMessage? _quotedMessage;
  String? _currentPublishingMessageId;
  final Set<String> _failedPublishMessageIds = {};

  // Smooth scrolling/watch pause for performance
  late final ScrollController _scrollController;
  // Timer? _scrollPauseTimer; // reserved for future scroll throttling

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);

    super.dispose();
  }

  void _onScroll() {}

  (bool, bool) _getMessageStackInfo(List<ChatMessage> messages, int index) {
    final isFirstInStack = () {
      if (index >= messages.length - 1) return true;
      final current = messages[index];
      final next = messages[index + 1];
      if (current.author.value?.pubkey == next.author.value?.pubkey) {
        final diff = next.createdAt.difference(current.createdAt).inMinutes;
        return diff.abs() > 21;
      }
      return true;
    }();

    final isLastInStack = () {
      if (index <= 0) return true;
      final current = messages[index];
      final prev = messages[index - 1];
      if (current.author.value?.pubkey == prev.author.value?.pubkey) {
        final diff = current.createdAt.difference(prev.createdAt).inMinutes;
        return diff.abs() > 21;
      }
      return true;
    }();

    return (isFirstInStack, isLastInStack);
  }

  void _handleNewMessage(ChatMessage message) async {
    setState(() {
      _currentPublishingMessageId = message.id;
      _quotedMessage = null;
    });
    await _publishMessage(message);
  }

  Future<void> _publishMessage(ChatMessage message) async {
    try {
      final communityRelayUrls = widget.community.relayUrls;
      final source = communityRelayUrls.isNotEmpty
          ? RemoteSource(group: 'custom', relayUrls: {communityRelayUrls.first})
          : const RemoteSource();

      final response = await ref
          .read(storageNotifierProvider.notifier)
          .publish({message}, source: source);

      // Check if any relay accepted the message
      final eventId = message.event.id;
      final relayStates = response.results[eventId] ?? {};
      final bool anyAccepted = relayStates.any((s) => s.accepted);

      print(
          'Event ID: $eventId, Relay states: $relayStates, anyAccepted: $anyAccepted');

      // Debug: see what the relay is actually saying
      for (final state in relayStates) {
        print(
            'Relay state: accepted=${state.accepted}, message=${state.message}');
      }

      if (anyAccepted) {
        // Success - remove from failed set
        if (_failedPublishMessageIds.contains(message.id)) {
          setState(() => _failedPublishMessageIds.remove(message.id));
        }
      } else {
        // Failed - add to failed set
        setState(() => _failedPublishMessageIds.add(message.id));
      }
    } catch (e) {
      // On exception, mark as failed
      setState(() => _failedPublishMessageIds.add(message.id));
    } finally {
      if (mounted) {
        setState(() => _currentPublishingMessageId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvers = ref.read(resolversProvider);
    final activePubkey =
        widget.activePubkey ?? ref.read(Signer.activePubkeyProvider);

    // Direct query for latest 50 messages
    final messagesState = ref.watch(
      query<ChatMessage>(
        tags: {
          '#h': {widget.community.author.value?.pubkey ?? ''}
        },
        and: (c) => {c.author, c.reactions, c.zaps},
        limit: 300,
      ),
    );
    return Stack(
      children: [
        // Show loading state
        if (messagesState is StorageLoading)
          const SingleChildScrollView(
            child: LabLoadingFeed(type: LoadingFeedType.chat),
          ),

        // Show empty state if no messages
        if (messagesState is StorageData && messagesState.models.isEmpty)
          Padding(
            padding: const EdgeInsets.only(
                top: 116, bottom: 16, left: 16, right: 16),
            child: LabModelEmptyStateCard(
              contentType: 'chat',
              onCreateTap: () =>
                  context.push('/create/message', extra: widget.community),
            ),
          ),

        // Show messages
        if (messagesState is StorageData &&
            messagesState.models.isNotEmpty) ...[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: 116,
                bottom: _isBottomBarExpanded ? 128 : 91,
              ),
              reverse: true, // Newest at bottom
              itemCount: messagesState.models.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              cacheExtent: 600,
              itemBuilder: (context, index) {
                final message = messagesState.models[index];
                final isOutgoing = activePubkey == null
                    ? false
                    : message.author.value?.pubkey == activePubkey;
                final (isFirstInStack, isLastInStack) =
                    _getMessageStackInfo(messagesState.models, index);

                return LabMessageBubble(
                  message: message,
                  isOutgoing: isOutgoing,
                  isFirstInStack: isFirstInStack,
                  isLastInStack: isLastInStack,
                  isPublishing:
                      isOutgoing && message.id == _currentPublishingMessageId,
                  onSendAgain: isOutgoing &&
                          _failedPublishMessageIds.contains(message.id) &&
                          message.id != _currentPublishingMessageId
                      ? (model) async {
                          final m = model as ChatMessage;
                          // Clear failed state before retrying
                          setState(() => _failedPublishMessageIds.remove(m.id));
                          // Re-sign the message before retry (relay rejected due to missing sig)
                          final signer = ref.read(Signer.activeSignerProvider);
                          if (signer != null) {
                            final partialMessage =
                                m.toPartial<PartialChatMessage>();
                            final reSignedMessage =
                                await partialMessage.signWith(signer);
                            _handleNewMessage(reSignedMessage);
                          }
                        }
                      : null,
                  onActions: (model) => context.push(
                    '/actions/${model.id}',
                    extra: (
                      model: model,
                      community: widget.community,
                      onLocalReply: (m) {
                        setState(() {
                          _quotedMessage = m as ChatMessage;
                          _isBottomBarExpanded = true;
                        });
                        _bottomBarKey.currentState?.expand();
                      },
                    ),
                  ),
                  onReply: (model) {
                    setState(() {
                      _quotedMessage = model as ChatMessage;
                      _isBottomBarExpanded = true;
                    });
                    _bottomBarKey.currentState?.expand();
                  },
                  onResolveEvent: resolvers.eventResolver,
                  onResolveProfile: resolvers.profileResolver,
                  onResolveEmoji: resolvers.emojiResolver,
                  onResolveHashtag: resolvers.hashtagResolver,
                  onLinkTap: (url) {
                    ref.read(urlLauncherProvider).launchUrl(url);
                  },
                  onProfileTap: (profile) {
                    context.push('/profile/${profile.npub}', extra: profile);
                  },
                  activePubkey: activePubkey,
                );
              },
            ),
          ),
        ],

        // Bottom bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: MorphingChatBottomBar(
            key: _bottomBarKey,
            model: widget.community,
            quotedMessage: _quotedMessage,
            onAddTap: (_) {},
            onVoiceTap: (_) {},
            onActions: (_) {},
            onMessageSent: _handleNewMessage,
            onExpandedStateChanged: (expanded) {
              if (_isBottomBarExpanded != expanded) {
                setState(() => _isBottomBarExpanded = expanded);
              }
            },
          ),
        ),
      ],
    );
  }
}
