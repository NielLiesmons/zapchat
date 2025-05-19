import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tap_builder/tap_builder.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({
    super.key,
  });

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
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
    final theme = AppTheme.of(context);

    final state = ref.watch(query<Profile>());
    final profiles = state.models.cast<Profile>().toList();

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
                AppText.med14('New Private Group'),
                const AppGap.s12(),
                const Spacer(),
                AppSmallButton(
                  onTap: () {},
                  rounded: true,
                  children: [
                    const AppGap.s4(),
                    if (_selectedProfiles.isEmpty)
                      AppText.med14('Skip')
                    else
                      AppText.med14('Next'),
                    const AppGap.s4(),
                  ],
                ),
              ],
            ),
            const AppGap.s12(),
            AppSearchField(
              placeholderWidget: [
                AppText.reg16('Search Members', color: theme.colors.white33),
              ],
              controller: _searchController,
              focusNode: _searchFocusNode,
            ),
            if (_selectedProfiles.isNotEmpty) ...[
              const AppGap.s12(),
              AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s6,
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
                              AppSmallButton(
                                padding: const AppEdgeInsets.symmetric(
                                  horizontal: AppGapSize.s6,
                                ),
                                inactiveColor: theme.colors.white8,
                                onTap: () => _toggleProfileSelection(profile),
                                children: [
                                  AppProfilePic.s18(profile),
                                  const AppGap.s6(),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 56,
                                    ),
                                    child: AppText.med12(
                                      profile.name ?? formatNpub(profile.npub),
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const AppGap.s4(),
                                  AppCrossButton.s20(
                                    onTap: () =>
                                        _toggleProfileSelection(profile),
                                  ),
                                ],
                              ),
                              const AppGap.s8(),
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
              builder: (context, state, hasFocus) => AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s8,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppProfilePic.s56(profile),
                        const AppGap.s12(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.med16(profile.author.value?.name ?? ''),
                            const AppGap.s4(),
                            AppNpubDisplay(profile: profile, copyable: false),
                          ],
                        ),
                        const Spacer(),
                        AppCheckBox(
                          value: _selectedProfiles.contains(profile),
                          onChanged: (value) =>
                              _toggleProfileSelection(profile),
                        ),
                        const AppGap.s12(),
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
