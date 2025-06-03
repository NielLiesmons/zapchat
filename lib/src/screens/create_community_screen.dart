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

  @override
  void dispose() {
    _communityNameController.removeListener(_updateHasText);
    _communityNameController.dispose();
    _communityNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final signedInPubkeys = ref.watch(Signer.signedInPubkeysProvider);
    final state = ref.watch(query<Profile>(authors: signedInPubkeys));

    if (state case StorageLoading()) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    final profiles = state.models.cast<Profile>();

    return AppScreen(
        onHomeTap: () => Navigator.of(context).pop(),
        alwaysShowTopBar: true,
        topBarContent: AppContainer(
          padding: const AppEdgeInsets.symmetric(
            vertical: AppGapSize.s4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppGap.s8(),
                  AppText.med14('New Community'),
                  const AppGap.s12(),
                  const Spacer(),
                  AppSmallButton(
                    onTap: _hasText
                        ? () {
                            context.push(
                                '/create/community/spin-up-community-key',
                                extra: _communityNameController.text);
                          }
                        : null,
                    rounded: true,
                    inactiveGradient: _hasText
                        ? theme.colors.blurple
                        : theme.colors.blurple33,
                    children: [
                      const AppGap.s4(),
                      AppText.med14(
                        'Next',
                        color: _hasText
                            ? theme.colors.white
                            : theme.colors.white66,
                      ),
                      const AppGap.s4(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        child: AppContainer(
          padding: const AppEdgeInsets.symmetric(
            horizontal: AppGapSize.s12,
          ),
          child: Column(
            children: [
              const AppGap.s64(),
              AppPanel(
                padding: const AppEdgeInsets.all(AppGapSize.s12),
                child: Column(
                  children: [
                    AppText.h2('Create a Community Profile',
                        color: theme.colors.white66,
                        textAlign: TextAlign.center),
                    const AppGap.s16(),
                    AppInputTextField(
                      title: 'Choose a Community Name',
                      controller: _communityNameController,
                      focusNode: _communityNameFocusNode,
                      placeholder: 'Community name',
                    ),
                  ],
                ),
              ),
              const AppGap.s12(),
              Row(
                children: [
                  const Expanded(child: AppDivider()),
                  const AppGap.s12(),
                  AppText.h3('OR', color: theme.colors.white66),
                  const AppGap.s12(),
                  const Expanded(child: AppDivider()),
                ],
              ),
              const AppGap.s12(),
              AppPanel(
                padding: const AppEdgeInsets.all(AppGapSize.s12),
                child: Column(
                  children: [
                    AppText.h2('Use an existing Profile',
                        color: theme.colors.white66,
                        textAlign: TextAlign.center),
                    const AppGap.s4(),
                    AppText.reg14(
                        'Select or Add a Profile that you want \nto turn into a Community',
                        textAlign: TextAlign.center),
                    const AppGap.s12(),
                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...profiles
                              .map(
                                (profile) => [
                                  AppProfilePic.s48(profile),
                                  const AppGap.s12(),
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
                                child: AppContainer(
                                  width: theme.sizes.s48,
                                  height: theme.sizes.s48,
                                  decoration: BoxDecoration(
                                    color: theme.colors.white8,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: AppIcon.s20(
                                      theme.icons.characters.plus,
                                      outlineThickness:
                                          AppLineThicknessData.normal().thick,
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
        ));
  }
}
