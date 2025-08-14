import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

class CommunitiesState {
  final List<Community> communities;
  final Map<String, List<ChatMessage>>
      communityMessages; // communityId -> latest 100 messages
  final bool isLoading;
  final String? error;

  const CommunitiesState({
    this.communities = const [],
    this.communityMessages = const {},
    this.isLoading = false,
    this.error,
  });

  CommunitiesState copyWith({
    List<Community>? communities,
    Map<String, List<ChatMessage>>? communityMessages,
    bool? isLoading,
    String? error,
  }) {
    return CommunitiesState(
      communities: communities ?? this.communities,
      communityMessages: communityMessages ?? this.communityMessages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CommunitiesNotifier extends StateNotifier<CommunitiesState> {
  CommunitiesNotifier(this.ref) : super(const CommunitiesState()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    // Watch for communities - using the EXACT same logic that was working
    ref.listen(
      query<Community>(
        authors: _getCommunityAuthors(),
        and: (c) => {c.author, c.chatMessages},
        source: LocalAndRemoteSource(background: false),
        limit: 10,
      ),
      (previous, next) {
        if (next is StorageData) {
          _updateCommunities(next.models);
        } else if (next is StorageLoading) {
          state = state.copyWith(isLoading: true);
        } else if (next is StorageError) {
          state = state.copyWith(error: next.toString());
        }
      },
    );

    // Watch for new chat messages that are tagged with #h to our communities
    // Using the EXACT same logic as purplebase_test - messages tagged to communities
    ref.listen(
      query<ChatMessage>(
        tags: {
          '#h':
              _getCommunityAuthors(), // Messages tagged with #h to our communities
        },
        and: (msg) => {msg.author, msg.reactions, msg.zaps},
        source: LocalAndRemoteSource(background: false),
        limit: 1000,
      ),
      (previous, next) {
        if (next is StorageData) {
          _updateCommunityMessages(next.models);
        }
      },
    );
  }

  Set<String> _getCommunityAuthors() {
    // Specific community authors to show on home page
    return {
      Utils.decodeShareableToString(
          'npub1pr28pamqhcfacyqudjrfyyfzhjwgz3xxfc85yjp42396he30ztls42rfw8'),
      Utils.decodeShareableToString(
          'npub1w5d4ws7d607qwszk4nwm3ugkzkzvvge8mmv0jxfk7edthfnlqhrs8n72uv'),
      Utils.decodeShareableToString(
          'npub18stt78efprta2el02tzgnez6ehghzgtt000v58967wvkgezjmprs0n7h7u'),
      Utils.decodeShareableToString(
          'npub1vcxcc7r9racyslkfhrwu9qlznne9v95nmk3m5frd8lfuprdmwzpsxqzqcr'),
      Utils.decodeShareableToString(
          'npub1229y50ruvq9hjdxsjknh43gq4n9ef7h3h5hc4ezzrkg0q7kgg0tsv9a402'),
    };
  }

  void _updateCommunities(List<Community> communities) {
    state = state.copyWith(
      communities: communities,
      isLoading: false,
      error: null,
    );
  }

  void _updateCommunityMessages(List<ChatMessage> messages) {
    // Group messages by community using the EXACT same logic that was working
    final newMessages =
        Map<String, List<ChatMessage>>.from(state.communityMessages);

    for (final message in messages) {
      final communityId = _extractCommunityId(message);
      if (communityId != null) {
        // Add new message to the END to maintain chronological order (oldest first)
        final existingMessages = newMessages[communityId] ?? [];
        final updatedMessages = [...existingMessages, message];

        // Remove duplicates and keep latest 100
        final uniqueMessages =
            updatedMessages.toSet().toList().take(100).toList();

        newMessages[communityId] = uniqueMessages;
      }
    }

    state = state.copyWith(communityMessages: newMessages);
  }

  String? _extractCommunityId(ChatMessage message) {
    // Use the EXACT same logic that was working in purplebase_test
    // Check if message has the 'h' tag that matches a community's pubkey
    final communityTag = message.event.getFirstTagValue('h');
    if (communityTag != null) {
      // Check if this tag matches any of our community pubkeys
      for (final community in state.communities) {
        if (community.event.pubkey == communityTag) {
          return community.id;
        }
      }
    }

    // Also check if the message author is a community author
    final authorPubkey = message.author.value?.pubkey;
    if (authorPubkey != null) {
      for (final community in state.communities) {
        if (community.author.value?.pubkey == authorPubkey) {
          return community.id;
        }
      }
    }

    return null;
  }

  // Get messages for a specific community
  List<ChatMessage> getCommunityMessages(String communityId) {
    return state.communityMessages[communityId] ?? [];
  }

  // Get latest message for a community (for home tab display)
  ChatMessage? getLatestCommunityMessage(String communityId) {
    final messages = state.communityMessages[communityId];
    return messages?.isNotEmpty == true ? messages!.first : null;
  }

  // Refresh communities (useful for manual refresh)
  Future<void> refreshCommunities() async {
    state = state.copyWith(isLoading: true);
    // The listener will automatically update when new data arrives
  }
}

// Provider instances
final communitiesProvider =
    StateNotifierProvider<CommunitiesNotifier, CommunitiesState>((ref) {
  return CommunitiesNotifier(ref);
});

// Convenience providers
final communitiesListProvider = Provider<List<Community>>((ref) {
  return ref.watch(communitiesProvider).communities;
});

final communityMessagesProvider =
    Provider.family<List<ChatMessage>, String>((ref, communityId) {
  return ref.watch(communitiesProvider).communityMessages[communityId] ?? [];
});

final latestCommunityMessageProvider =
    Provider.family<ChatMessage?, String>((ref, communityId) {
  final notifier = ref.watch(communitiesProvider.notifier);
  return notifier.getLatestCommunityMessage(communityId);
});
