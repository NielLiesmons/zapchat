import 'dart:ui';

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppCommunityWelcomeFeed extends StatelessWidget {
  final Community community;

  final VoidCallback onProfileTap;

  const AppCommunityWelcomeFeed({
    super.key,
    required this.community,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

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
              profileImageUrls: [
                'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                'https://npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg.blossom.band/3d84787d7284c879429eb0c8e6dcae0bf94cc50456d4046adf33cf040f8f5504.jpg',
                'https://m.primal.net/Mihk.jpg',
                'https://i.nostr.build/MGAFjgFvpIoFjZ09.jpg',
                'https://files.sovbit.host/media/0689df5847a8d3376892da29622d7c0fdc1ef1958f4bc4471d90966aa1eca9f2/cfba34d66cd67339aca14389b367c02f36fec87c325ab0415143ed8db45c2c74.webp',
                'https://i.nostr.build/MVIJ6OOFSUzzjVEc.jpg',
                'https://m.primal.net/HibA.png',
              ],
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
                  AppArticleCard(
                    article: (PartialArticle(
                      'Zapchat For Dummies',
                      'Content of the article',
                      publishedAt:
                          DateTime.now().subtract(const Duration(minutes: 10)),
                      imageUrl:
                          'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
                      summary:
                          'A brief introduction to a daily driver for Communities and Groups.',
                    )).dummySign(
                        "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"),
                  )
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
                        'Labels We Use',
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
                      AppProfilePicSquare.s48("profilePicUrl"),
                      AppProfilePicSquare.s48("profilePicUrl")
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
                  AppSupportersStage(
                    topThreeSupporters: [
                      PartialProfile(
                        name: 'John C.',
                        pictureUrl:
                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fe1.pxfuel.com%2Fdesktop-wallpaper%2F903%2F679%2Fdesktop-wallpaper-97-aesthetic-best-profile-pic-for-instagram-for-boy-instagram-dp-boys.jpg',
                      ).dummySign(
                          '8fa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac195'),
                      PartialProfile(
                        name: 'Niel Liesmons',
                        pictureUrl:
                            'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                      ).dummySign(
                          'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be'),
                      PartialProfile(
                        name: 'franzap',
                        pictureUrl:
                            'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
                      ).dummySign(
                          '7fa56f5d6962ab1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac194'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
