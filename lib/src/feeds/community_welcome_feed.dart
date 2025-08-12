import 'dart:ui';

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LabCommunityWelcomeFeed extends ConsumerWidget {
  final Community community;

  final VoidCallback onProfileTap;

  const LabCommunityWelcomeFeed({
    super.key,
    required this.community,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);
    final profilesState = ref.watch(query<Profile>());
    // final articleState = ref.watch(query<Article>(limit: 1));
    final topSupportersState = ref.watch(query<Profile>(limit: 3));

    if (profilesState case StorageLoading()) {
      return const LabLoadingFeed();
    }

    final profiles = profilesState.models.cast<Profile>();

    return LabScope(
      isInsideScope: true,
      child: LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s12),
        child: Column(
          children: [
            const LabGap.s48(),
            LabCommunityWelcomeHeader(
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
            const LabGap.s16(),
            LabContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s12,
                vertical: LabGapSize.s10,
              ),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: LabText.reg14(
                community.description ?? '',
                color: LabTheme.of(context).colors.white,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            const LabGap.s12(),
            // LabContainer(
            //   width: double.infinity,
            //   alignment: Alignment.center,
            //   padding: const LabEdgeInsets.only(
            //     top: LabGapSize.s10,
            //     bottom: LabGapSize.s12,
            //     left: LabGapSize.s12,
            //     right: LabGapSize.s12,
            //   ),
            //   decoration: BoxDecoration(
            //     color: theme.colors.gray66,
            //     borderRadius: theme.radius.asBorderRadius().rad16,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           const LabGap.s4(),
            //           LabText.med14(
            //             'Pinned Publications',
            //             color: theme.colors.white66,
            //           ),
            //           const Spacer(),
            //           LabIcon.s14(
            //             theme.icons.characters.chevronRight,
            //             outlineColor: theme.colors.white33,
            //             outlineThickness: LabLineThicknessData.normal().medium,
            //           ),
            //           const LabGap.s4(),
            //         ],
            //       ),
            //       const LabGap.s8(),
            //       if (articleState case StorageData(:final models))
            //         if (models.isNotEmpty)
            //           LabArticleCard(
            //             article: models.first,
            //             onProfileTap: (profile) => context
            //                 .push('/profile/${profile.npub}', extra: profile),
            //             onTap: (article) => context
            //                 .push('/article/${article.id}', extra: article),
            //           ), // TODO: fetch actual pinned publications
            //     ],
            //   ),
            // ),
            // const LabGap.s12(),
            LabContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const LabEdgeInsets.only(
                top: LabGapSize.s10,
                bottom: LabGapSize.s12,
                left: LabGapSize.s12,
                right: LabGapSize.s12,
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
                      const LabGap.s4(),
                      LabText.med14(
                        'Content Types',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      LabIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      ),
                      const LabGap.s4(),
                    ],
                  ),
                  const LabGap.s8(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      for (final section in community.contentSections)
                        IntrinsicWidth(
                          child: LabButton(
                            color: theme.colors.white8,
                            children: [
                              LabEmojiContentType(
                                contentType: section.content
                                    .toLowerCase()
                                    .replaceAll(RegExp(r's$'), ''),
                                size: 24,
                              ),
                              const LabGap.s8(),
                              LabText.reg12(section.content)
                            ],
                            onTap: () {},
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const LabGap.s12(),
            LabContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const LabEdgeInsets.only(
                top: LabGapSize.s10,
                bottom: LabGapSize.s12,
                left: LabGapSize.s12,
                right: LabGapSize.s12,
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
                      const LabGap.s4(),
                      LabText.med14(
                        'Labels',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      LabIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      ),
                      const LabGap.s4(),
                    ],
                  ),
                  const LabGap.s8(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      LabLabel(
                        "Questions",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      LabLabel(
                        "Feature Requests",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      LabLabel(
                        "Bugs",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      LabLabel(
                        "Marketing",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      LabLabel(
                        "Big Picture",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                      LabLabel(
                        "Idea Box",
                        isEmphasized: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const LabGap.s12(),
            LabContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const LabEdgeInsets.only(
                top: LabGapSize.s10,
                bottom: LabGapSize.s12,
                left: LabGapSize.s12,
                right: LabGapSize.s12,
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
                      const LabGap.s4(),
                      LabText.med14(
                        'Recommended Apps',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      LabIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      ),
                      const LabGap.s4(),
                    ],
                  ),
                  const LabGap.s8(),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      LabProfilePicSquare.fromUrl(
                        'test',
                        size: LabProfilePicSquareSize.s48,
                      ),
                      LabProfilePicSquare.fromUrl(
                        'test',
                        size: LabProfilePicSquareSize.s48,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const LabGap.s12(),
            LabContainer(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const LabEdgeInsets.only(
                top: LabGapSize.s10,
                bottom: LabGapSize.s12,
                left: LabGapSize.s12,
                right: LabGapSize.s12,
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
                      const LabGap.s4(),
                      LabText.med14(
                        'Supporters',
                        color: theme.colors.white66,
                      ),
                      const Spacer(),
                      LabIcon.s14(
                        theme.icons.characters.chevronRight,
                        outlineColor: theme.colors.white33,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      ),
                      const LabGap.s4(),
                    ],
                  ),
                  const LabGap.s8(),
                  if (topSupportersState case StorageData(:final models)) ...[
                    if (models.isNotEmpty)
                      LabSupportersStage(
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
