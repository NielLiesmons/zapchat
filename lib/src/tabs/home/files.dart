import 'package:zaplab_design/zaplab_design.dart';

class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Files',
      icon: const LabEmojiContentType(contentType: 'file'),
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
