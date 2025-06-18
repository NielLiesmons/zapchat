import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

// TODO: get actual data

class CommunityInfoModal extends ConsumerWidget {
  final Community community;

  const CommunityInfoModal({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);

    return LabModal(
      title: community.name,
      profilePicUrl: community.author.value?.pictureUrl ?? '',
      children: [
        LabText.reg14(community.description ?? '',
            color: theme.colors.white66,
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center),
        const LabGap.s16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () => context.push(
                    '/community/${community.author.value?.pubkey}/info/pricing',
                    extra: community),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabIcon.s20(theme.icons.characters.pricing,
                        gradient: theme.colors.graydient66),
                    const LabGap.s10(),
                    LabText.med14("Pricing"),
                  ],
                ),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabIcon.s20(theme.icons.characters.openBook,
                        gradient: theme.colors.graydient66),
                    const LabGap.s10(),
                    LabText.med14("Guidelines"),
                  ],
                ),
              ),
            ),
          ],
        ),
        const LabGap.s8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabIcon.s20(
                      theme.icons.characters.counter,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LabLineThicknessData.normal().medium,
                    ),
                    const LabGap.s10(),
                    LabText.med14("Alerts"),
                  ],
                ),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabIcon.s20(
                      theme.icons.characters.pin,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LabLineThicknessData.normal().medium,
                    ),
                    const LabGap.s10(),
                    LabText.med14("Pin"),
                  ],
                ),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () => {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabIcon.s20(
                      theme.icons.characters.share,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LabLineThicknessData.normal().medium,
                    ),
                    const LabGap.s10(),
                    LabText.med14("Share"),
                  ],
                ),
              ),
            ),
          ],
        ),
        const LabGap.s16(),
        LabButton(
          children: [
            LabIcon.s12(
              theme.icons.characters.check,
              outlineColor: theme.colors.whiteEnforced,
              outlineThickness: LabLineThicknessData.normal().thick,
            ),
            const LabGap.s12(),
            LabText.med14("Added", color: theme.colors.whiteEnforced),
            const LabGap.s8(),
            LabText.med14("2 Labels",
                color: theme.colors.whiteEnforced.withValues(alpha: 0.66)),
          ],
        ),
        const LabGap.s16(),
        // List of Profiles in the community
        LabPanel(
          padding: LabEdgeInsets.all(LabGapSize.none),
          child: Column(
            children: [
              LabContainer(
                padding: LabEdgeInsets.symmetric(
                    horizontal: LabGapSize.s16, vertical: LabGapSize.s12),
                child: Row(
                  children: [
                    LabProfilePic.fromUrl("fghj",
                        size: LabProfilePicSize
                            .s38), //TODO: get actual active members
                    const LabGap.s12(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabText.med14(
                            "Profile Name",
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          LabText.reg10(
                            "Team, Zap Chad, Designer",
                            color: theme.colors.white66,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const LabGap.s12(),
                    LabBadgeStack.small([
                      'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
                      'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
                      'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
                    ]),
                  ],
                ),
              ),
              const LabDivider(),
              LabContainer(
                padding: LabEdgeInsets.symmetric(
                    horizontal: LabGapSize.s16, vertical: LabGapSize.s12),
                child: Row(
                  children: [
                    LabProfilePic.fromUrl("fghj",
                        size: LabProfilePicSize
                            .s38), //TODO: get actual active members
                    const LabGap.s12(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabText.med14(
                            "Profile Name",
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          LabText.reg10(
                            "Team, Zap Chad",
                            color: theme.colors.white66,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const LabGap.s12(),
                    LabBadgeStack.small([
                      'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
                      'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
                    ]),
                  ],
                ),
              ),
              const LabDivider(),
              LabContainer(
                padding: LabEdgeInsets.symmetric(
                    horizontal: LabGapSize.s16, vertical: LabGapSize.s12),
                child: Row(
                  children: [
                    LabProfilePic.fromUrl("fghj",
                        size: LabProfilePicSize
                            .s38), //TODO: get actual active members
                    const LabGap.s12(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabText.med14(
                            "Profile Name",
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          LabText.reg10(
                            "Zap Chad",
                            color: theme.colors.white66,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const LabGap.s12(),
                    LabBadgeStack.small([
                      'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
                    ]),
                  ],
                ),
              ),
              const LabDivider(),
            ],
          ),
        ),
      ],
    );
  }
}
