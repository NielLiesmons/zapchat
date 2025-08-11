# Flutter Performance Debugging Guide

## 1. Profile Mode Commands

```bash
# Run in Profile mode (most important for accurate metrics)
fvm flutter run --profile -d android

# Build profile APK for testing
fvm flutter build apk --profile

# Run with performance overlay
fvm flutter run --profile --enable-software-rendering
```

## 2. Performance Profiling Tools

### Flutter Inspector
- Access via IDE: Flutter Inspector tab
- Web interface: http://localhost:9100 (when app is running)
- Shows widget rebuild frequency and widget tree depth

### Performance Overlay
Add to main.dart temporarily:
```dart
MaterialApp(
  showPerformanceOverlay: true, // Shows frame times
  // ... rest of your app
)
```

### Flutter Performance Tab
- Available in Flutter Inspector
- Shows frame timeline and CPU usage
- Identifies jank (dropped frames)

## 3. DevTools Commands

```bash
# Launch DevTools manually
fvm flutter pub global activate devtools
fvm flutter pub global run devtools

# Open DevTools for running app
# Go to: http://localhost:9100/#/
```

## 4. Specific Metrics to Watch

### Frame Timing
- Target: 60 FPS (16.67ms per frame)
- Warning: >16.67ms = dropped frames
- Critical: >33.34ms = visible jank

### Memory Usage
- Watch for memory leaks
- Check widget rebuilds
- Monitor image/cache usage

### CPU Profile
- Identify expensive function calls
- Find rebuild bottlenecks
- Locate synchronous operations

## 5. Common Performance Issues

### In ListView.builder:
- Function creation in itemBuilder
- Complex widgets without keys
- Loading too much data at once
- Missing const constructors

### In Riverpod:
- Unnecessary provider rebuilds
- Complex provider dependencies
- Not using select() for partial updates

### In Network/Data:
- Too many relationships loaded
- Large images without caching
- Synchronous operations on main thread