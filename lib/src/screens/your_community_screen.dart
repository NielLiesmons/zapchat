import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';
import 'dart:convert';

class YourCommunityScreen extends StatefulWidget {
  final Profile profile;
  final String communityName;

  const YourCommunityScreen({
    super.key,
    required this.profile,
    required this.communityName,
  });

  @override
  State<YourCommunityScreen> createState() => _YourCommunityScreenState();
}

class _YourCommunityScreenState extends State<YourCommunityScreen> {
  late PartialCommunity _community;
  late PartialProfile _profile;
  late Set<CommunityContentSection> _contentSections;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Profile get _displayProfile {
    // Create a new Profile from the PartialProfile for display
    return Profile.fromMap({
      'event': {
        'kind': 0,
        'content': jsonEncode({
          'name': _profile.name,
          'about': _profile.about,
          'picture': _profile.pictureUrl,
          'banner': _profile.banner,
        }),
        'pubkey': widget.profile.event.pubkey,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'tags': [],
        'id': '',
        'sig': '',
      }
    }, widget.profile.ref);
  }

  @override
  void initState() {
    super.initState();
    _contentSections = {
      CommunityContentSection(content: 'Chat', kinds: {1}, feeInSats: 0),
      CommunityContentSection(content: 'Forum', kinds: {2}, feeInSats: 0),
      CommunityContentSection(content: 'Articles', kinds: {3}, feeInSats: 0),
      CommunityContentSection(content: 'Labels', kinds: {4}, feeInSats: 0),
    };
    _community = PartialCommunity(
      name: widget.communityName,
      relayUrls: {},
      contentSections: _contentSections,
    );
    _profile = PartialProfile(
      name: widget.profile.name,
      about: widget.profile.about,
      pictureUrl: widget.profile.pictureUrl,
      banner: widget.profile.banner,
    );
    _nameController.text = _profile.name ?? '';
    _descriptionController.text = _profile.about ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showNameInputModal() async {
    _nameController.text = _profile.name ?? '';

    await AppInputTextModal.show(
      context,
      controller: _nameController,
      placeholder: 'Community Name',
      singleLine: true,
      onDone: (text) {
        setState(() {
          _profile = PartialProfile(
            name: text,
            about: _profile.about,
            pictureUrl: _profile.pictureUrl,
            banner: _profile.banner,
          );
          _community = PartialCommunity(
            name: text,
            relayUrls: _community.relayUrls,
            contentSections: _contentSections,
          );
        });
      },
    );
  }

  Future<void> _showDescriptionInputModal() async {
    final currentText = _profile.about ?? '';
    _descriptionController.text = currentText;

    await AppInputTextModal.show(
      context,
      controller: _descriptionController,
      placeholder: 'Community Description',
      size: AppInputTextFieldSize.medium,
      onDone: (text) {
        setState(() {
          _profile = PartialProfile(
            name: _profile.name,
            about: text,
            pictureUrl: _profile.pictureUrl,
            banner: _profile.banner,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

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
                AppText.med14('Your Community'),
                const AppGap.s12(),
                const Spacer(),
                AppSmallButton(
                  onTap: () {},
                  rounded: true,
                  inactiveGradient: theme.colors.blurple33,
                  children: [
                    const AppGap.s4(),
                    AppText.med14('Publish', color: theme.colors.white66),
                    const AppGap.s4(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          const AppGap.s48(),
          const AppGap.s2(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "Profile",
                ),
                AppPanel(
                  padding: const AppEdgeInsets.all(AppGapSize.none),
                  color: theme.colors.gray66,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 1.2,
                            child: AppContainer(
                              decoration: BoxDecoration(
                                color: Color(
                                        hexToColor(widget.profile.event.pubkey)
                                            .toIntWithAlpha())
                                    .withValues(alpha: 0.16),
                              ),
                              child: _profile.banner != null &&
                                      _profile.banner!.isNotEmpty
                                  ? Image.network(
                                      _profile.banner!,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          Center(
                            child: TapBuilder(
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
                                  child: AppIcon.s32(
                                    theme.icons.characters.camera,
                                    color: theme.colors.white33,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Profile section
                      AppContainer(
                        padding: const AppEdgeInsets.only(
                          left: AppGapSize.s12,
                          right: AppGapSize.s12,
                          top: AppGapSize.s12,
                          bottom: AppGapSize.s10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AppContainer(
                                  height: 40,
                                ),
                                Positioned(
                                  top: -40,
                                  child: AppProfilePic.fromNameAndPubkey(
                                    _profile.name,
                                    widget.profile.event.pubkey,
                                    size: AppProfilePicSize.s80,
                                  ),
                                ),
                              ],
                            ),
                            const AppGap.s56(),
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
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(theme.sizes.s38),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 8, sigmaY: 8),
                                      child: AppContainer(
                                        width: theme.sizes.s38,
                                        height: theme.sizes.s38,
                                        decoration: BoxDecoration(
                                          color: theme.colors.white16,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: AppIcon.s16(
                                            theme.icons.characters.camera,
                                            color: theme.colors.white66,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const AppGap.s12(),
                            Expanded(
                              child: AppInputButton(
                                onTap: _showNameInputModal,
                                color: theme.colors.black8,
                                children: [
                                  AppText.med14(
                                    _profile.name ?? '',
                                    color: theme.colors.white,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  const AppGap.s8(),
                                  AppIcon.s12(
                                    theme.icons.characters.pen,
                                    color: theme.colors.white33,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppContainer(
                        padding: const AppEdgeInsets.only(
                          left: AppGapSize.s12,
                          right: AppGapSize.s12,
                          top: AppGapSize.s4,
                          bottom: AppGapSize.s12,
                        ),
                        child: AppInputButton(
                          onTap: _showDescriptionInputModal,
                          color: theme.colors.black8,
                          topAlignment: true,
                          height: theme.sizes.s64,
                          children: [
                            _profile.about != null && _profile.about!.isNotEmpty
                                ? AppText.reg14(
                                    _profile.about!,
                                    color: theme.colors.white,
                                  )
                                : AppText.reg14(
                                    'Community Description',
                                    color: theme.colors.white33,
                                  ),
                            const Spacer(),
                            AppIcon.s12(
                              theme.icons.characters.pen,
                              color: theme.colors.white33,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const AppGap.s12(),
                AppButton(
                  onTap: () {},
                  inactiveColor: theme.colors.gray33,
                  children: [
                    AppIcon.s18(
                      theme.icons.characters.pin,
                      outlineColor: theme.colors.white33,
                      outlineThickness: AppLineThicknessData.normal().medium,
                    ),
                    const AppGap.s12(),
                    AppText.reg14(
                      "Add Pinned Publications",
                      color: theme.colors.white33,
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "Pricing",
                ),
                AppPanelButton(
                  onTap: () {},
                  height: 160,
                  padding: const AppEdgeInsets.all(AppGapSize.none),
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.colors.white.withValues(alpha: 1),
                              theme.colors.white.withValues(alpha: 0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (final section in _contentSections) ...[
                                AppContainer(
                                  padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s12,
                                      vertical: AppGapSize.s8),
                                  child: Row(
                                    children: [
                                      AppEmojiContentType(
                                        contentType: section.content
                                            .toLowerCase()
                                            .replaceAll(RegExp(r's$'), ''),
                                        size: 18,
                                      ),
                                      const AppGap.s10(),
                                      AppText.reg14(
                                        section.content,
                                        color: theme.colors.white66,
                                      ),
                                      const Spacer(),
                                      AppText.med12(
                                        section.feeInSats != null &&
                                                section.feeInSats! > 0
                                            ? '${section.feeInSats}'
                                            : 'Free',
                                      ),
                                    ],
                                  ),
                                ),
                                const AppDivider(),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: ClipRRect(
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: AppButton(
                              onTap: () {},
                              inactiveColor: theme.colors.white8,
                              children: [
                                AppText.reg14(
                                  'Prices & Content Types',
                                  color: theme.colors.white66,
                                ),
                                const AppGap.s12(),
                                AppIcon.s14(
                                  theme.icons.characters.pen,
                                  color: theme.colors.white66,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "Guidelines",
                ),
                AppPanelButton(
                  onTap: () {},
                  height: 160,
                  padding: const AppEdgeInsets.all(AppGapSize.none),
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.colors.white.withValues(alpha: 1),
                              theme.colors.white.withValues(alpha: 0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              for (int i = 0; i < 3; i++) ...[
                                AppContainer(
                                  padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s12,
                                      vertical: AppGapSize.s8),
                                  child: Row(
                                    children: [
                                      AppText.reg16(
                                        '${i + 1}',
                                        color: theme.colors.blurpleColor66,
                                      ),
                                      const AppGap.s10(),
                                      AppText.reg14(
                                        "Title of Guideline ${i + 1}",
                                        color: theme.colors.white66,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const AppDivider(),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: ClipRRect(
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: AppButton(
                              onTap: () {},
                              inactiveColor: theme.colors.white8,
                              children: [
                                AppText.reg14(
                                  'Guidelines',
                                  color: theme.colors.white66,
                                ),
                                const AppGap.s12(),
                                AppIcon.s14(
                                  theme.icons.characters.pen,
                                  color: theme.colors.white66,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "Hosting",
                ),
                AppPanelButton(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppHostingIcon(
                              hostingStatuses: [
                                HostingStatus.none,
                                HostingStatus.none,
                                HostingStatus.none,
                              ],
                            ),
                            const AppGap.s16(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.h2(
                                  "No Hosting yet",
                                  color: theme.colors.white33,
                                ),
                                const AppGap.s8(),
                                AppContainer(
                                  padding: const AppEdgeInsets.symmetric(
                                    horizontal: AppGapSize.s8,
                                    vertical: AppGapSize.s2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: theme.colors.rouge33,
                                    borderRadius:
                                        theme.radius.asBorderRadius().rad8,
                                  ),
                                  child: AppText.reg12("Required",
                                      color: theme.colors.white66),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const AppGap.s16(),
                        AppButton(
                          onTap: () {},
                          children: [
                            AppIcon.s14(
                              theme.icons.characters.plus,
                              outlineColor: theme.colors.whiteEnforced,
                              outlineThickness:
                                  AppLineThicknessData.normal().thick,
                            ),
                            const AppGap.s12(),
                            AppText.reg14("Add Hosting",
                                color: theme.colors.whiteEnforced),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.all(
              AppGapSize.s12,
            ),
            child: Column(
              children: [
                AppSectionTitle(
                  "MORE",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
