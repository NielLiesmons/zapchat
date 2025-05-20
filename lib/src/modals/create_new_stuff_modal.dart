import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateNewStuffModal extends ConsumerWidget {
  const CreateNewStuffModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppModal(
      title: 'Create New',
      description: 'Choose what you want to create',
      children: [
        // First row with Community and Private Group buttons
        const AppGap.s8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => context.replace('/create/community'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppEmojiContentType(
                      contentType: 'community',
                      size: 32,
                    ),
                    const AppGap.s10(),
                    AppText.med14("Community"),
                  ],
                ),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () => context.replace('/create/group'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppEmojiContentType(
                      contentType: 'group',
                      size: 32,
                    ),
                    const AppGap.s10(),
                    AppText.med14("Private Group"),
                  ],
                ),
              ),
            ),
          ],
        ),
        const AppGap.s8(),
        // Content type buttons in rows of three
        ..._buildContentTypeRows(),
      ],
    );
  }

  List<Widget> _buildContentTypeRows() {
    final contentTypes = [
      'mail',
      'task',
      'article',
      'thread',
      'app',
      'poll',
      'work-out',
      'doc',
      'video',
      'wiki',
      'album',
      'repo',
      'book',
      'service',
      'job',
    ];

    final rows = <Widget>[];
    final rowCount = (contentTypes.length / 3).ceil();

    for (var row = 0; row < rowCount; row++) {
      final rowItems = <Widget>[];
      for (var col = 0; col < 3; col++) {
        final index = row * 3 + col;
        if (index < contentTypes.length) {
          rowItems.add(
            Expanded(
              child: AppPanelButton(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s20,
                  bottom: AppGapSize.s14,
                ),
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppEmojiContentType(
                      contentType: contentTypes[index],
                      size: 32,
                    ),
                    const AppGap.s10(),
                    AppText.med14(
                      contentTypes[index][0].toUpperCase() +
                          contentTypes[index].substring(1),
                    ),
                  ],
                ),
              ),
            ),
          );
          if (col < 2) {
            rowItems.add(const AppGap.s8());
          }
        } else {
          rowItems.add(const Expanded(child: SizedBox()));
          if (col < 2) {
            rowItems.add(const AppGap.s8());
          }
        }
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowItems,
      ));
      if (row < rowCount - 1) {
        rows.add(const AppGap.s8());
      }
    }

    return rows;
  }
}
