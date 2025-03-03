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
        print('Initializing app with:');
        print('  - Text scale: ${state.textScale}');
        print('  - System scale: ${state.systemScale}');
        print('  - Theme mode: ${state.colorMode}');

        return AppResponsiveTheme(
          colorMode: state.colorMode,
          textScale: state.textScale,
          systemScale: state.systemScale,
          child: AppBase(
            title: 'Zapchat',
            routerConfig: goRouter,
            appLogo: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
            darkAppLogo: Image.asset(
              'assets/images/logo_dark.png',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      loading: () => AppResponsiveTheme(
        colorMode: null, // Use system theme
        textScale: AppTextScale.normal,
        systemScale: AppSystemScale.normal,
        child: AppBase(
          title: 'Zapchat',
          routerConfig: goRouter,
          appLogo: const SizedBox(),
          darkAppLogo: const SizedBox(),
        ),
      ),
      error: (_, __) => AppResponsiveTheme(
        colorMode: null, // Use system theme
        textScale: AppTextScale.normal,
        systemScale: AppSystemScale.normal,
        child: AppBase(
          title: 'Zapchat',
          routerConfig: goRouter,
          appLogo: const SizedBox(),
          darkAppLogo: const SizedBox(),
        ),
      ),
    );
  }
}
