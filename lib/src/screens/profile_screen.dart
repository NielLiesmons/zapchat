import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
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
  late LabTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 9);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.profile);

    // Get data
    final resolvers = ref.read(resolversProvider);

    return LabScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      noTopGap: true,
      topBarContent: Row(
        children: [
          LabProfilePic.s38(widget.profile),
          const LabGap.s10(),
          LabText.reg14(widget.profile.name ?? formatNpub(widget.profile.npub)),
        ],
      ),
      bottomBarContent: LabBottomBarProfile(
        onAddLabelTap: (model) {},
        onMailTap: (model) {},
        onVoiceTap: (model) {},
        onActions: (model) {},
        profile: widget.profile,
      ),
      child: Column(
        children: [
          LabProfileHeader(profile: widget.profile),
          LabTabView(
            tabs: [
              TabData(
                label: 'Communities',
                icon: LabEmojiContentType(contentType: 'community'),
                content: ProfileCommunitiesFeed(
                  profile: widget.profile,
                ),
              ),
              TabData(
                label: 'Threads',
                icon: LabEmojiContentType(contentType: 'thread'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Books',
                icon: LabEmojiContentType(contentType: 'book'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Events',
                icon: LabEmojiContentType(contentType: 'event'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Wikis',
                icon: LabEmojiContentType(contentType: 'wiki'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Articles',
                icon: LabEmojiContentType(contentType: 'article'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Polls',
                icon: LabEmojiContentType(contentType: 'poll'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Videos',
                icon: LabEmojiContentType(contentType: 'video'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Wikis',
                icon: LabEmojiContentType(contentType: 'wiki'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Albums',
                icon: LabEmojiContentType(contentType: 'album'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Docs',
                icon: LabEmojiContentType(contentType: 'doc'),
                content: const SizedBox(),
              ),
              TabData(
                label: 'Repos',
                icon: LabEmojiContentType(contentType: 'repo'),
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
