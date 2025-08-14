import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin to add performance monitoring to your screens
mixin PerformanceMonitoringMixin<T extends StatefulWidget> on State<T> {
  bool _isScreenActive = true;
  DateTime? _lastActiveTime;

  bool get isScreenActive => _isScreenActive;
  DateTime? get lastActiveTime => _lastActiveTime;

  @override
  void initState() {
    super.initState();
    _isScreenActive = true;
    _lastActiveTime = DateTime.now();
    print('🟢 Screen ${widget.runtimeType} became active');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    final wasActive = _isScreenActive;
    _isScreenActive = route?.isCurrent ?? true;

    if (wasActive != _isScreenActive) {
      if (_isScreenActive) {
        _lastActiveTime = DateTime.now();
        print('🟢 Screen ${widget.runtimeType} became active');
        onScreenActivated();
      } else {
        print('🔴 Screen ${widget.runtimeType} became inactive');
        onScreenDeactivated();
      }
    }
  }

  @override
  void dispose() {
    print('⚫ Screen ${widget.runtimeType} disposed');
    onScreenDisposed();
    super.dispose();
  }

  /// Override this method to handle screen activation
  void onScreenActivated() {}

  /// Override this method to handle screen deactivation
  void onScreenDeactivated() {}

  /// Override this method to handle screen disposal
  void onScreenDisposed() {}

  /// Check if screen has been inactive for a given duration
  bool hasBeenInactiveFor(Duration duration) {
    if (_lastActiveTime == null) return true;
    return DateTime.now().difference(_lastActiveTime!) > duration;
  }
}

/// Provider that tracks screen activity and can disable queries
final screenActivityProvider =
    StateNotifierProvider<ScreenActivityNotifier, Map<String, bool>>((ref) {
  return ScreenActivityNotifier();
});

class ScreenActivityNotifier extends StateNotifier<Map<String, bool>> {
  ScreenActivityNotifier() : super({});

  void setScreenActive(String screenId, bool isActive) {
    state = {...state, screenId: isActive};
  }

  bool isScreenActive(String screenId) {
    return state[screenId] ?? false;
  }

  void removeScreen(String screenId) {
    final newState = Map<String, bool>.from(state);
    newState.remove(screenId);
    state = newState;
  }
}

/// Widget that automatically tracks screen activity
class ScreenActivityTracker extends ConsumerStatefulWidget {
  final Widget child;
  final String screenId;

  const ScreenActivityTracker({
    required this.child,
    required this.screenId,
    super.key,
  });

  @override
  ConsumerState<ScreenActivityTracker> createState() =>
      _ScreenActivityTrackerState();
}

class _ScreenActivityTrackerState extends ConsumerState<ScreenActivityTracker>
    with PerformanceMonitoringMixin {
  @override
  void onScreenActivated() {
    ref
        .read(screenActivityProvider.notifier)
        .setScreenActive(widget.screenId, true);
  }

  @override
  void onScreenDeactivated() {
    ref
        .read(screenActivityProvider.notifier)
        .setScreenActive(widget.screenId, false);
  }

  @override
  void onScreenDisposed() {
    ref.read(screenActivityProvider.notifier).removeScreen(widget.screenId);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension to check if a screen is active in queries
extension ScreenActivityQueryExtension on WidgetRef {
  bool isScreenActive(String screenId) {
    return watch(screenActivityProvider)[screenId] ?? false;
  }

  /// Use this to conditionally enable/disable queries based on screen activity
  T conditionalQuery<T>({
    required T Function() query,
    required String screenId,
    T? fallback,
  }) {
    if (isScreenActive(screenId)) {
      return query();
    }
    return fallback ??
        query(); // You can return a cached version or empty state
  }
}

/// Wrapper that automatically disables queries when screen is not visible
class PerformanceAwareScreen extends StatefulWidget {
  final Widget child;
  final bool Function()? shouldDisableQueries;

  const PerformanceAwareScreen({
    required this.child,
    this.shouldDisableQueries,
    super.key,
  });

  @override
  State<PerformanceAwareScreen> createState() => _PerformanceAwareScreenState();
}

class _PerformanceAwareScreenState extends State<PerformanceAwareScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isVisible = true;

  @override
  bool get wantKeepAlive => false; // Don't keep alive to save memory

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if this screen is currently visible
    final route = ModalRoute.of(context);
    _isVisible = route?.isCurrent ?? true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // If screen is not visible and we should disable queries, show placeholder
    if (!_isVisible && (widget.shouldDisableQueries?.call() ?? true)) {
      return const SizedBox.shrink(); // Minimal placeholder
    }

    return widget.child;
  }
}
