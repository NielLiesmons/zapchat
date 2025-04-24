import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

class CommunityInfoModal extends ConsumerWidget {
  final Community community;

  const CommunityInfoModal({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: community.name,
      profilePicUrl: community.author.value?.pictureUrl ?? '',
      children: [
        AppText.reg14(community.description ?? '',
            color: theme.colors.white66,
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center),
        const AppGap.s16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => context.push(
                    '/chat/${community.author.value?.pubkey}/info/pricing',
                    extra: community),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.s20(theme.icons.characters.pricing,
                        gradient: theme.colors.graydient66),
                    const AppGap.s10(),
                    AppText.med14("Pricing"),
                  ],
                ),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.s20(theme.icons.characters.openBook,
                        gradient: theme.colors.graydient66),
                    const AppGap.s10(),
                    AppText.med14("Guidelines"),
                  ],
                ),
              ),
            ),
          ],
        ),
        const AppGap.s8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.s20(
                      theme.icons.characters.counter,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    const AppGap.s10(),
                    AppText.med14("Alerts"),
                  ],
                ),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.s20(
                      theme.icons.characters.pin,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    const AppGap.s10(),
                    AppText.med14("Pin"),
                  ],
                ),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.s20(
                      theme.icons.characters.share,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    const AppGap.s10(),
                    AppText.med14("Share"),
                  ],
                ),
              ),
            ),
          ],
        ),
        const AppGap.s16(),
        AppButton(
          children: [
            AppIcon(
              theme.icons.characters.check,
              outlineColor: theme.colors.whiteEnforced,
              outlineThickness: LineThicknessData.normal().thick,
            ),
            const AppGap.s12(),
            AppText.med14("Added", color: theme.colors.whiteEnforced),
            const AppGap.s8(),
            AppText.med14("2 Labels",
                color: theme.colors.whiteEnforced.withValues(alpha: 0.66)),
          ],
        ),
        const AppGap.s16(),
        AppPanel(
          padding: AppEdgeInsets.all(AppGapSize.none),
          child: Column(
            children: List.generate(
                20,
                (index) => [
                      AppContainer(
                        padding: AppEdgeInsets.symmetric(
                            horizontal: AppGapSize.s16,
                            vertical: AppGapSize.s12),
                        child: Row(children: [
                          AppProfilePic.s32("fghj"),
                          const AppGap.s12(),
                          AppText.med14("Profile Name"),
                          const AppGap.s12(),
                        ]),
                      ),
                      if (index < 19) const AppDivider(),
                    ]).expand((e) => e).toList(),
          ),
        ),
      ],
    );
  }
}
