import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../routes/event_routes.dart';
import '../providers/history.dart';

final historyViewIndexProvider = StateProvider<int>((ref) => 0);

class HistoryContent extends ConsumerWidget {
  const HistoryContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final selectedIndex = ref.watch(historyViewIndexProvider);

    return Column(
      children: [
        AppSearchField(
          placeholder:
              selectedIndex == 0 ? 'Search History' : 'Search Activity',
          onChanged: (value) {},
        ),
        const AppGap.s12(),
        AppSelector(
          small: true,
          initialIndex: 0,
          onChanged: (index) {
            ref.read(historyViewIndexProvider.notifier).state = index;
          },
          children: [
            AppSelectorButton(
              selectedContent: [
                AppText.reg12('Your History', color: theme.colors.white),
              ],
              unselectedContent: [
                AppText.reg12('Your History', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [
                AppText.reg12('Your Activity', color: theme.colors.white66),
              ],
              unselectedContent: [
                AppText.reg12('Your Activity', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
          ],
        ),
        const AppGap.s16(),
        if (selectedIndex == 0)
          AppContainer(
            constraints: const BoxConstraints(minHeight: 1000),
            child: Column(
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
                          print(
                              'History item tapped: ${item.modelType} - ${item.modelId}');
                          // Get the model from storage using querySync
                          final storage =
                              ref.read(storageNotifierProvider.notifier);
                          final models = storage.querySync(
                            RequestFilter(
                              ids: {item.modelId},
                              remote: false,
                            ),
                          );
                          print('Found models: ${models.length}');
                          if (models.isNotEmpty) {
                            final model = models.first;
                            final route = getModelRoute(item.modelType);
                            print('Navigating to: $route/${model.id}');
                            context.push('$route/${model.id}', extra: model);
                          } else {
                            print('No models found for ID: ${item.modelId}');
                          }
                        },
                      ),
                      const AppGap.s10(),
                    ],
                  ),
              ],
            ),
          )
        else
          AppPanel(
            child: Column(
              children: [
                const AppGap.s12(),
                AppText.h2('No activity yet',
                    color: theme.colors.white33, textAlign: TextAlign.center),
                SizedBox(
                  height: 1000,
                )
              ],
            ),
          ),
      ],
    );
  }
}

class SettingsHistoryModal extends ConsumerWidget {
  const SettingsHistoryModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppModal(
      title: "History",
      children: [
        const HistoryContent(),
      ],
    );
  }
}
