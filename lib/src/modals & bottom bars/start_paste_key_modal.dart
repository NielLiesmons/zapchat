import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import '../providers/signer.dart';
import 'package:go_router/go_router.dart';

class StartPasteKeyModal extends ConsumerStatefulWidget {
  const StartPasteKeyModal({
    super.key,
  });

  @override
  ConsumerState<StartPasteKeyModal> createState() => _StartPasteKeyModalState();
}

class _StartPasteKeyModalState extends ConsumerState<StartPasteKeyModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _errorMessage;

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

  void _handleUseThisKey() async {
    final secretKey = _controller.text.trim();

    if (secretKey.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your secret key";
      });
      return;
    }

    try {
      // Verify nsec format
      if (!LabKeyGenerator.verifyNsecChecksum(secretKey)) {
        setState(() {
          _errorMessage = "Invalid nsec format";
        });
        return;
      }

      // Convert nsec to hex
      final secretKeyHex = LabKeyGenerator.nsecToHex(secretKey);

      // Get the signer from the provider
      final signer = ref.read(bip340SignerProvider(secretKeyHex));
      await signer.signIn();

      // Clear any previous error
      setState(() {
        _errorMessage = null;
      });

      // Navigate to home or close modal
      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error processing secret key: $e";
      });
    }
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
              warning: _errorMessage,
              controller: _controller,
              focusNode: _focusNode,
              singleLine: true,
              obscureText: true,
            ),
            const LabGap.s12(),
            LabButton(
              onTap: _handleUseThisKey,
              text: "Use This Key",
            ),
          ],
        ),
      ],
    );
  }
}
