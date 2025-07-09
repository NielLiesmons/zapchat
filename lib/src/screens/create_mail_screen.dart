import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tap_builder/tap_builder.dart';

class CreateMailScreen extends ConsumerStatefulWidget {
  const CreateMailScreen({
    super.key,
  });

  @override
  ConsumerState<CreateMailScreen> createState() => _CreateMailScreenState();
}

class _CreateMailScreenState extends ConsumerState<CreateMailScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  final List<Profile> _selectedProfiles = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Request focus after screen is built
    Future.microtask(() => _searchFocusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleProfileSelection(Profile profile) {
    setState(() {
      if (_selectedProfiles.contains(profile)) {
        _selectedProfiles.remove(profile);
      } else {
        _selectedProfiles.add(profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    final state = ref.watch(query<Profile>());
    final profiles = state.models.cast<Profile>().toList();

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
                LabText.med14('New Mail'),
                const LabGap.s12(),
                const Spacer(),
                LabSmallButton(
                  onTap: () {},
                  rounded: true,
                  children: [
                    const LabGap.s4(),
                    if (_selectedProfiles.isEmpty)
                      LabText.med14('Skip')
                    else
                      LabText.med14('Next'),
                    const LabGap.s4(),
                  ],
                ),
              ],
            ),
            const LabGap.s12(),
            LabSearchField(
              placeholderWidget: [
                LabText.reg16('Search Recipients', color: theme.colors.white33),
              ],
              controller: _searchController,
              focusNode: _searchFocusNode,
            ),
            if (_selectedProfiles.isNotEmpty) ...[
              const LabGap.s12(),
              LabContainer(
                padding: const LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s6,
                ),
                clipBehavior: Clip.none,
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _selectedProfiles
                        .map(
                          (profile) => Row(
                            children: [
                              LabSmallButton(
                                padding: const LabEdgeInsets.symmetric(
                                  horizontal: LabGapSize.s6,
                                ),
                                color: theme.colors.white8,
                                onTap: () => _toggleProfileSelection(profile),
                                children: [
                                  LabProfilePic.s18(profile),
                                  const LabGap.s6(),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 56,
                                    ),
                                    child: LabText.med12(
                                      profile.name ?? formatNpub(profile.npub),
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const LabGap.s4(),
                                  LabCrossButton.s20(
                                    onTap: () =>
                                        _toggleProfileSelection(profile),
                                  ),
                                ],
                              ),
                              const LabGap.s8(),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 118),
          if (_selectedProfiles.isNotEmpty) ...[
            const SizedBox(height: 44),
          ],
          for (final profile in profiles)
            TapBuilder(
              onTap: () => _toggleProfileSelection(profile),
              builder: (context, state, hasFocus) => LabContainer(
                padding: const LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s16,
                  vertical: LabGapSize.s8,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        LabProfilePic.s56(profile),
                        const LabGap.s12(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabText.med16(profile.author.value?.name ?? ''),
                            const LabGap.s4(),
                            LabNpubDisplay(profile: profile, copyable: false),
                          ],
                        ),
                        const Spacer(),
                        LabCheckBox(
                          value: _selectedProfiles.contains(profile),
                          onChanged: (value) =>
                              _toggleProfileSelection(profile),
                        ),
                        const LabGap.s12(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
