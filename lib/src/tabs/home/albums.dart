import 'package:zaplab_design/zaplab_design.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Albums',
      icon: const LabEmojiContentType(contentType: 'album'),
      content: Builder(
        builder: (context) {
          return LabContainer(
            padding: const LabEdgeInsets.all(LabGapSize.s12),
            child: LabModelEmptyStateCard(
              contentType: "album",
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
