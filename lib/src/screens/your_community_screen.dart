import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

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

    await LabInputTextModal.show(
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

    await LabInputTextModal.show(
      context,
      controller: _descriptionController,
      placeholder: 'Community Description',
      size: LabInputTextFieldSize.medium,
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
    final theme = LabTheme.of(context);

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
                LabText.med14('Your Community'),
                const LabGap.s12(),
                const Spacer(),
                LabSmallButton(
                  onTap: () {},
                  rounded: true,
                  gradient: theme.colors.blurple33,
                  children: [
                    const LabGap.s4(),
                    LabText.med14('Publish', color: theme.colors.white66),
                    const LabGap.s4(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          const LabGap.s48(),
          const LabGap.s2(),
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s12,
            ),
            child: Column(
              children: [
                LabSectionTitle(
                  "Profile",
                ),
                LabPanel(
                  padding: const LabEdgeInsets.all(LabGapSize.none),
                  color: theme.colors.gray66,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 1.2,
                            child: LabContainer(
                              decoration: BoxDecoration(
                                color: Color(
                                        hexToColor(widget.profile.event.pubkey)
                                            .toIntWithAlpha())
                                    .withValues(alpha: 0.16),
                              ),
                              child: _profile.banner != null &&
                                      _profile.banner!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: _profile.banner!,
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
                                  child: LabIcon.s32(
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
                      LabContainer(
                        padding: const LabEdgeInsets.only(
                          left: LabGapSize.s12,
                          right: LabGapSize.s12,
                          top: LabGapSize.s12,
                          bottom: LabGapSize.s10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                LabContainer(
                                  height: 40,
                                ),
                                Positioned(
                                  top: -40,
                                  child: LabProfilePic.fromNameAndPubkey(
                                    _profile.name,
                                    widget.profile.event.pubkey,
                                    size: LabProfilePicSize.s80,
                                  ),
                                ),
                              ],
                            ),
                            const LabGap.s56(),
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
                                      child: LabContainer(
                                        width: theme.sizes.s38,
                                        height: theme.sizes.s38,
                                        decoration: BoxDecoration(
                                          color: theme.colors.white16,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: LabIcon.s16(
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
                            const LabGap.s12(),
                            Expanded(
                              child: LabInputButton(
                                onTap: _showNameInputModal,
                                color: theme.colors.black8,
                                children: [
                                  LabText.med14(
                                    _profile.name ?? '',
                                    color: theme.colors.white,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  const LabGap.s8(),
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
                      LabContainer(
                        padding: const LabEdgeInsets.only(
                          left: LabGapSize.s12,
                          right: LabGapSize.s12,
                          top: LabGapSize.s4,
                          bottom: LabGapSize.s12,
                        ),
                        child: LabInputButton(
                          onTap: _showDescriptionInputModal,
                          color: theme.colors.black8,
                          topAlignment: true,
                          minHeight: theme.sizes.s64,
                          children: [
                            _profile.about != null && _profile.about!.isNotEmpty
                                ? LabText.reg14(
                                    _profile.about!,
                                    color: theme.colors.white,
                                  )
                                : LabText.reg14(
                                    'Community Description',
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
                const LabGap.s12(),
                LabButton(
                  onTap: () {},
                  color: theme.colors.gray33,
                  children: [
                    LabIcon.s18(
                      theme.icons.characters.pin,
                      outlineColor: theme.colors.white33,
                      outlineThickness: LabLineThicknessData.normal().medium,
                    ),
                    const LabGap.s12(),
                    LabText.reg14(
                      "Add Pinned Publications",
                      color: theme.colors.white33,
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s12,
            ),
            child: Column(
              children: [
                LabSectionTitle(
                  "Pricing",
                ),
                LabPanelButton(
                  onTap: () {},
                  height: 160,
                  padding: const LabEdgeInsets.all(LabGapSize.none),
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
                                LabContainer(
                                  padding: const LabEdgeInsets.symmetric(
                                      horizontal: LabGapSize.s12,
                                      vertical: LabGapSize.s8),
                                  child: Row(
                                    children: [
                                      LabEmojiContentType(
                                        contentType: section.content
                                            .toLowerCase()
                                            .replaceAll(RegExp(r's$'), ''),
                                        size: 18,
                                      ),
                                      const LabGap.s10(),
                                      LabText.reg14(
                                        section.content,
                                        color: theme.colors.white66,
                                      ),
                                      const Spacer(),
                                      LabText.med12(
                                        section.feeInSats != null &&
                                                section.feeInSats! > 0
                                            ? '${section.feeInSats}'
                                            : 'Free',
                                      ),
                                    ],
                                  ),
                                ),
                                const LabDivider(),
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
                            child: LabButton(
                              onTap: () {},
                              color: theme.colors.white8,
                              children: [
                                LabText.reg14(
                                  'Prices & Content Types',
                                  color: theme.colors.white66,
                                ),
                                const LabGap.s12(),
                                LabIcon.s14(
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
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s12,
            ),
            child: Column(
              children: [
                LabSectionTitle(
                  "Guidelines",
                ),
                LabPanelButton(
                  onTap: () {},
                  height: 160,
                  padding: const LabEdgeInsets.all(LabGapSize.none),
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
                                LabContainer(
                                  padding: const LabEdgeInsets.symmetric(
                                      horizontal: LabGapSize.s12,
                                      vertical: LabGapSize.s8),
                                  child: Row(
                                    children: [
                                      LabText.reg16(
                                        '${i + 1}',
                                        color: theme.colors.blurpleColor66,
                                      ),
                                      const LabGap.s10(),
                                      LabText.reg14(
                                        "Title of Guideline ${i + 1}",
                                        color: theme.colors.white66,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const LabDivider(),
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
                            child: LabButton(
                              onTap: () {},
                              color: theme.colors.white8,
                              children: [
                                LabText.reg14(
                                  'Guidelines',
                                  color: theme.colors.white66,
                                ),
                                const LabGap.s12(),
                                LabIcon.s14(
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
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s12,
            ),
            child: Column(
              children: [
                LabSectionTitle(
                  "Hosting",
                ),
                LabPanelButton(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            LabHostingIcon(
                              hostingStatuses: [
                                HostingStatus.none,
                                HostingStatus.none,
                                HostingStatus.none,
                              ],
                            ),
                            const LabGap.s16(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabText.h2(
                                  "No Hosting yet",
                                  color: theme.colors.white33,
                                ),
                                const LabGap.s8(),
                                LabContainer(
                                  padding: const LabEdgeInsets.symmetric(
                                    horizontal: LabGapSize.s8,
                                    vertical: LabGapSize.s2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: theme.colors.rouge33,
                                    borderRadius:
                                        theme.radius.asBorderRadius().rad8,
                                  ),
                                  child: LabText.reg12("Required",
                                      color: theme.colors.white66),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const LabGap.s16(),
                        LabButton(
                          onTap: () {},
                          children: [
                            LabIcon.s14(
                              theme.icons.characters.plus,
                              outlineColor: theme.colors.whiteEnforced,
                              outlineThickness:
                                  LabLineThicknessData.normal().thick,
                            ),
                            const LabGap.s12(),
                            LabText.reg14("Add Hosting",
                                color: theme.colors.whiteEnforced),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.all(
              LabGapSize.s12,
            ),
            child: Column(
              children: [
                LabSectionTitle(
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
