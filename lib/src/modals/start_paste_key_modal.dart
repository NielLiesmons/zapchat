import 'package:zaplab_design/zaplab_design.dart';

class StartPasteKeyModal extends StatefulWidget {
  final VoidCallback onUseThisKey;

  const StartPasteKeyModal({
    super.key,
    required this.onUseThisKey,
  });

  @override
  State<StartPasteKeyModal> createState() => _StartPasteKeyModalState();
}

class _StartPasteKeyModalState extends State<StartPasteKeyModal> {
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
    final theme = LabTheme.of(context);

    return LabInputModal(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LabGap.s16(),
            LabIcon.s64(theme.icons.characters.security,
                gradient: theme.colors.graydient66),
            const LabGap.s12(),
            LabText.h1("Enter Your Key"),
            const LabGap.s8(),
            LabText.reg16(
              "Your key will be encrypted and\nstored on your device only.",
              color: theme.colors.white66,
              textAlign: TextAlign.center,
            ),
            const LabGap.s24(),
            LabInputTextField(
              placeholder: 'Nsec, Ncryptsec, 12 words or 12 emoji',
              title: "Your Key",
              // warning: "This is not a valid secret key",  TODO: Add warning if the nsec is not valid
              controller: _controller,
              focusNode: _focusNode,
              singleLine: true,
            ),
            const LabGap.s12(),
            LabButton(
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
