import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tabs/home/apps.dart';
import 'tabs/home/articles.dart';
import 'tabs/home/books.dart';
import 'tabs/home/home.dart';
import 'tabs/home/albums.dart';
import 'tabs/home/threads.dart';
import 'tabs/home/repos.dart';
import 'tabs/home/videos.dart';
import 'tabs/home/wikis.dart';
import 'tabs/home/mail.dart';
import 'tabs/home/tasks.dart';
import 'tabs/home/jobs.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final AppTabController _tabController;
  double _topContainerHeight = 1.0;

  static const double _heightWithProfile = 72.0;
  static const double _heightWithoutProfile = 62.0;

  // Tab controller to switch bottom bar based on the tab that is selected.
  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(length: 12);
    _tabController.addListener(() {
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
    final theme = AppTheme.of(context);
    final activeProfile = ref.watch(Signer.activeProfileProvider);
    final containerHeight =
        activeProfile == null ? _heightWithoutProfile : _heightWithProfile;

    return Stack(
      children: [
        AppScaffold(
          body: AppContainer(
            child: Column(
              children: <Widget>[
                const AppTopSafeArea(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: containerHeight * _topContainerHeight,
                  child: Opacity(
                    opacity: _topContainerHeight,
                    child: AppContainer(
                      height: containerHeight,
                      padding: const AppEdgeInsets.all(AppGapSize.s12),
                      child: activeProfile == null
                          ? Row(
                              children: [
                                Image.asset(
                                  'assets/images/Zapchat-Blurple-Transparent.png',
                                  width: theme.sizes.s32,
                                  height: theme.sizes.s32,
                                ),
                                const AppGap.s8(),
                                AppText.h1('Zapchat'),
                                const Spacer(),
                                AppButton(
                                  onTap: () => context.push('/start'),
                                  children: [
                                    AppIcon.s12(
                                      theme.icons.characters.play,
                                      color: theme.colors.whiteEnforced,
                                    ),
                                    const AppGap.s12(),
                                    AppText.med14('Start'),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                if (AppPlatformUtils.isMobile)
                                  AppProfilePic.s48(
                                    activeProfile,
                                    onTap: () => context.push('/settings'),
                                  ),
                                if (AppPlatformUtils.isMobile)
                                  const AppGap.s12(),
                                Expanded(
                                  child: AppContainer(
                                    height: theme.sizes.s48,
                                    padding: const AppEdgeInsets.symmetric(
                                        horizontal: AppGapSize.s12),
                                    decoration: BoxDecoration(
                                      color: theme.colors.gray33,
                                      borderRadius: BorderRadius.circular(
                                          theme.sizes.s24),
                                      border: Border.all(
                                        color: theme.colors.gray,
                                        width: AppLineThicknessData.normal()
                                            .medium,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        AppIcon.s16(
                                          theme.icons.characters.zap,
                                          gradient: theme.colors.blurple,
                                        ),
                                        const AppGap.s4(),
                                        AppAmount(124608,
                                            color: theme.colors.white,
                                            level: AppTextLevel.h2),
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
                  child: AppTabView(
                    tabs: [
                      const HomeTab().tabData(context),
                      const MailTab().tabData(context),
                      const TasksTab().tabData(context),
                      const JobsTab().tabData(context),
                      const ReposTab().tabData(context),
                      const AppsTab().tabData(context),
                      const WikisTab().tabData(context),
                      const BooksTab().tabData(context),
                      const ArticlesTab().tabData(context),
                      const ThreadsTab().tabData(context),
                      const ImagesTab().tabData(context),
                      const VideosTab().tabData(context),
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
