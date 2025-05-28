import 'dart:ui';

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCommunityWelcomeFeed extends ConsumerWidget {
  final Community community;

  final VoidCallback onProfileTap;

  const AppCommunityWelcomeFeed({
    super.key,
    required this.community,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final profilesState = ref.watch(query<Profile>());
    final articleState = ref.watch(query<Article>(limit: 1));
    final topSupportersState = ref.watch(query<Profile>(limit: 3));

    if (profilesState case StorageLoading()) {
      return const AppLoadingFeed();
    }

    final profiles = profilesState.models.cast<Profile>();

    return AppScope(
      isInsideScope: true,
      child: AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s12),
        child: Column(
          children: [
            const AppGap.s48(),
            AppCommunityWelcomeHeader(
              community: community,
              onProfileTap: onProfileTap,
              profiles: profiles,
              emojiImageUrls: [
                'https://cdn.satellite.earth/f388f24d87d9d96076a53773c347a79767402d758edd3b2ac21da51db5ce6e73.png',
                'https://cdn.satellite.earth/503809a3c13a45b79506034e767dc693cc87566cf06263be0e28a5e15f3f8711.png',
                'https://cdn.satellite.earth/9eab0a2b2fa26a00f444213c1424ed59745e8b160572964a79739435627a83f6.png',
                'https://cdn.satellite.earth/aa1557833a08864d55bef51146d1ed9b7a19099b2e4e880fe5f2e0aeedf85d69.png',
              ],
            ),
            const AppGap.s16(),
            ClipRRect(
              borderRadius: theme.radius.asBorderRadius().rad16,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: AppContainer(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const AppEdgeInsets.symmetric(
                    horizontal: AppGapSize.s12,
                    vertical: AppGapSize.s10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.gray66,
                    borderRadius: theme.radius.asBorderRadius().rad16,
                  ),
                  child: AppText.reg14(
                    community.description ?? '',
                    color: AppTheme.of(context).colors.white,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const AppGap.s12(),
            AppContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const AppEdgeInsets.only(
                top: AppGapSize.s10,
                bottom: AppGapSize.s12,
                left: AppGapSize.s12,
                right: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppGap.s4(),
                      AppText.med14(
                        'Pinned Publications',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      AppIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: AppLineThicknessData.normal().medium,
                      ),
                      const AppGap.s4(),
                    ],
                  ),
                  const AppGap.s8(),
                  if (articleState case StorageData(:final models))
                    if (models.isNotEmpty)
                      AppArticleCard(
                          article: models
                              .first), // TODO: fetch actual pinned publications
                ],
              ),
            ),
            const AppGap.s12(),
            AppContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const AppEdgeInsets.only(
                top: AppGapSize.s10,
                bottom: AppGapSize.s12,
                left: AppGapSize.s12,
                right: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppGap.s4(),
                      AppText.med14(
                        'Content Types',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      AppIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: AppLineThicknessData.normal().medium,
                      ),
                      const AppGap.s4(),
                    ],
                  ),
                  const AppGap.s8(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      for (final section in community.contentSections)
                        IntrinsicWidth(
                          child: AppButton(
                            inactiveColor: theme.colors.white8,
                            children: [
                              AppEmojiContentType(
                                contentType: section.content
                                    .toLowerCase()
                                    .replaceAll(RegExp(r's$'), ''),
                                size: 24,
                              ),
                              const AppGap.s8(),
                              AppText.reg12(section.content)
                            ],
                            onTap: () {},
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const AppGap.s12(),
            AppContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const AppEdgeInsets.only(
                top: AppGapSize.s10,
                bottom: AppGapSize.s12,
                left: AppGapSize.s12,
                right: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppGap.s4(),
                      AppText.med14(
                        'Labels',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      AppIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: AppLineThicknessData.normal().medium,
                      ),
                      const AppGap.s4(),
                    ],
                  ),
                  const AppGap.s8(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      AppLabel(
                        "Questions",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      AppLabel(
                        "Feature Requests",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      AppLabel(
                        "Bugs",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      AppLabel(
                        "Marketing",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      AppLabel(
                        "Big Picture",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      AppLabel(
                        "Idea Box",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const AppGap.s12(),
            AppContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const AppEdgeInsets.only(
                top: AppGapSize.s10,
                bottom: AppGapSize.s12,
                left: AppGapSize.s12,
                right: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppGap.s4(),
                      AppText.med14(
                        'Recommended Apps',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      AppIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: AppLineThicknessData.normal().medium,
                      ),
                      const AppGap.s4(),
                    ],
                  ),
                  const AppGap.s8(),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      AppProfilePicSquare.fromUrl(
                        'test',
                        size: AppProfilePicSquareSize.s48,
                      ),
                      AppProfilePicSquare.fromUrl(
                        'test',
                        size: AppProfilePicSquareSize.s48,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const AppGap.s12(),
            AppContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const AppEdgeInsets.only(
                top: AppGapSize.s10,
                bottom: AppGapSize.s12,
                left: AppGapSize.s12,
                right: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppGap.s4(),
                      AppText.med14(
                        'Supporters',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      AppIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: AppLineThicknessData.normal().medium,
                      ),
                      const AppGap.s4(),
                    ],
                  ),
                  const AppGap.s8(),
                  if (topSupportersState case StorageData(:final models)) ...[
                    if (models.isNotEmpty)
                      AppSupportersStage(
                        topThreeSupporters: models,
                      ), // TODO: fetch actual supporters
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
