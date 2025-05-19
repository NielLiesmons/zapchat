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
    final signedInProfile = ref.watch(Profile.signedInProfileProvider);

    if (signedInProfile == null) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    return Stack(
      children: [
        AppScaffold(
          body: SingleChildScrollView(
            child: AppContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const AppTopSafeArea(),
                  const AppGap.s12(),
                  AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                        horizontal: AppGapSize.s12),
                    child: Row(
                      children: [
                        if (AppPlatformUtils.isMobile)
                          AppProfilePic.s48(
                            signedInProfile,
                            onTap: () => context.push('/settings'),
                          ),
                        if (AppPlatformUtils.isMobile) const AppGap.s12(),
                        Expanded(
                          child: AppContainer(
                            height: theme.sizes.s48,
                            padding: const AppEdgeInsets.symmetric(
                                horizontal: AppGapSize.s12),
                            decoration: BoxDecoration(
                              color: theme.colors.gray33,
                              borderRadius:
                                  BorderRadius.circular(theme.sizes.s24),
                              border: Border.all(
                                color: theme.colors.gray,
                                width: AppLineThicknessData.normal().medium,
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
                  const AppGap.s16(),
                  AppTabView(
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
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomBar(),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    switch (_tabController.index) {
      case 0: // Home tab
        return AppPlatformUtils.isMobile
            ? AppBottomBarHome(
                onAddTap: () => context.push('/create'),
              )
            : const SizedBox.shrink();
      // TODO: Match bottom bar with according tab
      default:
        return AppBottomBarContentFeed();
    }
  }
}
