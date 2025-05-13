import 'package:zaplab_design/zaplab_design.dart';

class AppAddNsecModal extends StatelessWidget {
  const AppAddNsecModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Use Existing Key",
      description: "Connect a Nostr Profile to Zapchat",
      children: [
        const AppGap.s12(),
        Row(
          children: [
            const AppGap.s16(),
            AppText.reg14("Enter your Secret Key", color: theme.colors.white),
            const AppGap.s12(),
          ],
        ),
        const AppGap.s8(),
        AppInputTextField(
          placeholder: [
            AppText.reg16(
              "Nsec, 12 words or 12 emoji",
              color: theme.colors.white33,
            ),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
