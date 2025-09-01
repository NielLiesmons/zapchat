import 'package:zaplab_design/zaplab_design.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = LabTheme.of(context);

    return TabData(
      label: 'Tasks',
      icon: const LabEmojiContentType(contentType: 'task'),
      content: const TasksTab(),
      optionsDescription: "Task settings",
      optionssContent: LabContainer(
        child: Column(
          children: [
            LabSectionTitle("Tasks"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      child: LabModelEmptyStateCard(
        contentType: "task",
        onCreateTap: () {},
      ),
    );
  }
}
