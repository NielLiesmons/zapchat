import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:amber_signer/amber_signer.dart';

final amberSignerProvider = Provider<AmberSigner>((ref) => AmberSigner(ref));

final purplebaseInitializationProvider = FutureProvider<void>((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  print('DEBUG: Initializing Purplebase...');

  await ref.read(initializationProvider(
    StorageConfiguration(
      databasePath: path.join(dir.path, 'purplebase_test.db'),
      relayGroups: {
        'default': {
          'wss://relay.damus.io',
          'wss://relay.primal.net',
          'wss://theforest.nostr1.com',
          'wss://zaplab.nostr1.com',
        }
      },
      keepSignatures: false,
      skipVerification: false,
      defaultRelayGroup: 'default',
      defaultQuerySource: LocalAndRemoteSource(stream: false, background: true),
      idleTimeout: Duration(minutes: 5),
      responseTimeout: Duration(seconds: 6),
      streamingBufferWindow: Duration(seconds: 2),
      keepMaxModels: 20000,
    ),
  ).future);

  print('DEBUG: Purplebase initialized successfully!');

  // Attempt auto sign-in for Amber signer
  try {
    final amberSigner = ref.read(amberSignerProvider);
    await amberSigner.attemptAutoSignIn();
  } catch (e) {
    print('Amber auto sign-in failed: $e');
    // Continue with initialization even if Amber auto sign-in fails
  }

  // Note: Custom models not available in test app, but keeping the structure
  print('DEBUG: Custom models not available in test app');
});
