import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amber_signer/amber_signer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signer.g.dart';

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
    // TODO: Implement nsec signer
    throw UnimplementedError('Nsec signer not implemented yet');
  }

  Future<void> addBunkerSigner(String pubkey, String bunkerUrl) async {
    // TODO: Implement bunker signer
    throw UnimplementedError('Bunker signer not implemented yet');
  }

  Signer? getSigner(String pubkey) => state[pubkey];

  void removeSigner(String pubkey) {
    state = Map.from(state)..remove(pubkey);
  }
}
