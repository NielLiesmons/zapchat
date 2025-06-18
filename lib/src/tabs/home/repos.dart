import 'package:zaplab_design/zaplab_design.dart';

class ReposTab extends StatelessWidget {
  const ReposTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Repos',
      icon: const LabEmojiContentType(contentType: 'repo'),
      bottomBar: LabBottomBarContentFeed(),
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
