import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';
import '../providers/resolvers.dart';

class ActionsModal extends ConsumerWidget {
  final Model model;

  const ActionsModal({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);
    final resolvers = ref.read(resolversProvider);

    return LabModal(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TapBuilder(
              onTap: () => context.push,
              builder: (context, state, isFocused) {
                double scaleFactor = 1.0;
                if (state == TapState.pressed) {
                  scaleFactor = 0.98;
                } else if (state == TapState.hover) {
                  scaleFactor = 1.00;
                }

                return AnimatedScale(
                  scale: scaleFactor,
                  duration: LabDurationsData.normal().fast,
                  curve: Curves.easeInOut,
                  child: model is ChatMessage ||
                          model is CashuZap ||
                          model is Zap
                      ? TapBuilder(
                          onTap: () => context.replace('/reply-to/${model.id}',
                              extra: model),
                          builder: (context, state, hasFocus) {
                            return LabContainer(
                              decoration: BoxDecoration(
                                color: theme.colors.black33,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad16,
                                border: Border.all(
                                  color: theme.colors.white33,
                                  width: LabLineThicknessData.normal().thin,
                                ),
                              ),
                              padding: const LabEdgeInsets.all(LabGapSize.s8),
                              child: Column(
                                children: [
                                  model is CashuZap || model is Zap
                                      ? LabZapCard(
                                          zap: model is Zap
                                              ? model as Zap
                                              : null,
                                          cashuZap: model is CashuZap
                                              ? model as CashuZap
                                              : null,
                                          onResolveEvent:
                                              resolvers.eventResolver,
                                          onResolveProfile:
                                              resolvers.profileResolver,
                                          onResolveEmoji:
                                              resolvers.emojiResolver,
                                          onProfileTap: (profile) => context
                                              .push('/profile/${profile.npub}',
                                                  extra: profile),
                                        )
                                      : LabQuotedMessage(
                                          chatMessage: model as ChatMessage,
                                          onResolveEvent:
                                              resolvers.eventResolver,
                                          onResolveProfile:
                                              resolvers.profileResolver,
                                          onResolveEmoji:
                                              resolvers.emojiResolver,
                                        ),
                                  LabContainer(
                                    padding: const LabEdgeInsets.only(
                                      left: LabGapSize.s8,
                                      right: LabGapSize.s8,
                                      top: LabGapSize.s12,
                                      bottom: LabGapSize.s4,
                                    ),
                                    child: Row(
                                      children: [
                                        LabText.med14(
                                          'Reply',
                                          color: theme.colors.white33,
                                        ),
                                        const Spacer(),
                                        LabIcon.s16(
                                          theme.icons.characters.voice,
                                          color: theme.colors.white33,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LabProfilePic.s40(model.author.value),
                                const LabGap.s12(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          LabEmojiImage(
                                            emojiUrl:
                                                'assets/emoji/${getModelContentType(model)}.png',
                                            emojiName:
                                                getModelContentType(model),
                                            size: 16,
                                          ),
                                          const LabGap.s10(),
                                          Expanded(
                                            child: LabCompactTextRenderer(
                                              model: model,
                                              content:
                                                  getModelDisplayText(model),
                                              onResolveEvent:
                                                  resolvers.eventResolver,
                                              onResolveProfile:
                                                  resolvers.profileResolver,
                                              onResolveEmoji:
                                                  resolvers.emojiResolver,
                                              isWhite: true,
                                              isMedium: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const LabGap.s2(),
                                      LabText.reg12(
                                        model.author.value?.name ??
                                            formatNpub(
                                                model.author.value?.npub ?? ''),
                                        color: theme.colors.white66,
                                      ),
                                    ],
                                  ),
                                ),
                                const LabGap.s8(),
                              ],
                            ),
                            Row(
                              children: [
                                LabContainer(
                                  width: theme.sizes.s38,
                                  child: Center(
                                    child: LabContainer(
                                      decoration: BoxDecoration(
                                          color: theme.colors.white33),
                                      width:
                                          LabLineThicknessData.normal().medium,
                                      height: theme.sizes.s16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TapBuilder(
                              onTap: () => context.push('/reply/${model.id}',
                                  extra: model),
                              builder: (context, state, hasFocus) {
                                double scaleFactor = 1.0;
                                if (state == TapState.pressed) {
                                  scaleFactor = 0.99;
                                } else if (state == TapState.hover) {
                                  scaleFactor = 1.005;
                                }

                                return Transform.scale(
                                  scale: scaleFactor,
                                  child: LabContainer(
                                    height: theme.sizes.s40,
                                    decoration: BoxDecoration(
                                      color: theme.colors.black33,
                                      borderRadius:
                                          theme.radius.asBorderRadius().rad16,
                                      border: Border.all(
                                        color: theme.colors.white33,
                                        width:
                                            LabLineThicknessData.normal().thin,
                                      ),
                                    ),
                                    padding:
                                        const LabEdgeInsets.all(LabGapSize.s8),
                                    child: LabContainer(
                                      padding: const LabEdgeInsets.only(
                                        left: LabGapSize.s8,
                                        right: LabGapSize.s8,
                                      ),
                                      child: Row(
                                        children: [
                                          LabText.med14(
                                            'Reply',
                                            color: theme.colors.white33,
                                          ),
                                          const Spacer(),
                                          LabIcon.s16(
                                            theme.icons.characters.voice,
                                            color: theme.colors.white33,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                );
              },
            ),
            const LabGap.s12(),
            const LabSectionTitle('React'),
            LabContainer(
              height: 52,
              width: double.infinity,
              padding: const LabEdgeInsets.only(
                left: LabGapSize.none,
                right: LabGapSize.s8,
                top: LabGapSize.s8,
                bottom: LabGapSize.s8,
              ),
              decoration: BoxDecoration(
                color: theme.colors.black33,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          theme.colors.black.withValues(alpha: 1),
                          theme.colors.black.withValues(alpha: 0),
                        ],
                        stops: const [0.0, 1.0],
                      ).createShader(Rect.fromLTWH(
                          bounds.width - 64, 0, 64, bounds.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const LabGap.s14(),
                            for (final emoji
                                in LabDefaultData.defaultEmoji.take(24)) ...[
                              TapBuilder(
                                onTap: () {
                                  // TODO: Implement emoji reaction
                                },
                                builder: (context, state, isFocused) {
                                  double scaleFactor = 1.0;
                                  if (state == TapState.pressed) {
                                    scaleFactor = 0.98;
                                  } else if (state == TapState.hover) {
                                    scaleFactor = 1.20;
                                  }

                                  return AnimatedScale(
                                    scale: scaleFactor,
                                    duration: LabDurationsData.normal().fast,
                                    curve: Curves.easeInOut,
                                    child: LabContainer(
                                      padding: const LabEdgeInsets.only(
                                          right: LabGapSize.s14),
                                      child: Center(
                                        child: LabEmojiImage(
                                          emojiUrl: emoji.emojiUrl,
                                          emojiName: emoji.emojiName,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            const LabGap.s32(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: theme.radius.asBorderRadius().rad8,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        child: TapBuilder(
                          onTap: () {
                            // TODO: Implement more emojis
                          },
                          builder: (context, state, isFocused) {
                            return LabContainer(
                              height: double.infinity,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.white8,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad8,
                              ),
                              child: Center(
                                child: LabIcon.s8(
                                  theme.icons.characters.chevronDown,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                  outlineColor: theme.colors.white66,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const LabGap.s12(),
            const LabSectionTitle('Zap'),
            LabContainer(
              height: 52,
              width: double.infinity,
              padding: const LabEdgeInsets.only(
                left: LabGapSize.none,
                right: LabGapSize.s8,
                top: LabGapSize.s8,
                bottom: LabGapSize.s8,
              ),
              decoration: BoxDecoration(
                color: theme.colors.black33,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          theme.colors.black.withValues(alpha: 1),
                          theme.colors.black.withValues(alpha: 0),
                        ],
                        stops: const [0.0, 1.0],
                      ).createShader(Rect.fromLTWH(
                          bounds.width - 64, 0, 64, bounds.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const LabGap.s8(),
                            for (final amount
                                in LabDefaultData.defaultAmounts) ...[
                              TapBuilder(
                                onTap: () {
                                  // TODO: Implement zap
                                },
                                builder: (context, state, isFocused) {
                                  double scaleFactor = 1.0;
                                  if (state == TapState.pressed) {
                                    scaleFactor = 0.98;
                                  } else if (state == TapState.hover) {
                                    scaleFactor = 1.02;
                                  }

                                  return AnimatedScale(
                                    scale: scaleFactor,
                                    duration: LabDurationsData.normal().fast,
                                    curve: Curves.easeInOut,
                                    child: LabContainer(
                                      decoration: BoxDecoration(
                                        color: theme.colors.white8,
                                        borderRadius:
                                            theme.radius.asBorderRadius().rad8,
                                      ),
                                      padding: const LabEdgeInsets.symmetric(
                                          horizontal: LabGapSize.s12),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            LabIcon.s12(
                                              theme.icons.characters.zap,
                                              gradient: theme.colors.gold,
                                            ),
                                            const LabGap.s4(),
                                            LabText.bold16(
                                              amount.toStringAsFixed(0),
                                              color: theme.colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const LabGap.s8(),
                            ],
                            const LabGap.s32(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: theme.radius.asBorderRadius().rad8,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        child: TapBuilder(
                          onTap: () {
                            context.replace('/zap/${model.id}', extra: model);
                          },
                          builder: (context, state, isFocused) {
                            return LabContainer(
                              height: double.infinity,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.white8,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad8,
                              ),
                              child: Center(
                                child: LabIcon.s8(
                                  theme.icons.characters.chevronDown,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                  outlineColor: theme.colors.white66,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const LabGap.s12(),
            const LabSectionTitle('Actions'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Expanded(
                    child: LabPanelButton(
                      color: theme.colors.black33,
                      padding: const LabEdgeInsets.only(
                        top: LabGapSize.s20,
                        bottom: LabGapSize.s16,
                      ),
                      onTap: () {
                        switch (i) {
                          case 0:
                            // TODO: Implement open with
                            break;
                          case 1:
                            context.replace('/label/${model.id}', extra: model);
                            break;
                          case 2:
                            // TODO: Implement share
                            break;
                        }
                      },
                      isLight: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LabIcon.s24(
                            i == 0
                                ? theme.icons.characters.openWith
                                : i == 1
                                    ? theme.icons.characters.label
                                    : theme.icons.characters.share,
                            outlineThickness:
                                LabLineThicknessData.normal().medium,
                            outlineColor: theme.colors.white66,
                          ),
                          const LabGap.s10(),
                          LabText.med14(
                            i == 0
                                ? 'Open with'
                                : i == 1
                                    ? 'Label'
                                    : 'Share',
                            color: theme.colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < 2) const LabGap.s12(),
                ],
              ],
            ),
            const LabGap.s12(),
            LabButton(
              onTap: () {
                // TODO: Implement report
              },
              color: theme.colors.black33,
              children: [
                LabText.med14('Report', gradient: theme.colors.rouge),
              ],
            ),
            const LabGap.s12(),
            LabButton(
              onTap: () {
                // TODO: Implement add profile
              },
              children: [
                LabIcon.s16(
                  theme.icons.characters.plus,
                  outlineThickness: LabLineThicknessData.normal().thick,
                  outlineColor: theme.colors.whiteEnforced,
                ),
                const LabGap.s12(),
                LabText.reg14('Add ', color: theme.colors.whiteEnforced),
                LabText.bold14(
                  model.author.value?.name ??
                      formatNpub(model.author.value?.pubkey ?? ''),
                  color: theme.colors.whiteEnforced,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
