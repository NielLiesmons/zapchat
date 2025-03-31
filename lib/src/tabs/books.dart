import 'package:zaplab_design/zaplab_design.dart';

class BooksTab extends StatelessWidget {
  const BooksTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Books',
      icon: const AppEmojiContentType(contentType: 'book'),
      content: Builder(
        builder: (context) {
          return AppContainer(
            padding: AppEdgeInsets.all(AppGapSize.s16),
            child: Column(
              children: [
                AppText.h1('Books'),
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
