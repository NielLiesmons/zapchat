import 'package:zapchat/src/initialization.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'src/router/router.dart';
import 'src/providers/theme_settings.dart';
import 'src/providers/user_profiles.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final value = ref.watch(zapchatInitializationProvider);
          return switch (value) {
            AsyncLoading() => AppResponsiveTheme(
                child: AppBase(
                  title: 'Zapchat',
                  routerConfig: GoRouter(
                    routes: [
                      GoRoute(
                        path: '/',
                        builder: (context, state) => AppScaffold(
                          body: AppContainer(
                            alignment: Alignment.center,
                            child: const AppLoadingDots(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  colorMode: null,
                  textScale: AppTextScale.normal,
                  systemScale: AppSystemScale.normal,
                ),
              ),
            AsyncError(:final error) => AppResponsiveTheme(
                child: AppBase(
                  title: 'Zapchat',
                  routerConfig: GoRouter(
                    routes: [
                      GoRoute(
                        path: '/',
                        builder: (context, state) => AppScaffold(
                          body: AppContainer(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText.h2('Error during initialization:'),
                                const AppGap.s8(),
                                AppText.med14(error.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  colorMode: null,
                  textScale: AppTextScale.normal,
                  systemScale: AppSystemScale.normal,
                ),
              ),
            AsyncValue() => _AppWithTheme(),
          };
        },
      ),
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
          onHomeTap: () {
            goRouter.go('/');
          },
          onBackTap: () {
            if (goRouter.canPop()) {
              goRouter.pop();
            } else {
              goRouter.go('/');
            }
          },
          onSearchTap: () {},
          onAddTap: () {},
          onProfilesTap: () {
            goRouter.push('/settings');
          },
          currentProfile: ref.watch(userProfilesProvider).when(
                data: (data) => data.$2,
                loading: () => null,
                error: (_, __) => null,
              ),
          historyMenu: Column(
            children: [
              for (var i = 0; i < 10; i++)
                Column(
                  children: [
                    AppPanel(
                      child: AppText.reg12('History Item $i'),
                    ),
                    const AppGap.s8(),
                  ],
                ),
            ],
          ),
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
