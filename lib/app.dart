import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/router.dart';
import 'src/providers/theme_settings.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProviderScope(
      child: _AppWithTheme(),
    );
  }
}

class _AppWithTheme extends ConsumerWidget {
  const _AppWithTheme();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeSettingsProvider);

    return themeState.when(
      data: (state) {
        return AppBase(
          title: 'Zapchat',
          routerConfig: goRouter,
          colorMode: state.colorMode,
          textScale: state.textScale,
          systemScale: state.systemScale,
        );
      },
      loading: () => AppBase(
        title: 'Zapchat',
        routerConfig: goRouter,
        colorMode: null, // Use system theme
        textScale: AppTextScale.normal,
        systemScale: AppSystemScale.normal,
      ),
      error: (_, __) => AppBase(
        title: 'Zapchat',
        routerConfig: goRouter,
        colorMode: null, // Use system theme
        textScale: AppTextScale.normal,
        systemScale: AppSystemScale.normal,
      ),
    );
  }
}
