import 'package:flutter/services.dart';
import 'package:zaplab_design/zaplab_design.dart';

class SettingsAddProfileModal extends StatefulWidget {
  final void Function(String profileName) onStart;
  final VoidCallback onAlreadyHaveKey;

  const SettingsAddProfileModal({
    super.key,
    required this.onStart,
    required this.onAlreadyHaveKey,
  });

  @override
  State<SettingsAddProfileModal> createState() =>
      _SettingsAddProfileModalState();
}

class _SettingsAddProfileModalState extends State<SettingsAddProfileModal> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _focusNode.onKeyEvent = (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.enter &&
          (HardwareKeyboard.instance.isMetaPressed ||
              HardwareKeyboard.instance.isControlPressed)) {
        if (_controller.text.isNotEmpty) {
          widget.onStart(_controller.text);
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
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
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const LabGap.s12(),
              const LabText.h1("Add Profile"),
              const LabGap.s24(),
              Row(
                children: [
                  const LabGap.s16(),
                  LabText.reg14("Choose a Profile Name",
                      color: theme.colors.white),
                  const LabGap.s12(),
                ],
              ),
              const LabGap.s8(),
              LabInputTextField(
                controller: _controller,
                focusNode: _focusNode,
                singleLine: true,
                placeholder: 'Profile Name',
              ),
              const LabGap.s16(),
              LabButton(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    widget.onStart(_controller.text);
                  }
                },
                children: [
                  LabIcon.s12(
                    theme.icons.characters.play,
                    color: theme.colors.whiteEnforced,
                  ),
                  const LabGap.s12(),
                  LabText.med14("Start", color: theme.colors.whiteEnforced),
                ],
              ),
              const LabGap.s16(),
              LabButton(
                onTap: widget.onAlreadyHaveKey,
                color: theme.colors.black33,
                children: [
                  LabIcon.s16(
                    theme.icons.characters.nostr,
                    color: LabColorsData.dark().blurpleLightColor,
                  ),
                  const LabGap.s12(),
                  LabText.reg14("Already have a Nostr key?",
                      color: theme.colors.white66),
                ],
              ),
              LabPlatformUtils.isMobile ? const LabGap.s8() : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
