import 'src/initialization.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'src/router.dart';
import 'src/providers/theme_settings.dart';
import 'src/modals/settings_history_modal.dart';
import 'src/homepage.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final value = ref.watch(zapchatInitializationProvider);
          return switch (value) {
            AsyncLoading() => LabResponsiveTheme(
                child: LabBase(
                  title: 'Zapchat',
                  routerConfig: GoRouter(
                    routes: [
                      GoRoute(
                        path: '/',
                        builder: (context, state) => LabScaffold(
                          body: LabContainer(
                            alignment: Alignment.center,
                            child: const LabLoadingDots(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  colorMode: null,
                  textScale: LabTextScale.normal,
                  systemScale: LabSystemScale.normal,
                ),
              ),
            AsyncError(:final error) => LabResponsiveTheme(
                child: LabBase(
                  title: 'Zapchat',
                  routerConfig: GoRouter(
                    routes: [
                      GoRoute(
                        path: '/',
                        builder: (context, state) => LabScaffold(
                          body: LabContainer(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LabText.h2('Error during initialization:'),
                                const LabGap.s8(),
                                LabSelectableText(text: error.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  colorMode: null,
                  textScale: LabTextScale.normal,
                  systemScale: LabSystemScale.normal,
                ),
              ),
            AsyncValue() => _LabWithTheme(),
          };
        },
      ),
    );
  }
}

class _LabWithTheme extends ConsumerWidget {
  const _LabWithTheme();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeSettingsProvider);

    return themeState.when(
      data: (state) {
        return LabBase(
          title: 'Zapchat',
          routerConfig: goRouter,
          colorMode: state.colorMode,
          textScale: state.textScale,
          systemScale: state.systemScale,
          colorsOverride: state.colorsOverride,
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
          onAddTap: () {
            goRouter.push('/create');
            print('onAddTap');
          },
          onProfilesTap: () {
            goRouter.push('/settings');
          },
          // TODO: activeProfile could be read from zaplab
          activeProfile: ref.watch(Signer.activeProfileProvider),
          historyMenu: const HistoryContent(),
        );
      },
      loading: () => LabBase(
        title: 'Zapchat',
        routerConfig: goRouter,
        colorMode: null,
        textScale: LabTextScale.normal,
        systemScale: LabSystemScale.normal,
      ),
      error: (_, __) => LabBase(
        title: 'Zapchat',
        routerConfig: goRouter,
        colorMode: null,
        textScale: LabTextScale.normal,
        systemScale: LabSystemScale.normal,
      ),
    );
  }
}
