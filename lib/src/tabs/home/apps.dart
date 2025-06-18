import 'package:zaplab_design/zaplab_design.dart';

class AppsTab extends StatelessWidget {
  const AppsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Apps',
      icon: const LabEmojiContentType(contentType: 'app'),
      content: Builder(
        builder: (context) {
          return LabContainer(
            child: const LabLoadingFeed(type: LoadingFeedType.thread),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
