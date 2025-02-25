import 'package:zaplab_design/zaplab_design.dart';

class ImagesTab extends StatelessWidget {
  const ImagesTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Images',
      icon: const AppEmojiContentType(contentType: 'image'),
      content: Builder(
        builder: (context) {
          return AppContainer(
            padding: AppEdgeInsets.all(AppGapSize.s16),
            child: Column(
              children: [
                AppText.h1('Images'),
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
