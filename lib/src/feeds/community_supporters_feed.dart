import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunitySupportersFeed extends ConsumerWidget {
  final Community community;

  const CommunitySupportersFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);
    final state = ref.watch(query<Profile>());

    if (state case StorageLoading()) {
      return const LabLoadingFeed();
    }

    final supporters = state.models.cast<Profile>();

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabText.bold16('Supporters', color: theme.colors.whiteEnforced),
          const LabGap.s16(),
          if (supporters.isEmpty)
            LabContainer(
              padding: const LabEdgeInsets.all(LabGapSize.s16),
              decoration: BoxDecoration(
                color: theme.colors.white8,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: LabText.reg14(
                  'No supporters yet',
                  color: theme.colors.white66,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final supporter
                    in supporters.take(20)) // Limit to first 20
                  LabProfilePic.s32(
                    supporter,
                    onTap: () => context.push('/profile/${supporter.npub}',
                        extra: supporter),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
