import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/modals/start_add_existing_key_modal.dart';
import 'package:zapchat/src/modals/start_paste_key_modal.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zapchat/src/providers/signer.dart';

List<GoRoute> get startRoutes => [
      GoRoute(
        path: '/start',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: AppStartModal(
              logoImageUrl: 'assets/images/Zapchat-Blurple-Transparent.png',
              title: 'Zapchat',
              description: "Chat & Other Stuff",
              onStart: (profileName) {
                context.replace('/start/spin-up-key', extra: profileName);
              },
              onAlreadyHaveKey: () {
                context.replace('/start/existing-profile');
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/start/spin-up-key',
        pageBuilder: (context, state) {
          final profileName = state.extra as String;
          return AppSlideInModal(
            child: AppSpinUpKeyModal(
              profileName: profileName,
              onSpinComplete: (secretKey, profileName) {
                context.push('/start/your-key', extra: {
                  'secretKey': secretKey,
                  'profileName': profileName,
                });
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/start/your-key',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, child) {
                final extra = state.extra as Map<String, dynamic>;
                return AppYourKeyModal(
                  secretKey: extra['secretKey'] as String,
                  profileName: extra['profileName'] as String,
                  onUseThisKey: () async {
                    final secretKey = extra['secretKey'] as String;
                    final profileName = extra['profileName'] as String;

                    // Create a PartialProfile with the provided name
                    final partialProfile = PartialProfile(
                      name: profileName,
                    );

                    // Verify nsec format
                    if (!AppKeyGenerator.verifyNsecChecksum(secretKey)) {
                      throw FormatException('Invalid nsec format: $secretKey');
                    }

                    try {
                      // Convert nsec to hex
                      final secretKeyHex = AppKeyGenerator.nsecToHex(secretKey);

                      // Get the signer from the provider
                      final signer =
                          ref.read(bip340SignerProvider(secretKeyHex));
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
                  onUSpinAgain: () {
                    context.pop();
                  },
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/start/existing-profile',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: StartAddExistingKeyModal(),
          );
        },
      ),
      GoRoute(
        path: '/start/paste-key',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: StartPasteKeyModal(
              onUseThisKey: () {
                context
                    .pop(); // TODO: Add logic to use the key and add a signedInProfile + Signer
              },
            ),
          );
        },
      ),
    ];
