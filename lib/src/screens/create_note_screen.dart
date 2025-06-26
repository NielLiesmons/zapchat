import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

class CreateNoteScreen extends ConsumerStatefulWidget {
  const CreateNoteScreen({
    super.key,
  });

  @override
  ConsumerState<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends ConsumerState<CreateNoteScreen> {
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
        '/share/note',
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
                LabText.med14('Create Note'),
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabGap.s48(),
              const LabGap.s2(),
              LabContainer(
                height:
                    MediaQuery.of(context).size.height / theme.system.scale -
                        80 -
                        MediaQuery.of(context).viewInsets.bottom,
                padding: const LabEdgeInsets.all(
                  LabGapSize.s16,
                ),
                child: Column(
                  children: [
                    LabEditableInputText(
                      text: '',
                      style: theme.typography.h2,
                      controller: TextEditingController(),
                      focusNode: FocusNode(),
                      placeholder: [
                        LabText.h2(
                          'Title of Note',
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right:
                LabPlatformUtils.isMobile ? theme.sizes.s12 : theme.sizes.s16,
            bottom:
                LabPlatformUtils.isMobile ? theme.sizes.s12 : theme.sizes.s16,
            child: LabLongTextBar(),
          ),
        ],
      ),
    );
  }
}
