import 'package:amber_signer/amber_signer.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

class StartAddExistingKeyModal extends ConsumerStatefulWidget {
  const StartAddExistingKeyModal({super.key});

  @override
  ConsumerState<StartAddExistingKeyModal> createState() =>
      _StartAddExistingKeyModalState();
}

final _refProvider = Provider((ref) => ref);

class _StartAddExistingKeyModalState
    extends ConsumerState<StartAddExistingKeyModal> {
  bool _isChecking = true;
  bool _isAmberAvailable = false;
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    _checkSigners();
  }

  Future<void> _checkSigners() async {
    final startTime = DateTime.now();
    try {
      final amber = AmberSigner(ref.read(_refProvider));
      final isAmberAvailable = await amber.isAvailable;
      // Ensure we show loading for at least 2 seconds
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed.inMilliseconds < 2000) {
        await Future.delayed(
            Duration(milliseconds: 2000 - elapsed.inMilliseconds));
      }
      if (mounted) {
        setState(() {
          _isAmberAvailable = isAmberAvailable;
          _isChecking = false;
        });
      }
    } catch (e) {
      print('Error checking for signers: $e');
      // Ensure minimum loading time even on error
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed.inMilliseconds < 2000) {
        await Future.delayed(
            Duration(milliseconds: 2000 - elapsed.inMilliseconds));
      }
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _signInWithAmber() async {
    setState(() => _isSigningIn = true);
    try {
      final amber = AmberSigner(ref.read(_refProvider));
      await amber.signIn(); // sets as active by default
      // After sign-in, ensure a profile exists
      final pubkey = ref.read(Signer.activePubkeyProvider);
      final profileState =
          ref.read(query<Profile>(authors: {if (pubkey != null) pubkey!}));
      Profile? profile;

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      LabToast.show(
        context,
        children: [LabText.reg14('Failed to sign in with Amber')],
      );
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabModal(
      title: "Use Existing Key",
      description: "Connect a Nostr Profile to Zapchat",
      children: [
        const LabGap.s12(),
        LabPanel(
          child: Column(
            children: [
              if (_isChecking) ...[
                LabContainer(
                  height: theme.sizes.s80,
                  child: Column(
                    children: [
                      LabContainer(
                        height: theme.sizes.s56,
                        child: Center(
                          child: Transform.scale(
                            scale: 1.5,
                            child: LabLoadingDots(
                              color: theme.colors.white66,
                            ),
                          ),
                        ),
                      ),
                      LabText.reg14(
                        "Checking for Nostr Signer Apps...",
                        color: theme.colors.white33,
                      ),
                    ],
                  ),
                ),
              ] else if (_isAmberAvailable) ...[
                Column(
                  children: [
                    LabPanelButton(
                      padding: LabEdgeInsets.all(
                        LabGapSize.none,
                      ),
                      color: Color(0x00000000),
                      onTap: _isSigningIn ? null : _signInWithAmber,
                      child: Row(
                        children: [
                          LabProfilePicSquare.fromUrl(
                              'assets/signers/amber.png',
                              size: LabProfilePicSquareSize.s48),
                          const LabGap.s12(),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabText.bold16(
                                      'Amber',
                                      color: theme.colors.white,
                                    ),
                                    const LabGap.s2(),
                                    LabText.reg12(
                                      'Nostr Signer detected!',
                                      color: theme.colors.white66,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                LabButton(
                                  onTap: _isSigningIn ? null : _signInWithAmber,
                                  children: [
                                    _isSigningIn
                                        ? LabLoadingDots(
                                            color: theme.colors.white66,
                                          )
                                        : LabText.med14(
                                            'Use',
                                            color: theme.colors.whiteEnforced,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                LabContainer(
                  height: theme.sizes.s80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabContainer(
                        height: theme.sizes.s56,
                        child: Center(
                          child: LabContainer(
                            height: theme.sizes.s24,
                            decoration: BoxDecoration(
                              color: theme.colors.white33,
                              borderRadius: BorderRadius.circular(
                                theme.sizes.s12,
                              ),
                            ),
                            padding: LabEdgeInsets.symmetric(
                                horizontal: LabGapSize.s12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LabText.reg12(
                                  "None detected",
                                  color: theme.colors.black,
                                ),
                                const LabGap.s8(),
                                LabIcon.s8(theme.icons.characters.check,
                                    outlineColor: theme.colors.black,
                                    outlineThickness:
                                        LabLineThicknessData.normal().thick),
                              ],
                            ),
                          ),
                        ),
                      ),
                      LabText.reg14(
                        "We found no existing Nostr Signer Apps.",
                        color: theme.colors.white33,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const LabGap.s12(),
        Row(
          children: [
            Expanded(
              child: LabPanelButton(
                onTap: () {
                  context.replace('/start/paste-key');
                },
                isLight: true,
                child: Column(
                  children: [
                    LabIcon.s32(theme.icons.characters.security,
                        gradient: theme.colors.graydient66),
                    const LabGap.s8(),
                    LabText.med16(
                      "Secret Key",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Enter your Nsec",
                      color: theme.colors.white66,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const LabGap.s12(),
            Expanded(
              child: LabPanelButton(
                onTap: () {},
                isLight: true,
                child: Column(
                  children: [
                    LabContainer(
                      height: theme.sizes.s32,
                      child: Center(
                        child: LabIcon.s24(theme.icons.characters.nostr,
                            gradient: theme.colors.graydient66),
                      ),
                    ),
                    const LabGap.s8(),
                    LabText.med16(
                      "Nostr Connect",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
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
        const LabGap.s4(),
      ],
    );
  }
}
