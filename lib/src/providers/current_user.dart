import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  String build() {
    // In a real app, this would come from secure storage or authentication
    return 'npub4'; // Your default test user
  }

  void setCurrentUser(String npub) {
    state = npub;
  }
}
