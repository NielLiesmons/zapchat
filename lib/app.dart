import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/homepage.dart';
import 'src/router.dart';

class App extends ConsumerWidget {
  App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
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
  }
}
