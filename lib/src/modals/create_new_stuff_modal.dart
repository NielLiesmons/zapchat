import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'dart:ui';

class CreateNewStuffModal extends ConsumerWidget {
  const CreateNewStuffModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final activeProfile = ref.watch(Signer.activeProfileProvider);

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
            activeProfile != null
                ? Expanded(
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
                  )
                : SizedBox.shrink(),
          ],
        ),
        activeProfile != null ? const AppGap.s8() : const AppGap.s12(),
        // Content type buttons in rows of three
        activeProfile != null
            ? Column(
                children: _buildContentTypeRows(),
              )
            : Stack(
                children: [
                  AppContainer(
                    height: 240,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: _buildContentTypeRows(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(theme.sizes.s16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AppContainer(
                        height: 260,
                        padding: AppEdgeInsets.all(AppGapSize.s24),
                        child: Column(
                          children: [
                            const AppGap.s20(),
                            AppContainer(
                              width: theme.sizes.s96,
                              height: theme.sizes.s96,
                              decoration: BoxDecoration(
                                color: theme.colors.gray66,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colors.black66,
                                    blurRadius: theme.sizes.s32,
                                  ),
                                ],
                                border: Border.all(
                                  color: theme.colors.white16,
                                  width: AppLineThicknessData.normal().thin,
                                ),
                              ),
                              child: Center(
                                child: AppIcon.s64(
                                    theme.icons.characters.profile,
                                    color: theme.colors.white33),
                              ),
                            ),
                            const AppGap.s12(),
                            AppText.med14(
                                "You need a Profile to publish content",
                                color: theme.colors.white66),
                            const AppGap.s16(),
                            AppButton(
                              children: [
                                AppIcon.s12(theme.icons.characters.play,
                                    color: theme.colors.whiteEnforced),
                                const AppGap.s12(),
                                AppText.med14("Start"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
