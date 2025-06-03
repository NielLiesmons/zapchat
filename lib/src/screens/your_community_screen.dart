import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';
import 'package:flutter/material.dart' show Colors;

class PartialCommunity {
  final List<CommunityContentSection> contentSections;
  final String name;
  final String? about;
  final String? picture;
  final String? banner;

  PartialCommunity({
    required this.contentSections,
    required this.name,
    this.about,
    this.picture,
    this.banner,
  });

  factory PartialCommunity.initial(String name) {
    return PartialCommunity(
      name: name,
      contentSections: [
        CommunityContentSection(content: 'Chat', kinds: {1}, feeInSats: 0),
        CommunityContentSection(content: 'Forum', kinds: {2}, feeInSats: 0),
        CommunityContentSection(content: 'Articles', kinds: {3}, feeInSats: 0),
        CommunityContentSection(content: 'Labels', kinds: {4}, feeInSats: 0),
      ],
    );
  }
}

class YourCommunityScreen extends StatefulWidget {
  final Profile profile;
  final String communityName;

  const YourCommunityScreen({
    super.key,
    required this.profile,
    required this.communityName,
  });

  @override
  State<YourCommunityScreen> createState() => _YourCommunityScreenState();
}

class _YourCommunityScreenState extends State<YourCommunityScreen> {
  late PartialCommunity _community;

  @override
  void initState() {
    super.initState();
    _community = PartialCommunity.initial(widget.communityName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: true,
      topBarContent: AppContainer(
        padding: const AppEdgeInsets.symmetric(
          vertical: AppGapSize.s4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppGap.s8(),
                AppText.med14('Your Community'),
                const AppGap.s12(),
                const Spacer(),
                AppSmallButton(
                  onTap: () {},
                  rounded: true,
                  inactiveGradient: theme.colors.blurple33,
                  children: [
                    const AppGap.s4(),
                    AppText.med14('Publish', color: theme.colors.white66),
                    const AppGap.s4(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          const AppGap.s48(),
          const AppGap.s2(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "Profile",
                ),
                AppPanel(
                  padding: const AppEdgeInsets.all(AppGapSize.none),
                  color: theme.colors.gray66,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 1.2,
                            child: AppContainer(
                              decoration: BoxDecoration(
                                color: Color(profileToColor(widget.profile))
                                    .withValues(alpha: 0.16),
                              ),
                              child: widget.profile.banner != null &&
                                      widget.profile.banner!.isNotEmpty
                                  ? Image.network(
                                      widget.profile.banner!,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          Center(
                            child: TapBuilder(
                              onTap: () {},
                              builder: (context, state, isFocused) {
                                double scaleFactor = 1.0;
                                if (state == TapState.pressed) {
                                  scaleFactor = 0.98;
                                } else if (state == TapState.hover) {
                                  scaleFactor = 1.02;
                                }

                                return Transform.scale(
                                  scale: scaleFactor,
                                  child: AppIcon.s32(
                                    theme.icons.characters.camera,
                                    color: theme.colors.white33,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Profile section
                      AppContainer(
                        padding: const AppEdgeInsets.only(
                          left: AppGapSize.s12,
                          right: AppGapSize.s12,
                          top: AppGapSize.s12,
                          bottom: AppGapSize.s10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AppContainer(
                                  height: 40,
                                ),
                                Positioned(
                                  top: -40,
                                  child: AppProfilePic.s80(widget.profile),
                                ),
                              ],
                            ),
                            const AppGap.s56(),
                            TapBuilder(
                              onTap: () {},
                              builder: (context, state, isFocused) {
                                double scaleFactor = 1.0;
                                if (state == TapState.pressed) {
                                  scaleFactor = 0.98;
                                } else if (state == TapState.hover) {
                                  scaleFactor = 1.02;
                                }

                                return Transform.scale(
                                  scale: scaleFactor,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(theme.sizes.s38),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 8, sigmaY: 8),
                                      child: AppContainer(
                                        width: theme.sizes.s38,
                                        height: theme.sizes.s38,
                                        decoration: BoxDecoration(
                                          color: theme.colors.white16,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: AppIcon.s16(
                                            theme.icons.characters.camera,
                                            color: theme.colors.white66,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const AppGap.s12(),
                            Expanded(
                              child: AppInputButton(
                                onTap: () {},
                                color: theme.colors.black8,
                                children: [
                                  AppText.med14(
                                    widget.profile.name ??
                                        formatNpub(widget.profile.npub),
                                    color: theme.colors.white,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  const AppGap.s8(),
                                  AppIcon.s12(
                                    theme.icons.characters.pen,
                                    color: theme.colors.white33,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppContainer(
                        padding: const AppEdgeInsets.only(
                          left: AppGapSize.s12,
                          right: AppGapSize.s12,
                          top: AppGapSize.s4,
                          bottom: AppGapSize.s12,
                        ),
                        child: AppInputButton(
                          onTap: () {},
                          color: theme.colors.black8,
                          topAlignment: true,
                          height: theme.sizes.s64,
                          children: [
                            widget.profile.about != null &&
                                    widget.profile.about!.isNotEmpty
                                ? AppText.reg14(
                                    widget.profile.about!,
                                    color: theme.colors.white,
                                  )
                                : AppText.reg14(
                                    'Community Description',
                                    color: theme.colors.white33,
                                  ),
                            const Spacer(),
                            AppIcon.s12(
                              theme.icons.characters.pen,
                              color: theme.colors.white33,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const AppGap.s12(),
                AppButton(
                  onTap: () {},
                  inactiveColor: theme.colors.gray33,
                  children: [
                    AppIcon.s18(
                      theme.icons.characters.pin,
                      outlineColor: theme.colors.white33,
                      outlineThickness: AppLineThicknessData.normal().medium,
                    ),
                    const AppGap.s12(),
                    AppText.reg14(
                      "Add Pinned Publications",
                      color: theme.colors.white33,
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "Pricing",
                ),
                AppPanelButton(
                  onTap: () {},
                  height: 160,
                  padding: const AppEdgeInsets.all(AppGapSize.none),
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.colors.white.withValues(alpha: 1),
                              theme.colors.white.withValues(alpha: 0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (final section
                                  in _community.contentSections) ...[
                                AppContainer(
                                  padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s12,
                                      vertical: AppGapSize.s8),
                                  child: Row(
                                    children: [
                                      AppEmojiContentType(
                                        contentType: section.content
                                            .toLowerCase()
                                            .replaceAll(RegExp(r's$'), ''),
                                        size: 18,
                                      ),
                                      const AppGap.s10(),
                                      AppText.reg14(
                                        section.content,
                                        color: theme.colors.white66,
                                      ),
                                      const Spacer(),
                                      AppText.med12(
                                        section.feeInSats != null &&
                                                section.feeInSats! > 0
                                            ? '${section.feeInSats}'
                                            : 'Free',
                                      ),
                                    ],
                                  ),
                                ),
                                const AppDivider(),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: ClipRRect(
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: AppButton(
                              onTap: () {},
                              inactiveColor: theme.colors.white8,
                              children: [
                                AppText.reg14(
                                  'Prices & Content Types',
                                  color: theme.colors.white66,
                                ),
                                const AppGap.s12(),
                                AppIcon.s14(
                                  theme.icons.characters.pen,
                                  color: theme.colors.white66,
                                ),
                              ],
                            ),
                          ),
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
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "HOSTING",
                ),
                AppPanelButton(
                  onTap: () {},
                  child: AppText.reg14("Free"),
                ),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "GUIDELINES",
                ),
                AppPanelButton(
                  onTap: () {},
                  child: AppText.reg14("Free"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
