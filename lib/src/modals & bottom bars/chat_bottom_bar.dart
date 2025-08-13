import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';
import '../providers/search.dart';

class MorphingChatBottomBar extends ConsumerStatefulWidget {
  final Model model;
  final Function(Model) onAddTap;
  final Function(Model) onVoiceTap;
  final Function(Model) onActions;
  final Function(ChatMessage)? onMessageSent;
  final Function(bool)? onExpandedStateChanged;
  final ChatMessage? quotedMessage;

  const MorphingChatBottomBar({
    super.key,
    required this.model,
    required this.onAddTap,
    required this.onVoiceTap,
    required this.onActions,
    this.onMessageSent,
    this.onExpandedStateChanged,
    this.quotedMessage,
  });

  @override
  ConsumerState<MorphingChatBottomBar> createState() =>
      MorphingChatBottomBarState();
}

class MorphingChatBottomBarState extends ConsumerState<MorphingChatBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late PartialChatMessage _partialMessage;
  final GlobalKey _textFieldStateKey = GlobalKey();

  bool get isExpanded => _animationController.value > 0.5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
          milliseconds: 150), // Slightly longer for smoother animation
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // Smoother curve for keyboard animation
    );
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _partialMessage = PartialChatMessage('');

    // Listen for focus changes
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !isExpanded) {
        _expand();
      } else if (!_focusNode.hasFocus && isExpanded) {
        // User manually hid keyboard (e.g., by tapping outside or using back button)
        _collapse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _expand() {
    // Request focus immediately to start keyboard animation
    _focusNode.requestFocus();
    _animationController.forward();
    // Notify parent of expanded state
    if (widget.onExpandedStateChanged != null) {
      widget.onExpandedStateChanged!(true);
    }
  }

  void expandWithReply(ChatMessage messageToReply) {
    _expand();
  }

  // Public method to expand the bottom bar programmatically
  void expand() {
    _expand();
  }

  void _deleteAndCollapse() {
    _controller.clear();
    _onContentChanged('');
    _collapse();
  }

  void _collapse() {
    _animationController.reverse();
    _focusNode.unfocus();
    // Notify parent of collapsed state
    if (widget.onExpandedStateChanged != null) {
      widget.onExpandedStateChanged!(false);
    }
  }

  void _onContentChanged(String content) {
    // Only update if content actually changed to reduce unnecessary rebuilds
    if (_partialMessage.content != content) {
      setState(() {
        _partialMessage = PartialChatMessage(content);
      });
      if (_controller.text != content) {
        _controller.text = content;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: content.length),
        );
      }
    }
  }

  void _sendMessage() async {
    print('DEBUG: _sendMessage called');
    final textFieldState = _textFieldStateKey.currentState;
    if (textFieldState == null) {
      print('DEBUG: textFieldState is null');
      return;
    }

    final editorState =
        (textFieldState as dynamic).editorState as LabEditableShortTextState?;
    if (editorState == null) {
      print('DEBUG: editorState is null');
      return;
    }

    final content = editorState.getTextForPublishing();
    print('DEBUG: content = "$content"');
    if (content.isNotEmpty) {
      try {
        final signer = ref.read(Signer.activeSignerProvider);
        if (signer != null) {
          print('DEBUG: signer found, creating message');
          // Add the Nostr event reference to the message content if we have a quoted message
          String contentWithQuote = content;
          if (widget.quotedMessage != null) {
            final quotedUri = Utils.encodeShareableFromString(
                widget.quotedMessage!.id,
                type: 'nevent');
            // Only add if not already in content
            if (!content.contains(quotedUri)) {
              contentWithQuote = 'nostr:$quotedUri\n$content';
            }
          }

          final message = PartialChatMessage(
            contentWithQuote,
            createdAt: DateTime.now(),
            quotedMessage: widget.quotedMessage,
          );

          // Add community tag
          if (widget.model is Community) {
            final community = widget.model as Community;
            message.event.addTag('h', [community.author.value?.pubkey ?? '']);
          }

          // Add emoji tags from the editor
          final emojiData = editorState.getEmojiData();
          for (final emoji in emojiData) {
            message.event.addTag('emoji', [emoji.name, emoji.url]);
          }

          // Add profile tags from the editor (if needed for mentions)
          final profileNpubs = editorState.getProfileData();
          for (final npub in profileNpubs) {
            message.event.addTag('p', [npub]);
          }

          final signedMessage = await message.signWith(signer);
          print('DEBUG: message signed successfully');

          // Save locally and notify the feed
          await ref
              .read(storageNotifierProvider.notifier)
              .save({signedMessage});
          print('DEBUG: message saved locally');

          // Notify the feed about the new message
          if (widget.onMessageSent != null) {
            widget.onMessageSent!(signedMessage);
            print('DEBUG: onMessageSent callback called');
          }

          // Clear text but maintain focus
          _controller.clear();
          _onContentChanged('');
          // Don't collapse - keep expanded for continued typing
          // Ensure focus is maintained after clearing
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.requestFocus();
          });
        } else {
          print('DEBUG: signer is null');
        }
      } catch (e) {
        print('Error creating message: $e');
      }
    } else {
      print('DEBUG: content is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final resolvers = ref.read(resolversProvider);
    final search = ref.read(searchProvider);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animationValue = _animation.value;
        final isExpanded = animationValue > 0.5;

        return LabBottomBar(
          bottomSafeArea: !isExpanded,
          child: Row(
            children: [
              // Left button (Add) - optimized with single AnimatedContainer
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isExpanded ? 0 : 50,
                child: isExpanded
                    ? const SizedBox.shrink()
                    : LabContainer(
                        padding:
                            const LabEdgeInsets.only(right: LabGapSize.s12),
                        child: LabButton(
                          color: theme.colors.white16,
                          square: true,
                          onTap: () => widget.onAddTap(widget.model),
                          children: [
                            LabIcon.s12(
                              theme.icons.characters.plus,
                              outlineThickness:
                                  LabLineThicknessData.normal().thick,
                              outlineColor: theme.colors.white66,
                            ),
                          ],
                        ),
                      ),
              ),

              // Center content - optimized with single conditional
              Expanded(
                child: isExpanded
                    ? _buildTextField(theme, resolvers, search)
                    : _buildMessageButton(theme),
              ),

              // Right button (Actions) - optimized with single AnimatedContainer
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isExpanded ? 0 : 50,
                child: isExpanded
                    ? const SizedBox.shrink()
                    : LabContainer(
                        padding: const LabEdgeInsets.only(left: LabGapSize.s12),
                        child: LabButton(
                          square: true,
                          color: theme.colors.black33,
                          onTap: () => widget.onActions(widget.model),
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LabIcon.s8(
                                  theme.icons.characters.chevronUp,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                  outlineColor: theme.colors.white66,
                                ),
                                const LabGap.s2(),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageButton(LabThemeData theme) {
    return TapBuilder(
      onTap: _expand,
      builder: (context, state, hasFocus) {
        // Cache scale factor to avoid recalculation
        final scaleFactor = switch (state) {
          TapState.pressed => 0.98,
          TapState.hover => 1.01,
          _ => 1.0,
        };

        return Transform.scale(
          scale: scaleFactor,
          child: LabContainer(
            height: theme.sizes.s40,
            decoration: BoxDecoration(
              color: theme.colors.black33,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: Border.all(
                color: theme.colors.white33,
                width: LabLineThicknessData.normal().thin,
              ),
            ),
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s16,
              right: LabGapSize.s12,
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LabText.med14('Message', color: theme.colors.white33),
                  const Spacer(),
                  TapBuilder(
                    onTap: () => widget.onVoiceTap(widget.model),
                    builder: (context, state, hasFocus) {
                      return LabIcon.s18(
                        theme.icons.characters.voice,
                        color: theme.colors.white33,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      LabThemeData theme, Resolvers resolvers, Search search) {
    return LabKeyboardSubmitHandler(
      onSubmit: _sendMessage,
      child: LabShortTextField(
        key: _textFieldStateKey,
        controller: _controller,
        focusNode: _focusNode,
        placeholder: [
          LabText.reg16(
            'Your Message',
            color: theme.colors.white33,
          ),
        ],
        quotedChatMessage: widget.quotedMessage,
        onSearchProfiles: search.profileSearch,
        onSearchEmojis: search.emojiSearch,
        onResolveEvent: resolvers.eventResolver,
        onResolveProfile: resolvers.profileResolver,
        onResolveEmoji: resolvers.emojiResolver,
        onCameraTap: () {}, // TODO: Implement camera tap
        onEmojiTap: () {}, // TODO: Implement emoji tap
        onGifTap: () {}, // TODO: Implement gif tap
        onAddTap: () {}, // TODO: Implement add tap
        onSendTap: _sendMessage,
        onChevronTap: _collapse,
        onDelete: _deleteAndCollapse,
        onProfileTap: (profile) =>
            context.push('/profile/${profile.npub}', extra: profile),
        onChanged: _onContentChanged,
      ),
    );
  }
}
