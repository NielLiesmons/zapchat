# Performance Optimization Guide - Zapchat

## 🎯 Immediate Optimizations Applied

### 1. ListView Performance Improvements ✅

**What was fixed:**
- Removed expensive function creation in `itemBuilder`
- Added unique `ValueKey(message.id)` to each message bubble
- Added performance-optimized ListView settings:
  ```dart
  cacheExtent: 500, // Cache more items
  addAutomaticKeepAlives: false, // Don't keep items alive automatically
  addRepaintBoundaries: true, // Add repaint boundaries
  ```

**Expected improvement:** 30-50% reduction in scroll lag

### 2. Callback Function Optimization ✅

**What was fixed:**
- Extracted callback functions to class methods:
  - `_onSendAgain()`
  - `_onActions()`
  - `_onLocalReply()`
  - `_onReply()`

**Expected improvement:** Reduced garbage collection, fewer rebuilds

### 3. Relationship Loading Optimization ✅

**What was fixed:**
- Reduced query relationships from `{msg.author, msg.reactions, msg.zaps}` to `{msg.author}`
- Only load essential relationships to reduce memory usage

**Expected improvement:** Faster query responses, less memory usage

## 🛠️ Performance Testing Tools

### Run Profile Mode
```bash
cd zapchat
./run_performance_tests.sh
# Choose option 1: Run in Profile Mode
```

### Flutter DevTools Access
1. Run app in profile mode: `fvm flutter run --profile`
2. Open browser: http://localhost:9100
3. Navigate to Performance tab

### Key Metrics to Monitor
- **Frame Time**: Target <16.67ms (60 FPS)
- **Dropped Frames**: Target <1%
- **Memory Usage**: Watch for memory leaks
- **CPU Usage**: Identify expensive operations

## 🚀 Additional Optimizations to Consider

### 1. Image Optimization
```dart
// In message bubbles with images
CachedNetworkImage(
  imageUrl: url,
  cacheManager: DefaultCacheManager(), // Use cache manager
  progressIndicatorBuilder: (context, url, downloadProgress) {
    return const LabSkeletonLoader(); // Light skeleton
  },
  errorWidget: (context, url, error) => const SizedBox.shrink(),
)
```

### 2. Text Rendering Optimization
```dart
// For large text content
Text(
  content,
  maxLines: 100, // Limit lines to prevent overflow
  overflow: TextOverflow.ellipsis,
)
```

### 3. Riverpod Provider Optimization
```dart
// Use select() for partial updates
final isPublishing = ref.watch(
  messageStateProvider.select((state) => state.isPublishing),
);
```

### 4. Keyboard Animation Optimization

**Current issue:** `resizeToAvoidBottomInset: true` can cause layout recalculations

**Solution:** Consider using a custom keyboard handler:
```dart
return Scaffold(
  resizeToAvoidBottomInset: false, // Disable automatic resize
  body: Column(
    children: [
      Expanded(child: chatContent),
      // Custom bottom bar that handles keyboard manually
      AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: chatBottomBar,
      ),
    ],
  ),
);
```

## 📊 Performance Monitoring

### Continuous Monitoring
Add this to your main app during development:
```dart
import 'performance_test_script.dart';

void main() {
  PerformanceTestUtils.startMonitoring(); // Start monitoring
  runApp(MyApp());
}
```

### Widget-level Tracking
Wrap expensive widgets:
```dart
PerformanceTracker(
  name: 'MessageBubble',
  child: LabMessageBubble(...),
)
```

## 🔍 Debugging Workflow

1. **Run Profile Mode**: `./run_performance_tests.sh` → Option 1
2. **Open DevTools**: Navigate to Performance tab
3. **Record Performance**: Click record, use the app for 30 seconds
4. **Analyze Results**: Look for:
   - Frame drops (red bars)
   - Expensive operations (wide blocks)
   - Rebuild frequency
5. **Test on Real Device**: Performance on simulator ≠ real device performance

## ⚡ Quick Performance Checks

### Before Each Release
```bash
# 1. Run analysis
fvm flutter analyze

# 2. Check performance
./run_performance_tests.sh

# 3. Build profile APK for testing
fvm flutter build apk --profile
```

### Red Flags to Watch For
- Frame times >20ms consistently
- Memory usage constantly increasing
- High CPU usage during idle
- Dropped frames >5%

## 🎯 Expected Results After Optimizations

- **Scroll Performance**: Should feel smooth at 60 FPS
- **Keyboard Animation**: Should slide in smoothly without lag
- **Memory Usage**: Stable, no continuous growth
- **App Responsiveness**: UI should respond immediately to taps

## 📝 Next Steps

1. **Test the optimizations** by running in Profile mode
2. **Use DevTools** to verify frame timing improvements
3. **Monitor memory usage** during extended chat sessions
4. **Consider lazy loading** for very long chat histories (>1000 messages)
5. **Implement virtualization** if chat gets extremely long

## 🆘 If Performance Issues Persist

1. **Check device specs**: Old devices may still struggle
2. **Profile memory usage**: Look for memory leaks
3. **Consider pagination**: Load messages in chunks
4. **Review third-party widgets**: Some widgets may be poorly optimized
5. **Test on multiple devices**: Performance varies significantly across devices