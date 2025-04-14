import 'package:zaplab_design/zaplab_design.dart';

class ImagesTab extends StatelessWidget {
  const ImagesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Images',
      icon: const AppEmojiContentType(contentType: 'image'),
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
