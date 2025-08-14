import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/history.dart';
import 'tabs/home/home.dart';
import 'tabs/home/albums.dart';
import 'tabs/home/notes.dart';
import 'tabs/home/mail.dart';
import 'tabs/home/tasks.dart';
import 'tabs/home/files.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? tab;
  const HomePage({super.key, this.tab});

  static final GlobalKey<_HomePageState> _homeKey = GlobalKey<_HomePageState>();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final LabTabController _tabController;
  double _topContainerHeight = 1.0;

  static const double _heightWithProfile = 72.0;
  static const double _heightWithoutProfile = 62.0;

  // Cache expensive calculations to avoid recalculation on every scroll
  late final double _scrollMultiplier = 2.0 / _heightWithProfile;

  // Cache tab data to prevent recreation on every build
  List<TabData>? _cachedTabs;

  // Cache container height to avoid recalculation
  double? _cachedContainerHeight;
  String? _lastActivePubkey;

  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 12);
    _tabController.addListener(() {
      // Only call setState if we actually need to rebuild
      if (mounted) {
        setState(() {});
      }
    });

    // Initialize cached tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _cachedTabs = [
            HomeTab.tabData(context),
            const MailTab().tabData(context),
            const TasksTab().tabData(context),
            const NotesTab().tabData(context),
            const AlbumsTab().tabData(context),
            const FilesTab().tabData(context),
          ];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Home page content
  @override
  Widget build(BuildContext context) {
    // Cache theme access to avoid multiple LabTheme.of(context) calls
    final theme = LabTheme.of(context);
    final activePubkey = ref.watch(Signer.activePubkeyProvider);
    final activeProfile = ref.watch(Signer.activeProfileProvider(
        LocalSource())); // Use LocalSource for better performance

    // Cache container height calculation
    if (_cachedContainerHeight == null || _lastActivePubkey != activePubkey) {
      _cachedContainerHeight =
          activePubkey == null ? _heightWithoutProfile : _heightWithProfile;
      _lastActivePubkey = activePubkey;
    }
    final containerHeight = _cachedContainerHeight!;

    return Stack(
      children: [
        LabScaffold(
          body: LabContainer(
            child: Column(
              children: <Widget>[
                const LabTopSafeArea(),
                RepaintBoundary(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: containerHeight * _topContainerHeight,
                    child: Opacity(
                      opacity: _topContainerHeight,
                      child: LabContainer(
                        height: containerHeight,
                        padding: const LabEdgeInsets.all(LabGapSize.s12),
                        child: activePubkey == null
                            ? _buildStartRow(theme)
                            : _buildProfileRow(
                                theme, activeProfile, activePubkey!),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RepaintBoundary(
                    child: LabTabView(
                      key: HomePage._homeKey,
                      tabs: _cachedTabs ??
                          [
                            HomeTab.tabData(context),
                            const MailTab().tabData(context),
                            const TasksTab().tabData(context),
                            const NotesTab().tabData(context),
                            const AlbumsTab().tabData(context),
                            const FilesTab().tabData(context),
                          ],
                      controller: _tabController,
                      scrollableContent: true,
                      onScroll: (position) {
                        // Only update if change is significant to prevent excessive rebuilds
                        final newHeight = (1.0 - (position * _scrollMultiplier))
                            .clamp(0.0, 1.0);
                        if ((newHeight - _topContainerHeight).abs() > 0.01) {
                          setState(() {
                            _topContainerHeight = newHeight;
                          });
                        }
                      },
                      scrollOffsetHeight: containerHeight / 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods to reduce build complexity
  Widget _buildStartRow(LabThemeData theme) {
    return Row(
      children: [
        Image.asset(
          'assets/images/Zapchat-Blurple-Transparent.png',
          width: theme.sizes.s32,
          height: theme.sizes.s32,
        ),
        const LabGap.s8(),
        LabText.h1('Zapchat'),
        const Spacer(),
        LabButton(
          onTap: () => context.push('/start'),
          children: [
            LabIcon.s12(
              theme.icons.characters.play,
              color: theme.colors.whiteEnforced,
            ),
            const LabGap.s12(),
            LabText.med14('Start', color: theme.colors.whiteEnforced),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileRow(
      LabThemeData theme, Profile? activeProfile, String activePubkey) {
    return Row(
      children: [
        if (LabPlatformUtils.isMobile)
          activeProfile != null
              ? LabProfilePic.s48(
                  activeProfile,
                  onTap: () => context.push('/settings'),
                )
              : LabProfilePic.fromPubkey(
                  activePubkey,
                  onTap: () => context.push('/settings'),
                  size: LabProfilePicSize.s48,
                ),
        if (LabPlatformUtils.isMobile) const LabGap.s12(),
        Expanded(
          child: LabContainer(
            height: theme.sizes.s48,
            padding: const LabEdgeInsets.symmetric(horizontal: LabGapSize.s12),
            decoration: BoxDecoration(
              color: theme.colors.gray33,
              borderRadius: BorderRadius.circular(theme.sizes.s24),
              border: Border.all(
                color: theme.colors.gray,
                width: LabLineThicknessData.normal().medium,
              ),
            ),
            child: Row(
              children: [
                LabIcon.s16(
                  theme.icons.characters.zap,
                  gradient: theme.colors.blurple,
                ),
                const LabGap.s4(),
                LabAmount(124608,
                    color: theme.colors.white, level: LabTextLevel.h2),
              ],
            ),
          ),
        )
      ],
    );
  }
}
