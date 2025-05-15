import 'package:zaplab_design/zaplab_design.dart';

class AppPasteKeyModal extends StatefulWidget {
  final VoidCallback onUseThisKey;

  const AppPasteKeyModal({
    super.key,
    required this.onUseThisKey,
  });

  @override
  State<AppPasteKeyModal> createState() => _AppPasteKeyModalState();
}

class _AppPasteKeyModalState extends State<AppPasteKeyModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Request focus after modal is built
    Future.microtask(() => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppInputModal(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppGap.s16(),
            AppIcon.s64(theme.icons.characters.security,
                gradient: theme.colors.graydient66),
            const AppGap.s12(),
            AppText.h1("Enter Your Key"),
            const AppGap.s8(),
            AppText.reg16(
              "Your key will be encrypted and\nstored on your device only.",
              color: theme.colors.white66,
              textAlign: TextAlign.center,
            ),
            const AppGap.s24(),
            AppInputTextField(
              placeholder: 'Nsec, Ncryptsec, 12 words or 12 emoji',
              title: "Your Key",
              // warning: "This is not a valid secret key", // TODO: Add warning if the nsec is not valid
              controller: _controller,
              focusNode: _focusNode,
              singleLine: true,
            ),
            const AppGap.s12(),
            AppButton(
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  widget.onUseThisKey();
                }
              },
              text: "Use This Key",
            ),
          ],
        ),
      ],
    );
  }
}
