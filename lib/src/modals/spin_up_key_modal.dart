import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';

class SpinUpKeyModal extends StatefulWidget {
  final String profileName;
  final VoidCallback? onSecretKeyTap;
  final int spinCompleteDelay;
  final void Function(String secretKey, String profileName) onSpinComplete;

  const SpinUpKeyModal({
    super.key,
    required this.profileName,
    required this.onSpinComplete,
    this.onSecretKeyTap,
    this.spinCompleteDelay = 1000,
  });

  @override
  SpinUpKeyModalState createState() => SpinUpKeyModalState();
}

class SpinUpKeyModalState extends State<SpinUpKeyModal> {
  // ignore: unused_field
  String? _secretKey;

  void _handleSpinComplete(String secretKey, String mode) {
    setState(() {
      _secretKey = secretKey;
    });

    Future.delayed(Duration(milliseconds: widget.spinCompleteDelay), () {
      if (mounted) {
        widget.onSpinComplete(secretKey, widget.profileName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabModal(
      title: "Hey ${widget.profileName}!",
      bottomBar: LabButton(
        onTap: widget.onSecretKeyTap,
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
      children: [
        LabContainer(
          child: Column(
            children: [
              LabContainer(
                width: 344,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Spin up a ",
                        style: LabTheme.of(context).typography.reg16.copyWith(
                              color: LabTheme.of(context).colors.white66,
                            ),
                      ),
                      TextSpan(
                        text: "secret key",
                        style: LabTheme.of(context).typography.reg16.copyWith(
                              color: LabTheme.of(context).colors.white66,
                              decoration: TextDecoration.underline,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onSecretKeyTap ?? () {},
                      ),
                      TextSpan(
                        text: " to secure your profile and publications",
                        style: LabTheme.of(context).typography.reg16.copyWith(
                              color: LabTheme.of(context).colors.white66,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const LabGap.s24(),
              const LabGap.s4(),
              LabSlotMachine(
                showSelector: false,
                onSpinComplete: _handleSpinComplete,
              ),
              const LabGap.s16(),
            ],
          ),
        ),
      ],
    );
  }
}
