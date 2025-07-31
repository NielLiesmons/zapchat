import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // Tab controller to switch bottom bar based on the tab that is selected.
  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 12);
    _tabController.addListener(() {
      print('Tab changed to: ${_tabController.index}');
      setState(() {});
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
    final theme = LabTheme.of(context);
    final activePubkey = ref.watch(Signer.activePubkeyProvider);
    final activeProfile =
        ref.watch(Signer.activeProfileProvider(LocalAndRemoteSource()));
    final containerHeight =
        activePubkey == null ? _heightWithoutProfile : _heightWithProfile;

    return Stack(
      children: [
        LabScaffold(
          body: LabContainer(
            child: Column(
              children: <Widget>[
                const LabTopSafeArea(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: containerHeight * _topContainerHeight,
                  child: Opacity(
                    opacity: _topContainerHeight,
                    child: LabContainer(
                      height: containerHeight,
                      padding: const LabEdgeInsets.all(LabGapSize.s12),
                      child: activePubkey == null
                          ? Row(
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
                                    LabText.med14('Start',
                                        color: theme.colors.whiteEnforced),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                if (LabPlatformUtils.isMobile)
                                  activeProfile != null
                                      ? LabProfilePic.s48(
                                          activeProfile,
                                          onTap: () =>
                                              context.push('/settings'),
                                        )
                                      : LabProfilePic.fromPubkey(
                                          activePubkey!,
                                          onTap: () =>
                                              context.push('/settings'),
                                          size: LabProfilePicSize.s48,
                                        ),
                                if (LabPlatformUtils.isMobile)
                                  const LabGap.s12(),
                                Expanded(
                                  child: LabContainer(
                                    height: theme.sizes.s48,
                                    padding: const LabEdgeInsets.symmetric(
                                        horizontal: LabGapSize.s12),
                                    decoration: BoxDecoration(
                                      color: theme.colors.gray33,
                                      borderRadius: BorderRadius.circular(
                                          theme.sizes.s24),
                                      border: Border.all(
                                        color: theme.colors.gray,
                                        width: LabLineThicknessData.normal()
                                            .medium,
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
                                            color: theme.colors.white,
                                            level: LabTextLevel.h2),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: LabTabView(
                    key: HomePage._homeKey,
                    tabs: [
                      const HomeTab().tabData(context),
                      const MailTab().tabData(context),
                      const TasksTab().tabData(context),
                      const NotesTab().tabData(context),
                      const AlbumsTab().tabData(context),
                      const FilesTab().tabData(context),
                    ],
                    controller: _tabController,
                    scrollableContent: true,
                    onScroll: (position) {
                      setState(() {
                        _topContainerHeight =
                            (1.0 - ((position * 2) / containerHeight))
                                .clamp(0.0, 1.0);
                      });
                    },
                    scrollOffsetHeight: containerHeight / 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
