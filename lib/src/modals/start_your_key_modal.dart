import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/signer.dart';
import 'package:go_router/go_router.dart';

class StartYourKeyModal extends ConsumerWidget {
  final String secretKey;
  final String profileName;

  const StartYourKeyModal({
    super.key,
    required this.secretKey,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);
    final npub = LabKeyGenerator.nsecToNpub(secretKey);
    final mnemonic = LabKeyGenerator.nsecToMnemonic(secretKey) ?? '';

    return LabModal(
      topBar: LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s12),
        child: LabText.med16("Your Key", color: theme.colors.white),
      ),
      bottomBar: Row(
        children: [
          LabButton(
            color: theme.colors.black33,
            onTap: () => context.pop(),
            children: [
              LabText.reg14(
                "Spin Again",
                color: theme.colors.white66,
              ),
            ],
          ),
          const LabGap.s12(),
          Expanded(
            child: LabButton(
              text: "Use This Key",
              onTap: () async {
                // Create a PartialProfile with the provided name
                final partialProfile = PartialProfile(
                  name: profileName,
                );

                // Verify nsec format
                if (!LabKeyGenerator.verifyNsecChecksum(secretKey)) {
                  throw FormatException('Invalid nsec format: $secretKey');
                }

                try {
                  // Convert nsec to hex
                  final secretKeyHex = LabKeyGenerator.nsecToHex(secretKey);

                  // Get the signer from the provider
                  final signer = ref.read(bip340SignerProvider(secretKeyHex));
                  await signer.initialize();

                  // Sign the profile with the signer
                  final profile = await partialProfile.signWith(signer);

                  // Save the profile to storage
                  await ref
                      .read(storageNotifierProvider.notifier)
                      .save({profile});

                  context.go('/');
                } catch (e) {
                  print('Error processing nsec: $e');
                  rethrow;
                }
              },
            ),
          ),
        ],
      ),
      children: [
        LabContainer(
          width: double.infinity,
          child: Column(
            children: [
              const LabGap.s8(),
              LabText.h1(
                "Hooray!",
                color: theme.colors.white,
              ),
              const LabGap.s12(),
              LabContainer(
                width: 344,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "You generated an uncrackable ",
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
                          ..onTap = () {
                            context.push('/start/secret-key-info', extra: {
                              'secretKey': secretKey,
                              'profileName': profileName,
                            });
                          },
                      ),
                      TextSpan(
                        text: ".",
                        style: LabTheme.of(context).typography.reg16.copyWith(
                              color: LabTheme.of(context).colors.white66,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const LabGap.s16(),
        LabKeyDisplay(
          secretKey: secretKey,
          mnemonic: mnemonic,
        ),
        const LabGap.s16(),
        LabContainer(
          width: 344,
          child: LabText.reg12(
            "A secret key (Nsec) can be displayed and stored in multiple ways: 12 emoji, 12 words on a piece of paper, or as a text string (Nsec) in a password manager.",
            color: theme.colors.white33,
            textAlign: TextAlign.center,
          ),
        ),
        const LabGap.s16(),
        LabContainer(
          width: 344,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "It comes with a unique ",
                  style: LabTheme.of(context).typography.reg16.copyWith(
                        color: LabTheme.of(context).colors.white66,
                      ),
                ),
                TextSpan(
                  text: "Public Identifier",
                  style: LabTheme.of(context).typography.reg16.copyWith(
                        color: LabTheme.of(context).colors.white66,
                        decoration: TextDecoration.underline,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.push('/start/npub-info', extra: {
                        'npub': npub,
                        'profileName': profileName,
                      });
                    },
                ),
                TextSpan(
                  text: ":",
                  style: LabTheme.of(context).typography.reg16.copyWith(
                        color: LabTheme.of(context).colors.white66,
                      ),
                ),
              ],
            ),
          ),
        ),
        const LabGap.s16(),
        LabContainer(
          padding: LabEdgeInsets.all(LabGapSize.s12),
          width: 316,
          decoration: BoxDecoration(
            color: theme.colors.white8,
            borderRadius: theme.radius.asBorderRadius().rad24,
          ),
          child: Row(
            children: [
              LabProfilePic.s56(
                PartialProfile(
                  name: profileName,
                ).dummySign(npub.decodeShareable()),
              ),
              const LabGap.s12(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabText.bold16(profileName),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LabContainer(
                        height: theme.sizes.s12,
                        width: theme.sizes.s12,
                        margin: const LabEdgeInsets.only(top: LabGapSize.s2),
                        decoration: BoxDecoration(
                          color: Color(npubToColor(npub)),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: theme.colors.white16,
                            width: LabLineThicknessData.normal().thin,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.black33,
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const LabGap.s8(),
                      LabText.reg16(
                        formatNpub(npub),
                        color: theme.colors.white66,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const LabGap.s16(),
        LabContainer(
          width: 344,
          child: LabText.reg12(
            "Your Public identifier (Npub) is how people can identify you and is the ID that, unlike your Seceret Key (Nsec), you can share publicly.",
            color: theme.colors.white33,
            textAlign: TextAlign.center,
          ),
        ),
        const LabGap.s16(),
        LabContainer(
          width: 344,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: LabTheme.of(context).typography.reg16.copyWith(
                        color: LabTheme.of(context).colors.white66,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
