import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:models/models.dart';

/// Tracks read/unread status for chat messages in communities
class ChatReadStatusNotifier extends StateNotifier<Map<String, DateTime>> {
  static const String _storageKey = 'chat_read_status';
  
  ChatReadStatusNotifier() : super({});

  /// Load read status from persistent storage
  Future<void> loadReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        final Map<String, DateTime> readStatus = {};
        
        for (final entry in jsonMap.entries) {
          readStatus[entry.key] = DateTime.parse(entry.value);
        }
        
        state = readStatus;
      }
    } catch (e) {
      print('Error loading chat read status: $e');
    }
  }

  /// Save read status to persistent storage
  Future<void> _saveReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, String> jsonMap = {};
      
      for (final entry in state.entries) {
        jsonMap[entry.key] = entry.value.toIso8601String();
      }
      
      await prefs.setString(_storageKey, jsonEncode(jsonMap));
    } catch (e) {
      print('Error saving chat read status: $e');
    }
  }

  /// Mark messages as read for a specific community
  Future<void> markMessagesAsRead(String communityPubkey, DateTime lastReadTime) async {
    final currentReadTime = state[communityPubkey];
    
    // Only update if the new read time is more recent
    if (currentReadTime == null || lastReadTime.isAfter(currentReadTime)) {
      state = {...state, communityPubkey: lastReadTime};
      await _saveReadStatus();
    }
  }

  /// Get the last read time for a community
  DateTime? getLastReadTime(String communityPubkey) {
    return state[communityPubkey];
  }

  /// Check if a message is unread for a community
  bool isMessageUnread(String communityPubkey, DateTime messageTime) {
    final lastReadTime = state[communityPubkey];
    if (lastReadTime == null) return true;
    return messageTime.isAfter(lastReadTime);
  }

  /// Get the count of unread messages for a community
  int getUnreadCount(String communityPubkey, List<ChatMessage> messages) {
    final lastReadTime = state[communityPubkey];
    if (lastReadTime == null) return messages.length;
    
    return messages.where((msg) => msg.createdAt.isAfter(lastReadTime)).length;
  }

  /// Get the first unread message index for a community
  int? getFirstUnreadMessageIndex(String communityPubkey, List<ChatMessage> messages) {
    final lastReadTime = state[communityPubkey];
    if (lastReadTime == null) return 0;
    
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].createdAt.isAfter(lastReadTime)) {
        return i;
      }
    }
    return null;
  }

  /// Clear read status for a community (useful for testing or reset)
  Future<void> clearReadStatus(String communityPubkey) async {
    state = Map.from(state)..remove(communityPubkey);
    await _saveReadStatus();
  }

  /// Clear all read status (useful for testing or reset)
  Future<void> clearAllReadStatus() async {
    state = {};
    await _saveReadStatus();
  }
}

final chatReadStatusProvider = StateNotifierProvider<ChatReadStatusNotifier, Map<String, DateTime>>(
  (ref) => ChatReadStatusNotifier()..loadReadStatus(),
);

/// Provider that provides unread count for a specific community
final communityUnreadCountProvider = Provider.family<int, String>((ref, communityPubkey) {
  final readStatus = ref.watch(chatReadStatusProvider);
  final messages = ref.watch(
    query<ChatMessage>(
      tags: {'#h': {communityPubkey}},
      limit: 1000, // Get enough messages to count unread
    ),
  );
  
  if (messages case StorageData()) {
    final lastReadTime = readStatus[communityPubkey];
    if (lastReadTime == null) return messages.models.length;
    
    return messages.models.where((msg) => msg.createdAt.isAfter(lastReadTime)).length;
  }
  
  return 0;
});

/// Provider that provides the first unread message index for a community
final communityFirstUnreadIndexProvider = Provider.family<int?, String>((ref, communityPubkey) {
  final readStatus = ref.watch(chatReadStatusProvider);
  final messages = ref.watch(
    query<ChatMessage>(
      tags: {'#h': {communityPubkey}},
      limit: 1000,
    ),
  );
  
  if (messages case StorageData()) {
    final lastReadTime = readStatus[communityPubkey];
    if (lastReadTime == null) return 0;
    
    for (int i = 0; i < messages.models.length; i++) {
      if (messages.models[i].createdAt.isAfter(lastReadTime)) {
        return i;
      }
    }
  }
  
  return null;
}); 