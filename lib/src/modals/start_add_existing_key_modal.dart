import 'package:amber_signer/amber_signer.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    _checkSigners();
  }

  Future<void> _checkSigners() async {
    final startTime = DateTime.now();
    try {
      final signer = AmberSigner(ref.read(_refProvider));
      await signer.initialize();

      // Ensure we show loading for at least 2 seconds
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed.inMilliseconds < 2000) {
        await Future.delayed(
            Duration(milliseconds: 2000 - elapsed.inMilliseconds));
      }

      if (mounted) {
        setState(() {
          _isAmberAvailable = signer.isInitialized;
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
              if (_isChecking) ...[
                AppContainer(
                  height: theme.sizes.s80,
                  child: Column(
                    children: [
                      AppContainer(
                        height: theme.sizes.s56,
                        child: Center(
                          child: Transform.scale(
                            scale: 1.5,
                            child: AppLoadingDots(
                              color: theme.colors.white66,
                            ),
                          ),
                        ),
                      ),
                      AppText.reg14(
                        "Checking for Nostr Signer Apps...",
                        color: theme.colors.white33,
                      ),
                    ],
                  ),
                ),
              ] else if (_isAmberAvailable) ...[
                AppContainer(
                  height: theme.sizes.s80,
                  child: Center(
                    child: AppText.reg16(
                      'Amber detected! Connect your profile with Amber.',
                      color: theme.colors.white,
                    ),
                  ),
                ),
              ] else ...[
                AppContainer(
                  height: theme.sizes.s80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppContainer(
                        height: theme.sizes.s56,
                        child: Center(
                          child: AppContainer(
                            height: theme.sizes.s24,
                            decoration: BoxDecoration(
                              color: theme.colors.white33,
                              borderRadius: BorderRadius.circular(
                                theme.sizes.s12,
                              ),
                            ),
                            padding: AppEdgeInsets.symmetric(
                                horizontal: AppGapSize.s12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText.reg12(
                                  "None detected",
                                  color: theme.colors.black,
                                ),
                                const AppGap.s8(),
                                AppIcon.s8(theme.icons.characters.check,
                                    outlineColor: theme.colors.black,
                                    outlineThickness:
                                        AppLineThicknessData.normal().thick),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppText.reg14(
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
        const AppGap.s12(),
        Row(
          children: [
            Expanded(
              child: AppPanelButton(
                onTap: () {
                  context.replace('/start/paste-key');
                },
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
