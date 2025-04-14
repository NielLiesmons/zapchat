import 'package:zaplab_design/zaplab_design.dart';

class VideosTab extends StatelessWidget {
  const VideosTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Videos',
      icon: const AppEmojiContentType(contentType: 'video'),
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
