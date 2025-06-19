import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({
    super.key,
  });

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  late DateTime selectedDate;
  LabTime? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  String getDisplayText() {
    final dateStr = selectedDate.toString().split(' ')[0];
    return '$dateStr${selectedTime != null ? ' at ${selectedTime.toString()}' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabScreen(
      onHomeTap: () => context.pop(),
      child: LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabText.h2('Event Date'),
            const LabGap.s16(),
            LabButton(
              onTap: () async {
                final result = await LabDatePickerModal.show(
                  context,
                  initialDate: selectedDate,
                  initialTime: selectedTime,
                );
                if (result != null) {
                  setState(() {
                    selectedDate = result.$1;
                    selectedTime = result.$2;
                  });
                }
              },
              inactiveColor: theme.colors.white8,
              children: [
                LabText.med14(getDisplayText()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
