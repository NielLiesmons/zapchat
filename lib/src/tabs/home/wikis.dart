import 'package:zaplab_design/zaplab_design.dart';

class WikisTab extends StatelessWidget {
  const WikisTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Wikis',
      icon: const LabEmojiContentType(contentType: 'wiki'),
      content: Builder(
        builder: (context) {
          return LabContainer(
            child: const LabLoadingFeed(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
