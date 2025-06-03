import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';

class SpinUpCommunityKeyModal extends StatefulWidget {
  final String profileName;
  final VoidCallback? onSecretKeyTap;
  final int spinCompleteDelay;
  final void Function(String secretKey, String profileName) onSpinComplete;

  const SpinUpCommunityKeyModal({
    super.key,
    required this.profileName,
    required this.onSpinComplete,
    this.onSecretKeyTap,
    this.spinCompleteDelay = 1000,
  });

  @override
  SpinUpCommunityKeyModalState createState() => SpinUpCommunityKeyModalState();
}

class SpinUpCommunityKeyModalState extends State<SpinUpCommunityKeyModal> {
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
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Hey ${widget.profileName}!",
      children: [
        AppContainer(
          child: Column(
            children: [
              AppContainer(
                width: 344,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Spin up a ",
                        style: AppTheme.of(context).typography.reg16.copyWith(
                              color: AppTheme.of(context).colors.white66,
                            ),
                      ),
                      TextSpan(
                        text: "secret key",
                        style: AppTheme.of(context).typography.reg16.copyWith(
                              color: AppTheme.of(context).colors.white66,
                              decoration: TextDecoration.underline,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onSecretKeyTap ?? () {},
                      ),
                      TextSpan(
                        text:
                            " to secure your Community profile, publications and money",
                        style: AppTheme.of(context).typography.reg16.copyWith(
                              color: AppTheme.of(context).colors.white66,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const AppGap.s24(),
              const AppGap.s4(),
              AppSlotMachine(
                showSelector: false,
                onSpinComplete: _handleSpinComplete,
              ),
              const AppGap.s16(),
            ],
          ),
        ),
      ],
    );
  }
}
