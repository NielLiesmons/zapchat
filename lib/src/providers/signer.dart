import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amber_signer/amber_signer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bech32/bech32.dart';
import 'package:hex/hex.dart';
import 'package:zaplab_design/zaplab_design.dart';

part 'signer.g.dart';

// Holds the current active signer (null if not signed in)
final currentSignerProvider = StateProvider<Signer?>((ref) => null);

// Provider family for Bip340PrivateKeySigner
final bip340SignerProvider =
    Provider.family<Bip340PrivateKeySigner, String>((ref, secretKey) {
  return Bip340PrivateKeySigner(secretKey, ref);
});

@riverpod
class Signers extends _$Signers {
  @override
  Map<String, Signer> build() => {};

  Future<void> addAmberSigner(String pubkey) async {
    final signer = AmberSigner(ref);
    await signer.initialize();
    state = {...state, pubkey: signer};
  }

  Future<void> addNsecSigner(String pubkey, String nsec) async {
    // Verify the nsec format
    if (!AppKeyGenerator.verifyNsecChecksum(nsec)) {
      throw FormatException('Invalid nsec format');
    }

    // Get the hex private key from the nsec
    final privateKey = AppKeyGenerator.nsecToHex(nsec);

    final signer = Bip340PrivateKeySigner(privateKey, ref);
    await signer.initialize();
    state = {...state, pubkey: signer};

    // Add to signed in pubkeys
    signer.addSignedInPubkey(pubkey);
  }

  Future<void> addBunkerSigner(String pubkey, String bunkerUrl) async {
    // TODO: Implement bunker signer
    throw UnimplementedError('Bunker signer not implemented yet');
  }

  Signer? getSigner(String pubkey) => state[pubkey];

  void removeSigner(String pubkey) {
    state = Map.from(state)..remove(pubkey);
  }

  List<int> _convertBits(List<int> data, int fromBits, int toBits, bool pad) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << toBits) - 1;

    for (var value in data) {
      if (value < 0 || (value >> fromBits) != 0) {
        throw Exception('Invalid value: $value');
      }
      acc = (acc << fromBits) | value;
      bits += fromBits;
      while (bits >= toBits) {
        bits -= toBits;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (toBits - bits)) & maxv);
      }
    }

    return result;
  }
}
