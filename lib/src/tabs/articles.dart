import 'package:zaplab_design/zaplab_design.dart';

class ArticlesTab extends StatelessWidget {
  const ArticlesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Articles',
      icon: const AppEmojiContentType(contentType: 'article'),
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
