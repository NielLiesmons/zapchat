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
    final theme = LabTheme.of(context);
    final activeProfile = ref.watch(Signer.activeProfileProvider);

    return LabModal(
      title: 'Create New',
      description: 'Choose what you want to create',
      children: [
        // First row with Community and Private Group buttons
        const LabGap.s8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () => context.replace('/create/community'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabEmojiContentType(
                      contentType: 'community',
                      size: 32,
                    ),
                    const LabGap.s10(),
                    LabText.med14("Community"),
                  ],
                ),
              ),
            ),
            const LabGap.s8(),
            activeProfile != null
                ? Expanded(
                    child: LabPanelButton(
                      padding: const LabEdgeInsets.only(
                        top: LabGapSize.s20,
                        bottom: LabGapSize.s14,
                      ),
                      onTap: () => context.replace('/create/group'),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LabEmojiContentType(
                            contentType: 'group',
                            size: 32,
                          ),
                          const LabGap.s10(),
                          LabText.med14("Private Group"),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        activeProfile != null ? const LabGap.s8() : const LabGap.s12(),
        // Content type buttons in rows of three
        activeProfile != null
            ? Column(
                children: _buildContentTypeRows(context),
              )
            : Stack(
                children: [
                  LabContainer(
                    height: 240,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: _buildContentTypeRows(context),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(theme.sizes.s16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: LabContainer(
                        height: 260,
                        padding: LabEdgeInsets.all(LabGapSize.s24),
                        child: Column(
                          children: [
                            const LabGap.s20(),
                            LabContainer(
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
                                  width: LabLineThicknessData.normal().thin,
                                ),
                              ),
                              child: Center(
                                child: LabIcon.s64(
                                    theme.icons.characters.profile,
                                    color: theme.colors.white33),
                              ),
                            ),
                            const LabGap.s12(),
                            LabText.med14(
                                "You need a Profile to publish content",
                                color: theme.colors.white66),
                            const LabGap.s16(),
                            LabButton(
                              children: [
                                LabIcon.s12(theme.icons.characters.play,
                                    color: theme.colors.whiteEnforced),
                                const LabGap.s12(),
                                LabText.med14("Start"),
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

  List<Widget> _buildContentTypeRows(BuildContext context) {
    final contentTypes = [
      'mail',
      'task',
      'note',
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
      'event',
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
              child: LabPanelButton(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s20,
                  bottom: LabGapSize.s14,
                ),
                onTap: () {
                  context.replace('/create/${contentTypes[index]}');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabEmojiContentType(
                      contentType: contentTypes[index],
                      size: 32,
                    ),
                    const LabGap.s10(),
                    LabText.med14(
                      contentTypes[index][0].toUpperCase() +
                          contentTypes[index].substring(1),
                    ),
                  ],
                ),
              ),
            ),
          );
          if (col < 2) {
            rowItems.add(const LabGap.s8());
          }
        } else {
          rowItems.add(const Expanded(child: SizedBox()));
          if (col < 2) {
            rowItems.add(const LabGap.s8());
          }
        }
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowItems,
      ));
      if (row < rowCount - 1) {
        rows.add(const LabGap.s8());
      }
    }

    return rows;
  }
}
