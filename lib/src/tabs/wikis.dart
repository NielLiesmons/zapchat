import 'package:zaplab_design/zaplab_design.dart';

class WikisTab extends StatelessWidget {
  const WikisTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Wikis',
      icon: const AppEmojiContentType(contentType: 'wiki'),
      content: Builder(
        builder: (context) {
          final theme = AppTheme.of(context);

          return AppContainer(
            padding: const AppEdgeInsets.all(AppGapSize.s16),
            child: Column(
              children: [
                AppButton(
                  children: [
                    AppLoadingDots(),
                  ],
                  onTap: () {},
                  inactiveGradient: theme.colors.blurple66,
                  pressedGradient: theme.colors.blurple66,
                ),
                const AppGap.s16(),
                const AppLoadBar(progress: 0.72),
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
