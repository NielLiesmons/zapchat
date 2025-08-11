import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

/// Performance-optimized message bubble with caching
class OptimizedMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isOutgoing;
  final bool isFirstInStack;
  final bool isLastInStack;
  final bool isPublishing;
  final Function(Model)? onSendAgain;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;

  const OptimizedMessageBubble({
    super.key,
    required this.message,
    required this.isOutgoing,
    this.isFirstInStack = false,
    this.isLastInStack = false,
    this.isPublishing = false,
    this.onSendAgain,
    required this.onActions,
    required this.onReply,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
  });

  @override
  State<OptimizedMessageBubble> createState() => _OptimizedMessageBubbleState();
}

class _OptimizedMessageBubbleState extends State<OptimizedMessageBubble> {
  // Cache expensive computations
  ShortTextContentType? _cachedContentType;
  String? _cachedProcessedContent;
  String? _lastProcessedContent;

  @override
  void initState() {
    super.initState();
    _precomputeExpensiveOperations();
  }

  @override
  void didUpdateWidget(OptimizedMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only recompute if content actually changed
    if (oldWidget.message.content != widget.message.content) {
      _precomputeExpensiveOperations();
    }
  }

  void _precomputeExpensiveOperations() {
    String contentToProcess = widget.message.content;

    // Only reprocess if content changed
    if (_lastProcessedContent == contentToProcess) return;

    // Cache the expensive RegEx operation
    if (widget.message.quotedMessage.value != null) {
      try {
        final nostrUriMatch =
            RegExp(r'nostr:nevent1[a-zA-Z0-9]+').firstMatch(contentToProcess);
        if (nostrUriMatch != null) {
          final quotedUri = nostrUriMatch.group(0)!;
          if (contentToProcess.startsWith(quotedUri)) {
            contentToProcess =
                contentToProcess.substring(quotedUri.length).trim();
            contentToProcess =
                contentToProcess.replaceFirst(RegExp(r'^[\r\n]+'), '');
          }
        }
      } catch (e) {
        // Ignore errors in content processing
      }
    }

    // Cache the expensive content analysis
    _cachedContentType = LabShortTextRenderer.analyzeContent(contentToProcess);
    _cachedProcessedContent = contentToProcess;
    _lastProcessedContent = widget.message.content;
  }

  @override
  Widget build(BuildContext context) {
    // Use cached values instead of recomputing
    final contentType = _cachedContentType ?? ShortTextContentType.mixed;
    final processedContent = _cachedProcessedContent ?? widget.message.content;

    return RepaintBoundary(
      // Isolate repaints
      child: LabContainer(
        padding: LabEdgeInsets.only(
          left: LabGapSize.s8,
          right: LabGapSize.s8,
          top: widget.isFirstInStack ? LabGapSize.s8 : LabGapSize.s2,
        ),
        child: Row(
          mainAxisAlignment: widget.isOutgoing
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.isOutgoing) ...[
              widget.isLastInStack
                  ? _OptimizedProfilePic(
                      profile: widget.message.author.value,
                      onTap: () => widget
                          .onProfileTap(widget.message.author.value as Profile),
                    )
                  : const LabGap.s32(),
              const LabGap.s4(),
            ] else if (widget.isOutgoing) ...[
              if (contentType != ShortTextContentType.singleImageStack)
                const LabGap.s64(),
              const LabGap.s4(),
            ],
            Flexible(
              child: _OptimizedMessageContent(
                message: widget.message,
                contentType: contentType,
                processedContent: processedContent,
                isOutgoing: widget.isOutgoing,
                isFirstInStack: widget.isFirstInStack,
                isLastInStack: widget.isLastInStack,
                isPublishing: widget.isPublishing,
                onActions: widget.onActions,
                onReply: widget.onReply,
                onResolveEvent: widget.onResolveEvent,
                onResolveProfile: widget.onResolveProfile,
                onResolveEmoji: widget.onResolveEmoji,
                onResolveHashtag: widget.onResolveHashtag,
                onLinkTap: widget.onLinkTap,
              ),
            ),
            if (widget.isOutgoing) ...[
              const LabGap.s4(),
              widget.isLastInStack
                  ? _OptimizedProfilePic(
                      profile: widget.message.author.value,
                      onTap: () => widget
                          .onProfileTap(widget.message.author.value as Profile),
                    )
                  : const LabGap.s32(),
            ],
          ],
        ),
      ),
    );
  }
}

/// Optimized profile pic that doesn't rebuild unnecessarily
class _OptimizedProfilePic extends StatelessWidget {
  final Profile? profile;
  final VoidCallback onTap;

  const _OptimizedProfilePic({
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LabContainer(
        child: LabProfilePic.s32(
          profile,
          onTap: onTap,
        ),
      ),
    );
  }
}

/// Optimized message content that uses cached values
class _OptimizedMessageContent extends StatelessWidget {
  final ChatMessage message;
  final ShortTextContentType contentType;
  final String processedContent;
  final bool isOutgoing;
  final bool isFirstInStack;
  final bool isLastInStack;
  final bool isPublishing;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const _OptimizedMessageContent({
    required this.message,
    required this.contentType,
    required this.processedContent,
    required this.isOutgoing,
    required this.isFirstInStack,
    required this.isLastInStack,
    required this.isPublishing,
    required this.onActions,
    required this.onReply,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return RepaintBoundary(
      child: ShortTextContent(
        contentType: contentType,
        child: IntrinsicWidth(
          child: LabSwipeContainer(
            isTransparent: contentType.isSingleContent,
            decoration: BoxDecoration(
              color: contentType.isSingleContent ? null : theme.colors.gray66,
              gradient: contentType.isSingleContent
                  ? null
                  : isOutgoing
                      ? theme.colors.blurple66
                      : null,
              borderRadius: BorderRadius.only(
                topLeft: theme.radius.rad16,
                topRight: theme.radius.rad16,
                bottomRight: isOutgoing
                    ? (isLastInStack ? theme.radius.rad4 : theme.radius.rad16)
                    : theme.radius.rad16,
                bottomLeft: !isOutgoing
                    ? (isLastInStack ? theme.radius.rad4 : theme.radius.rad16)
                    : theme.radius.rad16,
              ),
            ),
            leftContent: LabIcon.s16(
              theme.icons.characters.reply,
              outlineColor: theme.colors.white66,
              outlineThickness: LabLineThicknessData.normal().medium,
            ),
            rightContent: LabIcon.s10(
              theme.icons.characters.chevronUp,
              outlineColor: theme.colors.white66,
              outlineThickness: LabLineThicknessData.normal().medium,
            ),
            onSwipeLeft: () => onReply(message),
            onSwipeRight: () => onActions(message),
            child: MessageBubbleScope(
              isOutgoing: isOutgoing,
              child: _OptimizedTextContent(
                message: message,
                processedContent: processedContent,
                contentType: contentType,
                isOutgoing: isOutgoing,
                onResolveEvent: onResolveEvent,
                onResolveProfile: onResolveProfile,
                onResolveEmoji: onResolveEmoji,
                onResolveHashtag: onResolveHashtag,
                onLinkTap: onLinkTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Optimized text content that doesn't reparse on every build
class _OptimizedTextContent extends StatelessWidget {
  final ChatMessage message;
  final String processedContent;
  final ShortTextContentType contentType;
  final bool isOutgoing;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const _OptimizedTextContent({
    required this.message,
    required this.processedContent,
    required this.contentType,
    required this.isOutgoing,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IntrinsicWidth(
        child: LabContainer(
          padding: contentType.isSingleContent
              ? const LabEdgeInsets.all(LabGapSize.none)
              : const LabEdgeInsets.only(
                  left: LabGapSize.s8,
                  right: LabGapSize.s8,
                  top: LabGapSize.s4,
                  bottom: LabGapSize.s2,
                ),
          child: Column(
            crossAxisAlignment:
                isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Use the cached processed content instead of reparsing
              LabShortTextRenderer(
                content: processedContent,
                model: message,
                onProfileTap: (profile) {},
                onResolveEvent: onResolveEvent,
                onResolveProfile: onResolveProfile,
                onResolveEmoji: onResolveEmoji,
                onResolveHashtag: onResolveHashtag,
                onLinkTap: onLinkTap,
              ),

              // Optimized reactions and zaps
              if (message.reactions.isNotEmpty || message.zaps.isNotEmpty) ...[
                const LabGap.s4(),
                _OptimizedInteractionPills(
                  message: message,
                  isOutgoing: isOutgoing,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Optimized interaction pills that don't rebuild unnecessarily
class _OptimizedInteractionPills extends StatelessWidget {
  final ChatMessage message;
  final bool isOutgoing;

  const _OptimizedInteractionPills({
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LabInteractionPills(
        zaps: message.zaps.toList(),
        reactions: message.reactions.toList(),
        onZapTap: (zap) {},
        onReactionTap: (reaction) {},
      ),
    );
  }
}
