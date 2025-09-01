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
            padding: const LabEdgeInsets.all(LabGapSize.s12),
            child: LabModelEmptyStateCard(
              contentType: "file",
              onCreateTap: () {},
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
