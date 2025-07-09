import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:go_router/go_router.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({
    super.key,
  });

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  late TextEditingController _communityNameController;
  late FocusNode _communityNameFocusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _communityNameController = TextEditingController();
    _communityNameFocusNode = FocusNode();
    _communityNameController.addListener(_updateHasText);
  }

  void _updateHasText() {
    setState(() {
      _hasText = _communityNameController.text.isNotEmpty;
    });
  }

  void _onNextTap() {
    if (_hasText) {
      context.push(
        '/create/community/spin-up-community-key',
        extra: _communityNameController.text,
      );
    }
  }

  @override
  void dispose() {
    _communityNameController.removeListener(_updateHasText);
    _communityNameController.dispose();
    _communityNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final signedInPubkeys = ref.watch(Signer.signedInPubkeysProvider);
    final state = ref.watch(query<Profile>(authors: signedInPubkeys));

    if (state case StorageLoading()) {
      return const Center(
        child: LabLoadingDots(),
      );
    }

    final profiles = state.models.cast<Profile>();

    return LabScreen(
      onHomeTap: () => Navigator.of(context).pop(),
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
                LabText.med14('Create Community'),
                const LabGap.s12(),
                const Spacer(),
                LabKeyboardSubmitHandler(
                  onSubmit: _hasText ? _onNextTap : () {},
                  enabled: _hasText,
                  child: LabSmallButton(
                    onTap: _onNextTap,
                    rounded: true,
                    gradient: _hasText
                        ? theme.colors.blurple
                        : theme.colors.blurple33,
                    children: [
                      const LabGap.s4(),
                      LabText.med14(
                        'Next',
                        color: _hasText
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
      child: LabKeyboardSubmitHandler(
        onSubmit: _hasText ? _onNextTap : () {},
        enabled: _hasText,
        child: LabContainer(
          padding: const LabEdgeInsets.symmetric(
            horizontal: LabGapSize.s12,
          ),
          child: Column(
            children: [
              const LabGap.s64(),
              LabPanel(
                padding: const LabEdgeInsets.all(LabGapSize.s12),
                child: Column(
                  children: [
                    LabText.h2('Create a Community Profile',
                        color: theme.colors.white66,
                        textAlign: TextAlign.center),
                    const LabGap.s16(),
                    LabInputTextField(
                      title: 'Choose a Community Name',
                      controller: _communityNameController,
                      focusNode: _communityNameFocusNode,
                      placeholder: 'Community name',
                    ),
                  ],
                ),
              ),
              const LabGap.s12(),
              Row(
                children: [
                  const Expanded(child: LabDivider()),
                  const LabGap.s12(),
                  LabText.h3('OR', color: theme.colors.white66),
                  const LabGap.s12(),
                  const Expanded(child: LabDivider()),
                ],
              ),
              const LabGap.s12(),
              LabPanel(
                padding: const LabEdgeInsets.all(LabGapSize.s12),
                child: Column(
                  children: [
                    LabText.h2('Use an existing Profile',
                        color: theme.colors.white66,
                        textAlign: TextAlign.center),
                    const LabGap.s4(),
                    LabText.reg14(
                        'Select or Add a Profile that you want \nto turn into a Community',
                        textAlign: TextAlign.center),
                    const LabGap.s12(),
                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...profiles
                              .map(
                                (profile) => [
                                  LabProfilePic.s48(profile),
                                  const LabGap.s12(),
                                ],
                              )
                              .expand((x) => x),
                          TapBuilder(
                            onTap: () {},
                            builder: (context, state, isFocused) {
                              double scaleFactor = 1.0;
                              if (state == TapState.pressed) {
                                scaleFactor = 0.98;
                              } else if (state == TapState.hover) {
                                scaleFactor = 1.02;
                              }

                              return Transform.scale(
                                scale: scaleFactor,
                                child: LabContainer(
                                  width: theme.sizes.s48,
                                  height: theme.sizes.s48,
                                  decoration: BoxDecoration(
                                    color: theme.colors.white8,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: LabIcon.s20(
                                      theme.icons.characters.plus,
                                      outlineThickness:
                                          LabLineThicknessData.normal().thick,
                                      outlineColor: theme.colors.white33,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
