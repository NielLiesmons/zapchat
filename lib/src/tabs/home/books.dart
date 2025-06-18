import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

class BooksTab extends StatelessWidget {
  const BooksTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Books',
      icon: const LabEmojiContentType(contentType: 'book'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final theme = LabTheme.of(context);

          final state = ref.watch(query<Book>());

          if (state case StorageLoading()) {
            return const LabLoadingFeed();
          }

          final books = state.models.cast<Book>();
          return LabContainer(
            padding: const LabEdgeInsets.all(LabGapSize.s16),
            child: Wrap(
              spacing: theme.sizes.s16,
              runSpacing: theme.sizes.s16,
              children: [
                for (final book in books)
                  LabBookCard(
                    book: book,
                    onTap: () => context.push('/book/${book.id}', extra: book),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
