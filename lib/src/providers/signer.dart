import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Provider family for Bip340PrivateKeySigner, can keep multiple signers with nsecs
final bip340SignerProvider =
    Provider.family<Bip340PrivateKeySigner, String>((ref, secretKey) {
  return Bip340PrivateKeySigner(secretKey, ref);
});
