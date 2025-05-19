import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/history/history_content.dart';
import '../providers/history.dart';

class SettingsHistoryModal extends ConsumerWidget {
  const SettingsHistoryModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppModal(
      title: 'History',
      children: [
        AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Clear History',
                onTap: () {
                  ref.read(historyProvider.notifier).clear();
                },
              ),
            ],
          ),
        ),
        const HistoryContent(),
      ],
    );
  }
}
