import 'package:models/models.dart';
import 'package:zapchat/src/providers/signed_in_profile.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

import 'tabs/apps.dart';
import 'tabs/articles.dart';
import 'tabs/books.dart';
import 'tabs/chat.dart';
import 'tabs/images.dart';
import 'tabs/posts.dart';
import 'tabs/repos.dart';
import 'tabs/videos.dart';
import 'tabs/wikis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _tabController = AppTabController(length: 9);
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

    final currentProfile = ref.watch(signedInProfile);

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
                        if (currentProfile != null)
                          AppProfilePic.s48(
                            currentProfile.pictureUrl ?? '',
                            onTap: () => context.push('/settings'),
                          ),
                        const AppGap.s12(),
                        Expanded(
                          child: AppContainer(
                            height: theme.sizes.s48,
                            padding: const AppEdgeInsets.symmetric(
                                horizontal: AppGapSize.s12),
                            decoration: BoxDecoration(
                              color: theme.colors.grey33,
                              borderRadius:
                                  BorderRadius.circular(theme.sizes.s24),
                              border: Border.all(
                                color: theme.colors.grey,
                                width: LineThicknessData.normal().medium,
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
                      const ChatTab().tabData(context, ref),
                      const PostsTab().tabData(context),
                      const AppsTab().tabData(context),
                      const WikisTab().tabData(context),
                      const ArticlesTab().tabData(context),
                      const BooksTab().tabData(context),
                      const ImagesTab().tabData(context),
                      const ReposTab().tabData(context),
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
      case 0: // Chat tab
        return AppBottomBarHome();
      case 1: // Posts tab
        return AppBottomBarContentFeed();
      default:
        return const SizedBox.shrink();
    }
  }
}
