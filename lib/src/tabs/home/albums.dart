import 'package:zaplab_design/zaplab_design.dart';

class ImagesTab extends StatelessWidget {
  const ImagesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Albums',
      icon: const AppEmojiContentType(contentType: 'album'),
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
