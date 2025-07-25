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
            child: const LabLoadingFeed(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
