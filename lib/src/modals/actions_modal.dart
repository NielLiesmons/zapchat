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
    final theme = AppTheme.of(context);
    final resolvers = ref.read(resolversProvider);

    return AppInputModal(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reply section
            if (model is ChatMessage || model is CashuZap || model is Zap)
              AppContainer(
                decoration: BoxDecoration(
                  color: theme.colors.black33,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                  border: Border.all(
                    color: theme.colors.white33,
                    width: AppLineThicknessData.normal().thin,
                  ),
                ),
                padding: const AppEdgeInsets.all(AppGapSize.s8),
                child: Column(
                  children: [
                    model is CashuZap || model is Zap
                        ? AppZapCard(
                            zap: model is Zap ? model as Zap : null,
                            cashuZap:
                                model is CashuZap ? model as CashuZap : null,
                            onResolveEvent: resolvers.eventResolver,
                            onResolveProfile: resolvers.profileResolver,
                            onResolveEmoji: resolvers.emojiResolver,
                          )
                        : AppQuotedMessage(
                            chatMessage: model as ChatMessage,
                            onResolveEvent: resolvers.eventResolver,
                            onResolveProfile: resolvers.profileResolver,
                            onResolveEmoji: resolvers.emojiResolver,
                          ),
                    AppContainer(
                      padding: const AppEdgeInsets.only(
                        left: AppGapSize.s8,
                        right: AppGapSize.s8,
                        top: AppGapSize.s12,
                        bottom: AppGapSize.s4,
                      ),
                      child: Row(
                        children: [
                          AppText.med14(
                            'Reply',
                            color: theme.colors.white33,
                          ),
                          const Spacer(),
                          AppIcon.s16(
                            theme.icons.characters.voice,
                            color: theme.colors.white33,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const AppGap.s12(),
            const AppSectionTitle('React'),
            AppContainer(
              height: 52,
              width: double.infinity,
              padding: const AppEdgeInsets.only(
                left: AppGapSize.none,
                right: AppGapSize.s8,
                top: AppGapSize.s8,
                bottom: AppGapSize.s8,
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
                            const AppGap.s14(),
                            for (final emoji
                                in AppDefaultData.defaultEmoji.take(24)) ...[
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
                                    duration: AppDurationsData.normal().fast,
                                    curve: Curves.easeInOut,
                                    child: AppContainer(
                                      padding: const AppEdgeInsets.only(
                                          right: AppGapSize.s14),
                                      child: Center(
                                        child: emoji.emojiUrl != null
                                            ? AppEmojiImage(
                                                emojiUrl: emoji.emojiUrl ?? '',
                                                emojiName: emoji.emojiName,
                                                size: 28,
                                              )
                                            : SizedBox(
                                                width: 28,
                                                height: 28,
                                                child: Center(
                                                  child: AppText.h1(
                                                    emoji.emojiName,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            const AppGap.s32(),
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
                            return AppContainer(
                              height: double.infinity,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.white8,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad8,
                              ),
                              child: Center(
                                child: AppIcon.s8(
                                  theme.icons.characters.chevronDown,
                                  outlineThickness:
                                      AppLineThicknessData.normal().medium,
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

            const AppGap.s12(),
            const AppSectionTitle('Zap'),
            AppContainer(
              height: 52,
              width: double.infinity,
              padding: const AppEdgeInsets.only(
                left: AppGapSize.none,
                right: AppGapSize.s8,
                top: AppGapSize.s8,
                bottom: AppGapSize.s8,
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
                            const AppGap.s8(),
                            for (final amount
                                in AppDefaultData.defaultAmounts) ...[
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
                                    duration: AppDurationsData.normal().fast,
                                    curve: Curves.easeInOut,
                                    child: AppContainer(
                                      decoration: BoxDecoration(
                                        color: theme.colors.white8,
                                        borderRadius:
                                            theme.radius.asBorderRadius().rad8,
                                      ),
                                      padding: const AppEdgeInsets.symmetric(
                                          horizontal: AppGapSize.s12),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AppIcon.s12(
                                              theme.icons.characters.zap,
                                              gradient: theme.colors.gold,
                                            ),
                                            const AppGap.s4(),
                                            AppText.bold16(
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
                              const AppGap.s8(),
                            ],
                            const AppGap.s32(),
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
                            return AppContainer(
                              height: double.infinity,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.white8,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad8,
                              ),
                              child: Center(
                                child: AppIcon.s8(
                                  theme.icons.characters.chevronDown,
                                  outlineThickness:
                                      AppLineThicknessData.normal().medium,
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

            const AppGap.s12(),
            const AppSectionTitle('Actions'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Expanded(
                    child: AppPanelButton(
                      color: theme.colors.black33,
                      padding: const AppEdgeInsets.only(
                        top: AppGapSize.s20,
                        bottom: AppGapSize.s16,
                      ),
                      onTap: () {
                        switch (i) {
                          case 0:
                            // TODO: Implement open with
                            break;
                          case 1:
                            // TODO: Implement label
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
                          AppIcon.s24(
                            i == 0
                                ? theme.icons.characters.openWith
                                : i == 1
                                    ? theme.icons.characters.label
                                    : theme.icons.characters.share,
                            outlineThickness:
                                AppLineThicknessData.normal().medium,
                            outlineColor: theme.colors.white66,
                          ),
                          const AppGap.s10(),
                          AppText.med14(
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
                  if (i < 2) const AppGap.s12(),
                ],
              ],
            ),

            const AppGap.s12(),
            AppButton(
              onTap: () {
                // TODO: Implement report
              },
              inactiveColor: theme.colors.black33,
              children: [
                AppText.med14('Report', gradient: theme.colors.rouge),
              ],
            ),

            const AppGap.s12(),
            AppButton(
              onTap: () {
                // TODO: Implement add profile
              },
              children: [
                AppIcon.s16(
                  theme.icons.characters.plus,
                  outlineThickness: AppLineThicknessData.normal().thick,
                  outlineColor: theme.colors.whiteEnforced,
                ),
                const AppGap.s12(),
                AppText.reg14('Add ', color: theme.colors.whiteEnforced),
                AppText.bold14(
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
