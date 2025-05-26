import 'package:zaplab_design/zaplab_design.dart';

class WikisTab extends StatelessWidget {
  const WikisTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Wikis',
      icon: const AppEmojiContentType(contentType: 'wiki'),
      content: Builder(
        builder: (context) {
          return AppContainer(
            child: const AppLoadingFeed(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
