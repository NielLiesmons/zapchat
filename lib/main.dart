import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:purplebase/purplebase.dart';

import 'package:zaplab_design/zaplab_design.dart';
import 'src/router.dart' show goRouter;
import 'src/initialization.dart';
import 'src/providers/theme_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsApp.showPerformanceOverlayOverride = true;

  runApp(
    ProviderScope(
      overrides: [
        storageNotifierProvider.overrideWith(PurplebaseStorageNotifier.new),
      ],
      child: const PurplebaseTestApp(),
    ),
  );
}

class PurplebaseTestApp extends ConsumerWidget {
  const PurplebaseTestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = ref.watch(purplebaseInitializationProvider);
    final themeState = ref.watch(themeSettingsProvider);

    if (initState.isLoading) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: const Center(child: Text('Loading...')),
      );
    }

    return themeState.when(
      data: (themeData) => LabBase(
        title: 'Purplebase Test - Basic Flutter',
        routerConfig: goRouter,
        colorMode: themeData.colorMode,
        textScale: themeData.textScale,
        systemScale: themeData.systemScale,
        colorsOverride: themeData.colorsOverride,
      ),
      loading: () => const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: Text('Loading theme...')),
      ),
      error: (error, stack) => Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: Text('Theme error: $error')),
      ),
    );
  }
}
