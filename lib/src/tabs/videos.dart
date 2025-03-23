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
            padding: AppEdgeInsets.all(AppGapSize.s16),
            child: Column(
              children: [
                AppText.h1('Videos'),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
