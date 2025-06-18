import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../providers/theme_settings.dart';
import 'package:models/models.dart';

class PreferencesModal extends ConsumerWidget {
  const PreferencesModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);
    final themeState = ref.watch(themeSettingsProvider);
    final activeProfile = ref.watch(Signer.activeProfileProvider);

    return LabModal(
      title: 'Preferences',
      bottomBar: LabButton(
        onTap: () {
          Navigator.pop(context);
        },
        children: [
          LabText.med14('Done', color: theme.colors.whiteEnforced),
        ],
      ),
      children: [
        const LabSectionTitle('Theme'),
        LabSelector(
          initialIndex: themeState.when(
            data: (state) => state.colorMode == null
                ? 0
                : state.colorMode == LabThemeColorMode.light
                    ? 1
                    : state.colorMode == LabThemeColorMode.gray
                        ? 2
                        : 3,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          children: [
            LabSelectorButton(
              selectedContent: [LabText.med14('System')],
              unselectedContent: [
                LabText.med14('System', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == null,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [LabText.med14('Light')],
              unselectedContent: [
                LabText.med14('Light', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == LabThemeColorMode.light,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [LabText.med14('Gray')],
              unselectedContent: [
                LabText.med14('Gray', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == LabThemeColorMode.gray,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [LabText.med14('Dark')],
              unselectedContent: [
                LabText.med14('Dark', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == LabThemeColorMode.dark,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
          ],
          onChanged: (index) => Future.microtask(() {
            switch (index) {
              case 0:
                LabResponsiveTheme.of(context).setColorMode(null);
                ref.read(themeSettingsProvider.notifier).setTheme(null);
                break;
              case 1:
                LabResponsiveTheme.of(context)
                    .setColorMode(LabThemeColorMode.light);
                ref
                    .read(themeSettingsProvider.notifier)
                    .setTheme(LabThemeColorMode.light);
                break;
              case 2:
                LabResponsiveTheme.of(context)
                    .setColorMode(LabThemeColorMode.gray);
                ref
                    .read(themeSettingsProvider.notifier)
                    .setTheme(LabThemeColorMode.gray);
                break;
              case 3:
                LabResponsiveTheme.of(context)
                    .setColorMode(LabThemeColorMode.dark);
                ref
                    .read(themeSettingsProvider.notifier)
                    .setTheme(LabThemeColorMode.dark);
                break;
            }
          }),
        ),
        const LabGap.s12(),
        const LabSectionTitle('Text Size'),
        LabSelector(
          initialIndex: LabResponsiveTheme.of(context).textScale ==
                  LabTextScale.small
              ? 0
              : LabResponsiveTheme.of(context).textScale == LabTextScale.normal
                  ? 1
                  : 2,
          children: [
            LabSelectorButton(
              selectedContent: [LabText.med12('Small')],
              unselectedContent: [
                LabText.med14('Small', color: theme.colors.white33)
              ],
              isSelected: LabResponsiveTheme.of(context).textScale ==
                  LabTextScale.small,
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [LabText.med14('Normal')],
              unselectedContent: [
                LabText.med14('Normal', color: theme.colors.white33)
              ],
              isSelected: LabResponsiveTheme.of(context).textScale ==
                  LabTextScale.normal,
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [LabText.med16('Large')],
              unselectedContent: [
                LabText.med16('Large', color: theme.colors.white33)
              ],
              isSelected: LabResponsiveTheme.of(context).textScale ==
                  LabTextScale.large,
              onTap: () {},
            ),
          ],
          onChanged: (index) => Future.microtask(() {
            switch (index) {
              case 0:
                LabResponsiveTheme.of(context).setTextScale(LabTextScale.small);
                LabResponsiveTheme.of(context)
                    .setSystemScale(LabSystemScale.small);
                ref.read(themeSettingsProvider.notifier)
                  ..setTextScale(LabTextScale.small)
                  ..setSystemScale(LabSystemScale.small);
                break;
              case 1:
                LabResponsiveTheme.of(context)
                    .setTextScale(LabTextScale.normal);
                LabResponsiveTheme.of(context)
                    .setSystemScale(LabSystemScale.normal);
                ref.read(themeSettingsProvider.notifier)
                  ..setTextScale(LabTextScale.normal)
                  ..setSystemScale(LabSystemScale.normal);
                break;
              case 2:
                LabResponsiveTheme.of(context).setTextScale(LabTextScale.large);
                LabResponsiveTheme.of(context)
                    .setSystemScale(LabSystemScale.large);
                ref.read(themeSettingsProvider.notifier)
                  ..setTextScale(LabTextScale.large)
                  ..setSystemScale(LabSystemScale.large);
                break;
            }
          }),
        ),
        const LabGap.s12(),
        const LabSectionTitle('Show Others'),
        LabPanel(
          padding: LabEdgeInsets.all(LabGapSize.none),
          child: Column(
            children: [
              LabContainer(
                padding: LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s16,
                  vertical: LabGapSize.s12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [LabText.reg14("When you are typing"), LabSwitch()],
                ),
              ),
              const LabDivider(),
              LabContainer(
                padding: LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s16,
                  vertical: LabGapSize.s12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabTypingBubble(profile: activeProfile),
                    LabText.reg12(
                      "This is what \nothers can see",
                      color: theme.colors.white33,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const LabGap.s12(),
        const LabSectionTitle('Other'),
        LabPanel(
          padding: LabEdgeInsets.all(LabGapSize.none),
          child: Column(
            children: [
              const LabGap.s12(),
              LabText.reg14('// TODO', color: theme.colors.white33),
              const LabGap.s12(),
            ],
          ),
        ),
      ],
    );
  }
}
