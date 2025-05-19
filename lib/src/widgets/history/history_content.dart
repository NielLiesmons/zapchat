import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history.dart';

class HistoryContent extends ConsumerWidget {
  final bool showSearch;
  final bool showSelector;

  const HistoryContent({
    super.key,
    this.showSearch = true,
    this.showSelector = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        if (showSearch) ...[
          AppSearchField(
            placeholder: 'Search',
            onChanged: (value) {},
          ),
          const AppGap.s12(),
        ],
        if (showSelector) ...[
          AppSelector(
            children: [
              AppSelectorButton(
                selectedContent: [
                  AppText.reg14('Your History'),
                ],
                unselectedContent: [
                  AppText.reg14('Your History', color: theme.colors.white66),
                ],
                isSelected: true,
                onTap: () {},
              ),
              AppSelectorButton(
                selectedContent: [
                  AppText.reg14('Your Activity'),
                ],
                unselectedContent: [
                  AppText.reg14('Your Activity', color: theme.colors.white66),
                ],
                isSelected: true,
                onTap: () {},
              ),
            ],
            onChanged: (value) {},
          ),
          const AppGap.s16(),
        ],
        Column(
          children: [
            for (final item in ref.watch(historyProvider).when(
                  data: (items) => items.take(100),
                  loading: () => <HistoryEntry>[],
                  error: (_, __) => <HistoryEntry>[],
                ))
              Column(
                children: [
                  AppHistoryCard(
                    contentType: item.modelType,
                    displayText: item.displayText,
                    onTap: () {
                      // TODO: Navigate to the item
                    },
                  ),
                  const AppGap.s10(),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
