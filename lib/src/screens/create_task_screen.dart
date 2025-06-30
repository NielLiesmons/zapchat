import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({
    super.key,
  });

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  bool _hasRequiredFields = false;

  @override
  void initState() {
    super.initState();
  }

  void _updateHasRequiredFields() {
    setState(() {
      _hasRequiredFields = true;
    });
  }

  void _onShareTap() {
    if (_hasRequiredFields) {
      context.push(
        '/share/task',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabScreen(
      onHomeTap: () => context.pop(),
      alwaysShowTopBar: true,
      topBarContent: LabContainer(
        padding: const LabEdgeInsets.symmetric(
          vertical: LabGapSize.s4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LabGap.s8(),
                LabText.med14('Create Task'),
                const LabGap.s12(),
                const Spacer(),
                LabKeyboardSubmitHandler(
                  onSubmit: _hasRequiredFields ? _onShareTap : () {},
                  enabled: _hasRequiredFields,
                  child: LabSmallButton(
                    onTap: _onShareTap,
                    rounded: true,
                    inactiveGradient: _hasRequiredFields
                        ? theme.colors.blurple
                        : theme.colors.blurple33,
                    children: [
                      const LabGap.s4(),
                      LabText.med14(
                        'Share',
                        color: _hasRequiredFields
                            ? theme.colors.white
                            : theme.colors.white66,
                      ),
                      const LabGap.s4(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LabGap.s48(),
          const LabGap.s2(),
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabInputTextField(
                  placeholder: "Task Name",
                  style: theme.typography.h2,
                  backgroundColor: theme.colors.gray33,
                ),
                const LabGap.s12(),
                LabInputButton(
                  onTap: () {},
                  minHeight: theme.sizes.s96,
                  topAlignment: true,
                  children: [
                    LabText.reg14("Description of Task",
                        color: theme.colors.white33),
                    const Spacer(),
                    const LabGap.s12(),
                    LabIcon.s12(
                      theme.icons.characters.pen,
                      color: theme.colors.white33,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabLShape(
                      width: 32,
                      height: 30,
                      padding: LabGapSize.s16,
                      color: theme.colors.white33,
                      strokeWidth: LabLineThicknessData.normal().medium,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: LabContainer(
                        padding: const LabEdgeInsets.only(
                          top: LabGapSize.s14,
                          bottom: LabGapSize.none,
                        ),
                        child: Row(
                          children: [
                            LabSmallButton(
                              onTap: () {},
                              inactiveColor: theme.colors.gray66,
                              padding: const LabEdgeInsets.only(
                                left: LabGapSize.s8,
                                right: LabGapSize.s12,
                              ),
                              children: [
                                LabIcon.s14(
                                  theme.icons.characters.plus,
                                  outlineColor: theme.colors.white33,
                                  outlineThickness:
                                      LabLineThicknessData.normal().thick,
                                ),
                                const LabGap.s8(),
                                LabText.reg14("Target Publications  /  Files",
                                    color: theme.colors.white33),
                              ],
                            ),
                            // for (final model in taggedModels ?? [])
                            //   Row(
                            //     children: [
                            //       LabModelButton(
                            //         model: model,
                            //         onTap: () {},
                            //       ),
                            //       const LabGap.s8(),
                            //     ],
                            //   ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.only(
              top: LabGapSize.s12,
              bottom: LabGapSize.s16,
              left: LabGapSize.s16,
              right: LabGapSize.s16,
            ),
            child: Column(
              children: [
                LabSectionTitle("Status"),
                LabPanelButton(
                  onTap: () {},
                  child: Row(
                    children: [
                      LabTaskBox(state: TaskBoxState.open),
                      const LabGap.s12(),
                      LabText.reg14(
                        "Open",
                        color: theme.colors.white33,
                      ),
                      const Spacer(),
                      LabIcon.s12(
                        theme.icons.characters.pen,
                        color: theme.colors.white33,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.only(
              top: LabGapSize.s12,
              bottom: LabGapSize.s16,
              left: LabGapSize.s16,
              right: LabGapSize.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabSectionTitle("Labels"),
                const LabGap.s4(),
                LabInputButton(
                  onTap: () {},
                  children: [
                    LabText.reg14("Search / Add Label",
                        color: theme.colors.white33),
                    const Spacer(),
                  ],
                ),
                const LabGap.s12(),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    LabLabel(
                      "Urgent",
                      onTap: () {},
                    ),
                    LabLabel(
                      "Marketing",
                      onTap: () {},
                    ),
                    LabLabel(
                      "Bugs",
                      onTap: () {},
                    ),
                    LabLabel(
                      "R&D",
                      onTap: () {},
                    ),
                    LabLabel(
                      "Big Picture",
                      onTap: () {},
                    ),
                    LabLabel(
                      "Design",
                      onTap: () {},
                    ),
                    LabLabel(
                      "Would Be Nice",
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.only(
              top: LabGapSize.s12,
              bottom: LabGapSize.s16,
              left: LabGapSize.s16,
              right: LabGapSize.s16,
            ),
            child: Column(
              children: [
                LabSectionTitle("Attachments"),
                LabPanelButton(
                  onTap: () {},
                  color: theme.colors.gray33,
                  child: Row(
                    children: [
                      LabIcon.s24(
                        theme.icons.characters.attachment,
                        outlineColor: theme.colors.white33,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      ),
                      const LabGap.s12(),
                      LabText.reg14(
                        "Add Files & Publications",
                        color: theme.colors.white33,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const LabDivider(),
        ],
      ),
    );
  }
}
