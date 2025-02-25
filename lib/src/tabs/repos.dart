import 'package:zaplab_design/zaplab_design.dart';

class ReposTab extends StatelessWidget {
  const ReposTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Repos',
      icon: const AppEmojiContentType(contentType: 'repo'),
      content: Builder(
        builder: (context) {
          final theme = AppTheme.of(context);

          return AppContainer(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Column(
              children: [
                AppText.h1('Repos'),
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
