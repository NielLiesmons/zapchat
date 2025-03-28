import 'package:zaplab_design/zaplab_design.dart';

class AppsTab extends StatelessWidget {
  const AppsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Apps',
      icon: const AppEmojiContentType(contentType: 'app'),
      content: Builder(
        builder: (context) {
          return AppContainer(
            padding: const AppEdgeInsets.all(AppGapSize.s12),
            child: Column(
              children: [
                AppText.h1('Apps'),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
