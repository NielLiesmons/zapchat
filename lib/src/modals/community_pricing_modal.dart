import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class CommunityPricingModal extends ConsumerWidget {
  final Community community;

  const CommunityPricingModal({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Pricing",
      initialChildSize: 0.64,
      children: [
        const AppGap.s16(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "chat", size: 20),
              const AppGap.s16(),
              AppText.reg14("Chat", color: theme.colors.white66),
              const Spacer(),
              const AppText.med14("Free"),
              const AppGap.s8(),
              AppContainer(
                padding: AppEdgeInsets.only(top: AppGapSize.s2),
                child: AppText.reg12("With Spam Filter",
                    color: theme.colors.white33),
              ),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
        const AppGap.s8(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "post", size: 20),
              const AppGap.s16(),
              AppText.reg14("Post", color: theme.colors.white66),
              const Spacer(),
              AppIcon.s12(
                theme.icons.characters.zap,
                gradient: theme.colors.blurple,
              ),
              const AppGap.s4(),
              const AppText.med14("21"),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
        const AppGap.s8(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "article", size: 20),
              const AppGap.s16(),
              AppText.reg14("Article", color: theme.colors.white66),
              const Spacer(),
              AppIcon.s12(
                theme.icons.characters.crown,
                gradient: theme.colors.gold,
              ),
              const AppGap.s8(),
              const AppText.med14("Admin"),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
        const AppGap.s8(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "wiki", size: 20),
              const AppGap.s16(),
              AppText.reg14("Wiki", color: theme.colors.white66),
              const Spacer(),
              AppIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const AppGap.s8(),
              const AppText.med14("Team"),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
        const AppGap.s8(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "app", size: 20),
              const AppGap.s16(),
              AppText.reg14("App", color: theme.colors.white66),
              const Spacer(),
              AppIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const AppGap.s8(),
              const AppText.med14("Team"),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
        const AppGap.s8(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "doc", size: 20),
              const AppGap.s16(),
              AppText.reg14("Docs", color: theme.colors.white66),
              const Spacer(),
              AppIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const AppGap.s8(),
              const AppText.med14("Team"),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
        const AppGap.s8(),
        AppPanel(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Row(children: [
              const AppEmojiContentType(contentType: "poll", size: 20),
              const AppGap.s16(),
              AppText.reg14("Poll", color: theme.colors.white66),
              const Spacer(),
              AppIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const AppGap.s8(),
              const AppText.med14("Team"),
              const AppGap.s12(),
              AppIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            ])),
      ],
    );
  }
}
