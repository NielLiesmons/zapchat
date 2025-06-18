import 'package:flutter/services.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'dart:convert';

class DetailsTab extends StatefulWidget {
  final Model model;

  const DetailsTab({
    super.key,
    required this.model,
  });

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab>
    with SingleTickerProviderStateMixin {
  bool _showEventIdCheckmark = false;
  bool _showProfileIdCheckmark = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
    ]).animate(_scaleController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleEventIdCopy() {
    Clipboard.setData(ClipboardData(text: widget.model.event.id));
    setState(() => _showEventIdCheckmark = true);
    _scaleController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showEventIdCheckmark = false);
    });
  }

  void _handleProfileIdCopy() {
    Clipboard.setData(
        ClipboardData(text: widget.model.author.value?.npub ?? ''));
    setState(() => _showProfileIdCheckmark = true);
    _scaleController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showProfileIdCheckmark = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      children: [
        LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s12),
          child: Column(
            children: [
              LabSectionTitle(
                'IDENTIFIERS',
              ),
              const LabGap.s2(),
              LabPanel(
                padding: const LabEdgeInsets.all(LabGapSize.none),
                child: Column(
                  children: [
                    LabContainer(
                      padding: const LabEdgeInsets.only(
                          left: LabGapSize.s14,
                          right: LabGapSize.s8,
                          top: LabGapSize.s8,
                          bottom: LabGapSize.s8),
                      child: Row(
                        children: [
                          const LabText.reg14('Publication'),
                          const LabGap.s40(),
                          Expanded(
                            child: LabText.reg14(
                              widget.model.event.shareableId,
                              textOverflow: TextOverflow.ellipsis,
                              color: theme.colors.white66,
                            ),
                          ),
                          const LabGap.s14(),
                          LabSmallButton(
                            inactiveColor: theme.colors.white8,
                            square: true,
                            onTap: _handleEventIdCopy,
                            children: [
                              _showEventIdCheckmark
                                  ? ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: LabIcon.s10(
                                        theme.icons.characters.check,
                                        outlineColor: theme.colors.white66,
                                        outlineThickness:
                                            LabLineThicknessData.normal().thick,
                                      ),
                                    )
                                  : LabIcon.s18(
                                      theme.icons.characters.copy,
                                      outlineColor: theme.colors.white66,
                                      outlineThickness:
                                          LabLineThicknessData.normal().medium,
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const LabDivider(),
                    LabContainer(
                      padding: const LabEdgeInsets.only(
                          left: LabGapSize.s14,
                          right: LabGapSize.s8,
                          top: LabGapSize.s8,
                          bottom: LabGapSize.s8),
                      child: Row(
                        children: [
                          const LabText.reg14('Profile'),
                          const LabGap.s40(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LabContainer(
                                  height: theme.sizes.s8,
                                  width: theme.sizes.s8,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      profileToColor(
                                          widget.model.author.value!),
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: theme.colors.white16,
                                      width: LabLineThicknessData.normal().thin,
                                    ),
                                  ),
                                ),
                                const LabGap.s8(),
                                LabText.reg14(
                                  formatNpub(
                                      widget.model.author.value?.npub ?? ''),
                                  textOverflow: TextOverflow.ellipsis,
                                  color: theme.colors.white66,
                                ),
                              ],
                            ),
                          ),
                          const LabGap.s16(),
                          LabSmallButton(
                            inactiveColor: theme.colors.white8,
                            square: true,
                            onTap: _handleProfileIdCopy,
                            children: [
                              _showProfileIdCheckmark
                                  ? ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: LabIcon.s10(
                                        theme.icons.characters.check,
                                        outlineColor: theme.colors.white66,
                                        outlineThickness:
                                            LabLineThicknessData.normal().thick,
                                      ),
                                    )
                                  : LabIcon.s18(
                                      theme.icons.characters.copy,
                                      outlineColor: theme.colors.white66,
                                      outlineThickness:
                                          LabLineThicknessData.normal().medium,
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const LabDivider(),
        LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s12),
          child: Column(
            children: [
              LabSectionTitle(
                'RAW DATA',
              ),
              const LabGap.s2(),
              LabCodeBlock(
                code: jsonEncode(widget.model.toMap()),
                language: 'JSON',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
