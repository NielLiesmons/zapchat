import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

final currentProfile = StateProvider<Profile?>((_) => null);
