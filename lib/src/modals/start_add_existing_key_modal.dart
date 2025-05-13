import 'package:zaplab_design/zaplab_design.dart';

class AddExistingKeyModal extends StatelessWidget {
  const AddExistingKeyModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Use Existing Key",
      description: "Connect a Nostr Profile to Zapchat",
      children: [
        const AppGap.s12(),
        AppPanel(
          child: Column(
            children: [
              AppContainer(
                height: theme.sizes.s64,
                child: Transform.scale(
                  scale: 1.5,
                  child: AppLoadingDots(
                    color: theme.colors.white66,
                  ),
                ),
              ),
              AppText.reg14(
                "Checking for Nostr Signers...",
                color: theme.colors.white33,
              ),
            ],
          ),
        ),
        const AppGap.s12(),
        Row(
          children: [
            Expanded(
              child: AppPanelButton(
                onTap: () {},
                isLight: true,
                child: Column(
                  children: [
                    AppIcon.s32(theme.icons.characters.security,
                        gradient: theme.colors.graydient66),
                    const AppGap.s8(),
                    AppText.med16(
                      "Secret Key",
                    ),
                    const AppGap.s4(),
                    AppText.reg12(
                      "Enter your Nsec",
                      color: theme.colors.white66,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const AppGap.s12(),
            Expanded(
              child: AppPanelButton(
                onTap: () {},
                isLight: true,
                child: Column(
                  children: [
                    AppContainer(
                      height: theme.sizes.s32,
                      child: Center(
                        child: AppIcon.s24(theme.icons.characters.nostr,
                            gradient: theme.colors.graydient66),
                      ),
                    ),
                    const AppGap.s8(),
                    AppText.med16(
                      "Nostr Connect",
                    ),
                    const AppGap.s4(),
                    AppText.reg12(
                      "Paste a Link",
                      color: theme.colors.white66,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const AppGap.s4(),
      ],
    );
  }
}
