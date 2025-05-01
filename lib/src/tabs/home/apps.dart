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
            child: const AppLoadingFeed(type: LoadingFeedType.thread),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
