import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance testing utilities for debugging frame drops and jank
class PerformanceTestUtils {
  static bool _isMonitoring = false;
  static final List<int> _frameTimes = [];
  static int _droppedFrames = 0;
  static int _totalFrames = 0;

  /// Start monitoring frame performance
  static void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _frameTimes.clear();
    _droppedFrames = 0;
    _totalFrames = 0;

    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
    print('🎯 Performance monitoring started');
  }

  /// Stop monitoring and print results
  static void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
    _printResults();
  }

  static void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameTime = timing.totalSpan.inMicroseconds;
      _frameTimes.add(frameTime);
      _totalFrames++;

      // 16.67ms = 60 FPS target (16,670 microseconds)
      if (frameTime > 16670) {
        _droppedFrames++;
      }
    }
  }

  static void _printResults() {
    if (_frameTimes.isEmpty) {
      print('📊 No frame data collected');
      return;
    }

    _frameTimes.sort();
    final avg = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    final p95 = _frameTimes[(_frameTimes.length * 0.95).floor()];
    final p99 = _frameTimes[(_frameTimes.length * 0.99).floor()];
    final max = _frameTimes.last;

    print('📊 Performance Results:');
    print('   Total frames: $_totalFrames');
    print(
        '   Dropped frames: $_droppedFrames (${(_droppedFrames / _totalFrames * 100).toStringAsFixed(1)}%)');
    print('   Average frame time: ${(avg / 1000).toStringAsFixed(2)}ms');
    print('   95th percentile: ${(p95 / 1000).toStringAsFixed(2)}ms');
    print('   99th percentile: ${(p99 / 1000).toStringAsFixed(2)}ms');
    print('   Worst frame: ${(max / 1000).toStringAsFixed(2)}ms');

    if (_droppedFrames > 0) {
      print('⚠️  Performance issues detected! Target: <16.67ms per frame');
    } else {
      print('✅ Performance looks good!');
    }
  }

  /// Log widget rebuilds for a specific widget type
  static void logRebuild(String widgetName) {
    print(
        '🔄 Rebuild: $widgetName at ${DateTime.now().millisecondsSinceEpoch}');
  }
}

/// Widget wrapper that logs rebuilds
class PerformanceTracker extends StatelessWidget {
  final String name;
  final Widget child;

  const PerformanceTracker({
    required this.name,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceTestUtils.logRebuild(name);
    return child;
  }
}

/// Memory usage tracker
class MemoryTracker {
  static void logMemoryUsage(String context) {
    // This is a simplified memory tracker
    // In a real app, you'd use more detailed memory profiling
    print('💾 Memory check at $context: ${DateTime.now()}');
  }
}
