import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Tasks',
      icon: const LabEmojiContentType(contentType: 'task'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final tasks = ref.watch(query<Task>()).models.cast<Task>();

          return Column(
            children: [
              // This is for testing purposes
              if (tasks.isNotEmpty) ...[
                LabFeedTask(
                  isUnread: true,
                  task: tasks[0],
                  onTap: (model) => context.push('/task/${model.id}'),
                  onTaggedModelTap: (model) =>
                      context.push('/model/${model.id}'),
                  onSwipeLeft: (model) => {},
                  onSwipeRight: (model) => {},
                ),
                if (tasks.length > 1)
                  LabFeedTask(
                    isUnread: true,
                    task: tasks[1],
                    onTap: (model) => context.push('/task/${model.id}'),
                    taggedModels: [],
                    onTaggedModelTap: (model) =>
                        context.push('/model/${model.id}'),
                    onSwipeLeft: (model) => {},
                    onSwipeRight: (model) => {},
                  ),
                if (tasks.length > 2)
                  LabFeedTask(
                    isUnread: true,
                    task: tasks[2],
                    onTap: (model) => context.push('/task/${model.id}'),
                    onTaggedModelTap: (model) =>
                        context.push('/model/${model.id}'),
                    onSwipeLeft: (model) => {},
                    onSwipeRight: (model) => {},
                  ),
                if (tasks.length > 3)
                  LabFeedTask(
                    isUnread: true,
                    task: tasks[3],
                    onTap: (model) => context.push('/task/${model.id}'),
                    taggedModels: [],
                    onTaggedModelTap: (model) =>
                        context.push('/model/${model.id}'),
                    onSwipeLeft: (model) => {},
                    onSwipeRight: (model) => {},
                  ),
              ],
              // Rest of the tasks
              for (final task in tasks.skip(4))
                LabFeedTask(
                  isUnread: true,
                  task: task,
                  onTap: (model) => context.push('/task/${model.id}'),
                  onTaggedModelTap: (model) =>
                      context.push('/model/${model.id}'),
                  onSwipeLeft: (model) => {},
                  onSwipeRight: (model) => {},
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
