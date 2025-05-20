import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityBooksFeed extends ConsumerWidget {
  final Community community;

  const CommunityBooksFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final state = ref.watch(query<Book>());

    if (state case StorageLoading()) {
      return const AppLoadingFeed();
    }

    final books = state.models.cast<Book>();

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Wrap(
        spacing: theme.sizes.s16,
        runSpacing: theme.sizes.s16,
        children: [
          for (final book in books)
            AppBookCard(
              book: book,
              onTap: () => context.push('/book/${book.id}', extra: book),
            ),
        ],
      ),
    );
  }
}
