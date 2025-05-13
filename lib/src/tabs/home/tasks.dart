import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../../providers/resolvers.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Tasks',
      icon: const AppEmojiContentType(contentType: 'task'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final tasks = ref.watch(query<Task>()).models.cast<Task>();

          return Column(
            children: [
              for (final task in tasks)
                AppFeedTask(
                  isUnread: true,
                  task: task,
                  onTap: (model) => context.push('/task/${model.id}'),
                  state: TaskStatus.inReview,
                  taggedModels: [
                    PartialRepository(
                      'Zapchat',
                      'Zapchat is a chat app',
                    ).dummySign()
                  ],
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
