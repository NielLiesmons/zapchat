import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../providers/theme_settings.dart';
import 'package:models/models.dart';

class PreferencesModal extends ConsumerWidget {
  const PreferencesModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final themeState = ref.watch(themeSettingsProvider);
    final activeProfile = ref.watch(Signer.activeProfileProvider);

    return AppModal(
      title: 'Preferences',
      bottomBar: AppButton(
        onTap: () {
          Navigator.pop(context);
        },
        children: [
          AppText.med14('Done', color: theme.colors.whiteEnforced),
        ],
      ),
      children: [
        const AppSectionTitle('Theme'),
        AppSelector(
          initialIndex: themeState.when(
            data: (state) => state.colorMode == null
                ? 0
                : state.colorMode == AppThemeColorMode.light
                    ? 1
                    : state.colorMode == AppThemeColorMode.gray
                        ? 2
                        : 3,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          children: [
            AppSelectorButton(
              selectedContent: [AppText.med14('System')],
              unselectedContent: [
                AppText.med14('System', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == null,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [AppText.med14('Light')],
              unselectedContent: [
                AppText.med14('Light', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == AppThemeColorMode.light,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [AppText.med14('Gray')],
              unselectedContent: [
                AppText.med14('Gray', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == AppThemeColorMode.gray,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [AppText.med14('Dark')],
              unselectedContent: [
                AppText.med14('Dark', color: theme.colors.white33)
              ],
              isSelected: themeState.when(
                data: (state) => state.colorMode == AppThemeColorMode.dark,
                loading: () => false,
                error: (_, __) => false,
              ),
              onTap: () {},
            ),
          ],
          onChanged: (index) => Future.microtask(() {
            switch (index) {
              case 0:
                AppResponsiveTheme.of(context).setColorMode(null);
                ref.read(themeSettingsProvider.notifier).setTheme(null);
                break;
              case 1:
                AppResponsiveTheme.of(context)
                    .setColorMode(AppThemeColorMode.light);
                ref
                    .read(themeSettingsProvider.notifier)
                    .setTheme(AppThemeColorMode.light);
                break;
              case 2:
                AppResponsiveTheme.of(context)
                    .setColorMode(AppThemeColorMode.gray);
                ref
                    .read(themeSettingsProvider.notifier)
                    .setTheme(AppThemeColorMode.gray);
                break;
              case 3:
                AppResponsiveTheme.of(context)
                    .setColorMode(AppThemeColorMode.dark);
                ref
                    .read(themeSettingsProvider.notifier)
                    .setTheme(AppThemeColorMode.dark);
                break;
            }
          }),
        ),
        const AppGap.s12(),
        const AppSectionTitle('Text Size'),
        AppSelector(
          initialIndex: AppResponsiveTheme.of(context).textScale ==
                  AppTextScale.small
              ? 0
              : AppResponsiveTheme.of(context).textScale == AppTextScale.normal
                  ? 1
                  : 2,
          children: [
            AppSelectorButton(
              selectedContent: [AppText.med12('Small')],
              unselectedContent: [
                AppText.med14('Small', color: theme.colors.white33)
              ],
              isSelected: AppResponsiveTheme.of(context).textScale ==
                  AppTextScale.small,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [AppText.med14('Normal')],
              unselectedContent: [
                AppText.med14('Normal', color: theme.colors.white33)
              ],
              isSelected: AppResponsiveTheme.of(context).textScale ==
                  AppTextScale.normal,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [AppText.med16('Large')],
              unselectedContent: [
                AppText.med16('Large', color: theme.colors.white33)
              ],
              isSelected: AppResponsiveTheme.of(context).textScale ==
                  AppTextScale.large,
              onTap: () {},
            ),
          ],
          onChanged: (index) => Future.microtask(() {
            switch (index) {
              case 0:
                AppResponsiveTheme.of(context).setTextScale(AppTextScale.small);
                AppResponsiveTheme.of(context)
                    .setSystemScale(AppSystemScale.small);
                ref.read(themeSettingsProvider.notifier)
                  ..setTextScale(AppTextScale.small)
                  ..setSystemScale(AppSystemScale.small);
                break;
              case 1:
                AppResponsiveTheme.of(context)
                    .setTextScale(AppTextScale.normal);
                AppResponsiveTheme.of(context)
                    .setSystemScale(AppSystemScale.normal);
                ref.read(themeSettingsProvider.notifier)
                  ..setTextScale(AppTextScale.normal)
                  ..setSystemScale(AppSystemScale.normal);
                break;
              case 2:
                AppResponsiveTheme.of(context).setTextScale(AppTextScale.large);
                AppResponsiveTheme.of(context)
                    .setSystemScale(AppSystemScale.large);
                ref.read(themeSettingsProvider.notifier)
                  ..setTextScale(AppTextScale.large)
                  ..setSystemScale(AppSystemScale.large);
                break;
            }
          }),
        ),
        const AppGap.s12(),
        const AppSectionTitle('Show Others'),
        AppPanel(
          padding: AppEdgeInsets.all(AppGapSize.none),
          child: Column(
            children: [
              AppContainer(
                padding: AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [AppText.reg14("When you are typing"), AppSwitch()],
                ),
              ),
              const AppDivider(),
              AppContainer(
                padding: AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTypingBubble(profile: activeProfile),
                    AppText.reg12(
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
        const AppGap.s12(),
        const AppSectionTitle('Other'),
        AppPanel(
          padding: AppEdgeInsets.all(AppGapSize.none),
          child: Column(
            children: [
              const AppGap.s12(),
              AppText.reg14('// TODO', color: theme.colors.white33),
              const AppGap.s12(),
            ],
          ),
        ),
      ],
    );
  }
}
