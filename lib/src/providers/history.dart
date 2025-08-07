import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/event_routes.dart';

part 'history.g.dart';

class HistoryEntry {
  final String modelType;
  final String modelId;
  final String displayText;
  final DateTime timestamp;

  HistoryEntry({
    required this.modelType,
    required this.modelId,
    required this.displayText,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'modelType': modelType,
        'modelId': modelId,
        'displayText': displayText,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        modelType: json['modelType'],
        modelId: json['modelId'],
        displayText: json['displayText'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

@riverpod
class History extends _$History {
  static const String _historyKey = 'navigation_history';

  static const int _maxEntries = 1000;

  @override
  Future<List<HistoryEntry>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];

    // Parse all entries
    final entries = historyJson
        .map((json) => HistoryEntry.fromJson(jsonDecode(json)))
        .toList();

    // Create a map to store the most recent entry for each model
    final Map<String, HistoryEntry> uniqueEntries = {};

    // Iterate through entries, keeping only the most recent one for each model
    for (final entry in entries) {
      final key = '${entry.modelType}:${entry.modelId}';
      if (!uniqueEntries.containsKey(key) ||
          entry.timestamp.isAfter(uniqueEntries[key]!.timestamp)) {
        uniqueEntries[key] = entry;
      }
    }

    // Convert back to list and sort by timestamp
    return uniqueEntries.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> addEntry(Model model) async {
    final entry = HistoryEntry(
      modelType: getModelName(model),
      modelId: model.id,
      displayText: getModelDisplayText(model),
      timestamp: DateTime.now(),
    );

    final currentEntries = await future;
    final key = '${entry.modelType}:${entry.modelId}';

    // Create a map for deduplication
    final Map<String, HistoryEntry> uniqueEntries = {};

    // Add all current entries to the map
    for (final e in currentEntries) {
      final entryKey = '${e.modelType}:${e.modelId}';
      if (!uniqueEntries.containsKey(entryKey) ||
          e.timestamp.isAfter(uniqueEntries[entryKey]!.timestamp)) {
        uniqueEntries[entryKey] = e;
      }
    }

    // Add the new entry to the map (this will overwrite if it exists)
    uniqueEntries[key] = entry;

    // Convert map back to list and sort by timestamp
    final newEntries = uniqueEntries.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Limit to max entries
    final limitedEntries = newEntries.take(_maxEntries).toList();

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    final historyJson =
        limitedEntries.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList(_historyKey, historyJson);

    // Update the state
    state = AsyncData(limitedEntries);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    state = const AsyncData([]);
  }

  List<HistoryItem> getRecentHistoryItems(BuildContext context,
      {String? currentModelId}) {
    if (!state.hasValue) {
      return [];
    }

    // Check if we're on a home route - if so, don't show history
    final router = GoRouter.of(context);
    final location = router.routerDelegate.currentConfiguration.uri.toString();
    final isOnHomeRoute = location == '/' || location.startsWith('/home/');

    if (isOnHomeRoute) {
      return [];
    }

    // Show latest 3 items when not on home route
    final currentEntries = state.value!
        .where((entry) => entry.modelId != currentModelId)
        .take(3)
        .toList();

    final items = currentEntries
        .map((entry) => HistoryItem(
              modelType: entry.modelType,
              modelId: entry.modelId,
              displayText: entry.displayText,
              timestamp: entry.timestamp,
              onTap: () async {
                // Get the model from storage using querySync
                final storage = ref.read(storageNotifierProvider.notifier);
                final models = await storage.query(
                  RequestFilter(
                    ids: {entry.modelId},
                  ).toRequest(),
                  source: LocalSource(),
                );
                if (models.isNotEmpty) {
                  final model = models.first;
                  final route = getModelRoute(entry.modelType);
                  context.push('$route/${model.id}', extra: model);
                }
              },
            ))
        .toList()
        .reversed // Reverse the list to show newest first
        .toList();
    return items;
  }

  List<HistoryItem> getRecentHistoryItemsForScreen(
      BuildContext context, String currentModelId) {
    return state.when<List<HistoryItem>>(
      data: (_) =>
          getRecentHistoryItems(context, currentModelId: currentModelId),
      loading: () => <HistoryItem>[],
      error: (_, __) => <HistoryItem>[],
    );
  }
}

@riverpod
List<HistoryItem> recentHistoryItems(
    Ref ref, BuildContext context, String currentModelId) {
  final historyState = ref.watch(historyProvider);
  return historyState.when<List<HistoryItem>>(
    data: (_) => ref
        .read(historyProvider.notifier)
        .getRecentHistoryItems(context, currentModelId: currentModelId),
    loading: () => <HistoryItem>[],
    error: (_, __) => <HistoryItem>[],
  );
}
