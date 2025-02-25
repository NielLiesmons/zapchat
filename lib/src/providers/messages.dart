import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'dummy_data.dart';

part 'messages.g.dart';

@riverpod
class Messages extends _$Messages {
  @override
  Map<String, List<Message>> build() {
    return dummyMessages;
  }

  void addMessage(String npub, Message message) {
    final messages = state[npub] ?? [];
    state = {
      ...state,
      npub: [...messages, message]
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
    };
  }

  List<Message> getMessages(String npub) => state[npub] ?? [];

  Message? getLastMessage(String npub) =>
      state[npub]?.isNotEmpty == true ? state[npub]!.first : null;
}
