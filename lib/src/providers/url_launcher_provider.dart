import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher_pkg;

final urlLauncherProvider = Provider<UrlLauncherService>((ref) {
  return UrlLauncherService();
});

class UrlLauncherService {
  Future<bool> launchUrl(String url) async {
    // Add your custom logic here for handling different URL types
    // For now, just launch externally
    print('UrlLauncherService.launchUrl called with: $url');

    try {
      final uri = Uri.parse(url);
      print('Parsed URI: $uri');

      // Try to launch directly without checking canLaunchUrl first
      // as it can be unreliable on some devices
      final result = await url_launcher_pkg.launchUrl(
        uri,
        mode: url_launcher_pkg.LaunchMode.externalApplication,
      );
      print('Launch result: $result');
      return result;
    } catch (e) {
      print('Error in launchUrl: $e');
      return false;
    }
  }
}

extension UrlLauncherServiceExtension on WidgetRef {
  UrlLauncherService get urlLauncher => read(urlLauncherProvider);
}
