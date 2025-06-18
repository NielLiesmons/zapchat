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
  DateTime? selectedDate;

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

            // Date picker
            LabDatePicker(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                print('Selected date: $date');
              },
            ),

            const LabGap.s24(),

            // Display selected date
            if (selectedDate != null) ...[
              LabText.bold14('Selected Date:'),
              const LabGap.s8(),
              LabText.reg14(
                '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                color: theme.colors.white66,
              ),
              const LabGap.s24(),
            ],

            // Create button
            LabButton(
              onTap: selectedDate != null
                  ? () {
                      // Handle event creation
                      print('Creating event for date: $selectedDate');
                      context.pop();
                    }
                  : null,
              children: [
                LabIcon.s12(
                  theme.icons.characters.plus,
                  color: theme.colors.whiteEnforced,
                ),
                const LabGap.s12(),
                LabText.med14(
                  'Create Event',
                  color: theme.colors.whiteEnforced,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
