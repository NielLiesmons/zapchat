# Performance Utilities for Zapchat

This directory contains performance optimization utilities specifically for the Zapchat app. These utilities help prevent underlying pages from continuing to query, animate, and render when covered by modals or other screens.

## Quick Fix (Already Applied)

The main performance issue has been fixed by adding `maintainState: false` to the transition widgets in the `zaplab_design` package. This prevents Flutter from maintaining the state of underlying pages.

## Available Utilities

### 1. PerformanceMonitoringMixin

Add this mixin to your screen widgets to automatically track when they become active/inactive:

```dart
class YourScreen extends StatefulWidget {
  @override
  State<YourScreen> createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> 
    with PerformanceMonitoringMixin {
  
  @override
  void onScreenActivated() {
    // Screen became visible - resume queries, animations, etc.
    print('Screen is now active');
  }
  
  @override
  void onScreenDeactivated() {
    // Screen is covered by modal - pause expensive operations
    print('Screen is now inactive');
  }
  
  @override
  void onScreenDisposed() {
    // Screen was disposed - cleanup resources
    print('Screen was disposed');
  }
}
```

### 2. ScreenActivityTracker

Wrap your screens with this widget to automatically track their activity state:

```dart
class YourScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenActivityTracker(
      screenId: 'your-screen-id',
      child: YourScreenContent(),
    );
  }
}
```

### 3. Conditional Queries

Use the `conditionalQuery` extension to conditionally enable/disable queries based on screen activity:

```dart
class YourScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only run the query when the screen is active
    final data = ref.conditionalQuery(
      query: () => ref.watch(yourQueryProvider),
      screenId: 'your-screen-id',
      fallback: cachedData, // Return cached data when inactive
    );
    
    return YourUI(data: data);
  }
}
```

### 4. PerformanceAwareScreen

Wrap widgets that should be disabled when not visible:

```dart
PerformanceAwareScreen(
  shouldDisableQueries: () => true,
  child: YourExpensiveWidget(),
)
```

## Usage Examples

### Basic Screen with Performance Monitoring

```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
    with PerformanceMonitoringMixin {
  
  @override
  void onScreenActivated() {
    // Resume any paused operations
    print('Home screen is now visible');
  }
  
  @override
  void onScreenDeactivated() {
    // Pause expensive operations
    print('Home screen is covered by modal');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YourContent(),
    );
  }
}
```

### Screen with Activity Tracking

```dart
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenActivityTracker(
      screenId: 'profile-screen',
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            // Only run expensive queries when screen is active
            final profile = ref.conditionalQuery(
              query: () => ref.watch(profileProvider),
              screenId: 'profile-screen',
              fallback: Profile.empty(), // Return empty profile when inactive
            );
            
            return ProfileContent(profile: profile);
          },
        ),
      ),
    );
  }
}
```

### Conditional Query with Fallback

```dart
class FeedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenActivityTracker(
      screenId: 'feed-screen',
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            // Use cached data when screen is inactive
            final feedState = ref.conditionalQuery(
              query: () => ref.watch(feedQueryProvider),
              screenId: 'feed-screen',
              fallback: ref.read(feedCacheProvider), // Return cached data
            );
            
            return FeedList(feedState: feedState);
          },
        ),
      ),
    );
  }
}
```

## Performance Benefits

1. **Reduced CPU Usage**: Inactive screens stop running expensive queries
2. **Lower Memory Usage**: Screens can release resources when covered
3. **Better Battery Life**: Fewer background operations on mobile
4. **Smoother Animations**: No competing animations from hidden screens
5. **Faster Navigation**: Reduced background processing during transitions

## Best Practices

1. **Use Screen IDs**: Give each screen a unique ID for tracking
2. **Provide Fallbacks**: Always provide fallback data for inactive screens
3. **Monitor Console**: Watch for the 🟢🔴⚫ emojis to track screen states
4. **Wrap Expensive Widgets**: Use `PerformanceAwareScreen` for heavy components
5. **Clean Up Resources**: Override `onScreenDeactivated` to pause operations

## Debugging

The utilities print helpful debug information to the console:

- 🟢 **Green Circle**: Screen became active
- 🔴 **Red Circle**: Screen became inactive  
- ⚫ **Black Circle**: Screen was disposed

Use these to verify that screens are properly tracking their state.
