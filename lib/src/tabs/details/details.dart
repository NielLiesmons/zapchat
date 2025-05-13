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
    Clipboard.setData(ClipboardData(text: widget.model.event.id ?? ''));
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
    final theme = AppTheme.of(context);

    return Column(
      children: [
        AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          child: Column(
            children: [
              AppSectionTitle(
                'IDENTIFIERS',
              ),
              const AppGap.s2(),
              AppPanel(
                padding: const AppEdgeInsets.all(AppGapSize.none),
                child: Column(
                  children: [
                    AppContainer(
                      padding: const AppEdgeInsets.only(
                          left: AppGapSize.s14,
                          right: AppGapSize.s8,
                          top: AppGapSize.s8,
                          bottom: AppGapSize.s8),
                      child: Row(
                        children: [
                          const AppText.reg14('Publication'),
                          const AppGap.s40(),
                          Expanded(
                            child: AppText.reg14(
                              widget.model.event.shareableId,
                              textOverflow: TextOverflow.ellipsis,
                              color: theme.colors.white66,
                            ),
                          ),
                          const AppGap.s14(),
                          AppSmallButton(
                            inactiveColor: theme.colors.white8,
                            square: true,
                            onTap: _handleEventIdCopy,
                            children: [
                              _showEventIdCheckmark
                                  ? ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: AppIcon.s10(
                                        theme.icons.characters.check,
                                        outlineColor: theme.colors.white66,
                                        outlineThickness:
                                            AppLineThicknessData.normal().thick,
                                      ),
                                    )
                                  : AppIcon.s18(
                                      theme.icons.characters.copy,
                                      outlineColor: theme.colors.white66,
                                      outlineThickness:
                                          AppLineThicknessData.normal().medium,
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppDivider(),
                    AppContainer(
                      padding: const AppEdgeInsets.only(
                          left: AppGapSize.s14,
                          right: AppGapSize.s8,
                          top: AppGapSize.s8,
                          bottom: AppGapSize.s8),
                      child: Row(
                        children: [
                          const AppText.reg14('Profile'),
                          const AppGap.s40(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppContainer(
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
                                      width: AppLineThicknessData.normal().thin,
                                    ),
                                  ),
                                ),
                                const AppGap.s8(),
                                AppText.reg14(
                                  formatNpub(
                                      widget.model.author.value?.npub ?? ''),
                                  textOverflow: TextOverflow.ellipsis,
                                  color: theme.colors.white66,
                                ),
                              ],
                            ),
                          ),
                          const AppGap.s16(),
                          AppSmallButton(
                            inactiveColor: theme.colors.white8,
                            square: true,
                            onTap: _handleProfileIdCopy,
                            children: [
                              _showProfileIdCheckmark
                                  ? ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: AppIcon.s10(
                                        theme.icons.characters.check,
                                        outlineColor: theme.colors.white66,
                                        outlineThickness:
                                            AppLineThicknessData.normal().thick,
                                      ),
                                    )
                                  : AppIcon.s18(
                                      theme.icons.characters.copy,
                                      outlineColor: theme.colors.white66,
                                      outlineThickness:
                                          AppLineThicknessData.normal().medium,
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
        const AppDivider(),
        AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          child: Column(
            children: [
              AppSectionTitle(
                'RAW DATA',
              ),
              const AppGap.s2(),
              AppCodeBlock(
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
