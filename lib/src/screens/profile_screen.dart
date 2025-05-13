import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../feeds/profile_communities_feed.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final Profile profile;

  const ProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AppTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(length: 9);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Community>());
    final communities = state.models.cast<Community>().toList();

    return AppScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      noTopGap: true,
      topBarContent: Row(
        children: [
          AppProfilePic.s38(widget.profile),
          const AppGap.s10(),
          AppText.reg14(widget.profile.name ?? formatNpub(widget.profile.npub)),
        ],
      ),
      bottomBarContent: AppBottomBarProfile(
        onAddLabelTap: (model) {},
        onMessageTap: (model) {},
        onVoiceTap: (model) {},
        onActions: (model) {},
        profile: widget.profile,
        draftMessage: null,
        onResolveEvent: resolvers.eventResolver,
        onResolveProfile: resolvers.profileResolver,
        onResolveEmoji: resolvers.emojiResolver,
      ),
      child: Column(
        children: [
          AppProfileHeader(profile: widget.profile),
          AppTabView(
            tabs: [
              TabData(
                label: 'Communities',
                icon: AppEmojiContentType(contentType: 'community'),
                content: ProfileCommunitiesFeed(
                  profile: widget.profile,
                ),
              ),
              TabData(
                label: 'Books',
                icon: AppEmojiContentType(contentType: 'book'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Threads',
                icon: AppEmojiContentType(contentType: 'thread'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Articles',
                icon: AppEmojiContentType(contentType: 'article'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Polls',
                icon: AppEmojiContentType(contentType: 'poll'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Wikis',
                icon: AppEmojiContentType(contentType: 'wiki'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Videos',
                icon: AppEmojiContentType(contentType: 'video'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Images',
                icon: AppEmojiContentType(contentType: 'image'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Repos',
                icon: AppEmojiContentType(contentType: 'repo'),
                content: const SizedBox(),
              ),
            ],
            controller: _tabController,
          ),
        ],
      ),
    );
  }
}
