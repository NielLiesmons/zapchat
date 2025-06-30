import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({
    super.key,
  });

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  late DateTime selectedDate;
  LabTime? selectedTime;
  bool _hasRequiredFields = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void _updateHasRequiredFields() {
    setState(() {
      _hasRequiredFields = selectedDate != null && selectedTime != null;
    });
  }

  void _onShareTap() {
    if (_hasRequiredFields) {
      context.push(
        '/share/event',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getDisplayText() {
    final dateStr = selectedDate.toString().split(' ')[0];
    return '$dateStr${selectedTime != null ? ' at ${selectedTime.toString()}' : ''}';
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
                LabText.med14('Create Event'),
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
              children: [
                LabImageUploadCard(),
                const LabGap.s12(),
                LabInputTextField(
                  placeholder: "Event Name",
                  style: theme.typography.h2,
                  backgroundColor: theme.colors.gray33,
                ),
                const LabGap.s12(),
                LabInputButton(
                  minHeight: theme.sizes.s96,
                  topAlignment: true,
                  children: [
                    LabText.reg14("Description of Event",
                        color: theme.colors.white33),
                    const Spacer(),
                    const LabGap.s12(),
                    LabIcon.s12(
                      theme.icons.characters.pen,
                      color: theme.colors.white33,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const LabDivider(),
          LabDatesInputDisplay(),
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
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s16,
            ),
            child: Column(
              children: [
                LabButton(
                  onTap: () async {
                    final result = await LabDatePickerModal.show(
                      context,
                      initialDate: selectedDate,
                      initialTime: selectedTime,
                    );
                    if (result != null) {
                      setState(() {
                        selectedDate = result.$1;
                        selectedTime = result.$2;
                      });
                    }
                  },
                  inactiveColor: theme.colors.white8,
                  children: [
                    LabText.med14(getDisplayText()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
