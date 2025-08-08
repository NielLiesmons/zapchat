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
    final theme = LabTheme.of(context);

    return LabModal(
      title: "Pricing",
      initialChildSize: 0.64,
      children: [
        const LabGap.s16(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "chat", size: 20),
              const LabGap.s16(),
              LabText.reg14("Chat", color: theme.colors.white66),
              const Spacer(),
              const LabText.med14("Free"),
              const LabGap.s8(),
              LabContainer(
                padding: LabEdgeInsets.only(top: LabGapSize.s2),
                child: LabText.reg12("With Spam Filter",
                    color: theme.colors.white33),
              ),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
        const LabGap.s8(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "thread", size: 20),
              const LabGap.s16(),
              LabText.reg14("Thread", color: theme.colors.white66),
              const Spacer(),
              LabIcon.s12(
                theme.icons.characters.zap,
                gradient: theme.colors.blurple,
              ),
              const LabGap.s4(),
              const LabText.med14("21"),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
        const LabGap.s8(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "article", size: 20),
              const LabGap.s16(),
              LabText.reg14("Article", color: theme.colors.white66),
              const Spacer(),
              LabIcon.s12(
                theme.icons.characters.crown,
                gradient: theme.colors.gold,
              ),
              const LabGap.s8(),
              const LabText.med14("Admin"),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
        const LabGap.s8(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "wiki", size: 20),
              const LabGap.s16(),
              LabText.reg14("Wiki", color: theme.colors.white66),
              const Spacer(),
              LabIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const LabGap.s8(),
              const LabText.med14("Team"),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
        const LabGap.s8(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "app", size: 20),
              const LabGap.s16(),
              LabText.reg14("App", color: theme.colors.white66),
              const Spacer(),
              LabIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const LabGap.s8(),
              const LabText.med14("Team"),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
        const LabGap.s8(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "doc", size: 20),
              const LabGap.s16(),
              LabText.reg14("Docs", color: theme.colors.white66),
              const Spacer(),
              LabIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const LabGap.s8(),
              const LabText.med14("Team"),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
        const LabGap.s8(),
        LabPanel(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Row(children: [
              const LabEmojiContentType(contentType: "poll", size: 20),
              const LabGap.s16(),
              LabText.reg14("Poll", color: theme.colors.white66),
              const Spacer(),
              LabIcon.s14(
                theme.icons.characters.profile,
                gradient: theme.colors.graydient66,
              ),
              const LabGap.s8(),
              const LabText.med14("Team"),
              const LabGap.s12(),
              LabIcon.s12(
                theme.icons.characters.chevronRight,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ])),
      ],
    );
  }
}
