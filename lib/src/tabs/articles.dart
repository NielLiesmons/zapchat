import 'package:zaplab_design/zaplab_design.dart';

class ArticlesTab extends StatelessWidget {
  const ArticlesTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Articles',
      icon: const AppEmojiContentType(contentType: 'article'),
      content: Builder(
        builder: (context) {
          return AppContainer(
            padding: AppEdgeInsets.all(AppGapSize.s16),
            child: Column(
              children: [
                AppText.h1('Articles'),
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
