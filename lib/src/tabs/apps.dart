import 'package:zaplab_design/zaplab_design.dart';

class AppsTab extends StatelessWidget {
  const AppsTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Apps',
      icon: AppIcon.s16(
        theme.icons.characters.zap,
        outlineColor: theme.colors.white66,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      content: Builder(
        builder: (context) {
          return AppContainer(
            padding: const AppEdgeInsets.all(AppGapSize.s12),
            child: Column(
              children: [
                AppAppSmallCard(
                  appName: 'Zapchat',
                  version: '1.21',
                  profilePicUrl:
                      'https://cdn.satellite.earth/c1049a551ab657593f334ff30afe7b8795affc52fe8e96dc08be901c0180d87a.png',
                  onUpdate: () {
                    AppModal.show(
                      context,
                      includePadding: false,
                      children: [
                        AppAppReleaseCard(
                          appName: 'Zapchat',
                          releaseNumber: '1.21',
                          description:
                              'This is a big release! We now display and let zapchatters interact with: App Releases, Emoji Packs, Books and more! As per usual, we appreciate all the zaps, replies, encouragement and feedback we can get! Join our community for hands on support.',
                          profilePicUrl:
                              'https://cdn.satellite.earth/c1049a551ab657593f334ff30afe7b8795affc52fe8e96dc08be901c0180d87a.png',
                          publisherName: 'Zaplab',
                          publisherPicUrl:
                              'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
                          source: 'Repo',
                          size: '32 MB',
                          date: '21/04/25',
                          license: 'Unlicense',
                          onInstall: () {},
                          onViewMore: () {},
                        ),
                        AppInteractionBar(
                          nevent: '1',
                          zaps: [
                            Zap(
                              nevent: '1',
                              amount: 10000,
                              profileName: 'elsat',
                              profilePicUrl:
                                  'https://image.nostr.build/ba781633731cd33bd20f58bbca208ae87db3f87c8f2256e23e4a8df543617c6c.png',
                              timestamp: DateTime.now(),
                            ),
                            Zap(
                              nevent: '1',
                              amount: 560,
                              profileName: 'franzap',
                              profilePicUrl:
                                  'https://primal.b-cdn.net/media-cache?s=o&a=1&u=https%3A%2F%2Fnostr.build%2Fi%2Fnostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
                              timestamp: DateTime.now(),
                            ),
                            Zap(
                              nevent: '1',
                              amount: 123,
                              profileName: 'Niel Liesmons',
                              profilePicUrl:
                                  'https://primal.b-cdn.net/media-cache?s=o&a=1&u=https%3A%2F%2Fcdn.satellite.earth%2F946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                              timestamp: DateTime.now(),
                            ),
                            Zap(
                              nevent: '1',
                              amount: 66,
                              profileName: 'calle',
                              profilePicUrl:
                                  'https://avatars.githubusercontent.com/u/93376500',
                              timestamp: DateTime.now(),
                            ),
                            Zap(
                              nevent: '1',
                              amount: 50,
                              profileName: 'Pip',
                              profilePicUrl:
                                  'https://primal.b-cdn.net/media-cache?s=o&a=1&u=https%3A%2F%2Fm.primal.net%2FIfSZ.jpg',
                              timestamp: DateTime.now(),
                            ),
                          ],
                          reactions: [
                            Reaction(
                              emojiName: 'todo',
                              emojiUrl:
                                  'https://cdn.betterttv.net/emote/55b6f480e66682f576dd94f5/3x.webp',
                              profilePicUrl:
                                  'https://primal.b-cdn.net/media-cache?s=o&a=1&u=https%3A%2F%2Fm.primal.net%2FIfSZ.jpg',
                              profileName: "Pip",
                              timestamp: DateTime.now(),
                            ),
                            Reaction(
                              emojiName: 'todo',
                              emojiUrl:
                                  'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
                              profilePicUrl:
                                  'https://cdn.satellite.earth/3e385cea12375df0dec2119bdd7dded32b1c794392782d58e6d77276ec9382ca.png',
                              profileName: "Niel Liesmons",
                              timestamp: DateTime.now(),
                            ),
                          ],
                        ),
                        AppTabView(
                          tabs: [
                            TabData(
                              label: 'Replies',
                              icon: AppIcon.s20(
                                theme.icons.characters.reply,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LineThicknessData.normal().medium,
                              ),
                              count: 21,
                              content: Column(
                                children: [
                                  AppFeedPost(
                                    nevent: '1',
                                    content:
                                        'Yeah, this is why I\'m not using Nostr so much on mobile. The browser experience is king, for now.',
                                    profileName: 'James Lewis',
                                    profilePicUrl:
                                        'https://i.nostr.build/zdMAY.jpg',
                                    timestamp: DateTime.now(),
                                    onResolveEvent: (identifier) async {
                                      // Simulate network delay
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      return NostrEvent(
                                        nevent: '1',
                                        contentType: 'article',
                                        title: 'Simple Questions',
                                        imageUrl:
                                            'https://cdn.satellite.earth/64b885412eb944828d964c21242f0c7415b1afbf4554eca08f9dd1afba0c7584.png',
                                        profileName: 'Niel Liesmons',
                                        profilePicUrl:
                                            'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                                        timestamp: DateTime.now(),
                                        onTap: () {
                                          print('tapped');
                                        },
                                      );
                                    },
                                    onResolveProfile: (identifier) async {
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      return Profile(
                                        npub: 'npub1337',
                                        profileName: 'Pip',
                                        profilePicUrl:
                                            'https://m.primal.net/IfSZ.jpg',
                                      );
                                    },
                                    onResolveEmoji: (identifier) async {
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
                                    },
                                    onResolveHashtag: (identifier) async {
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      return () {};
                                    },
                                    onLinkTap: (url) {
                                      print(url);
                                    },
                                    onReply: (nevent) {
                                      print(nevent);
                                    },
                                    zaps: [
                                      Zap(
                                        nevent: '1',
                                        amount: 100,
                                        profileName: 'ثعبان',
                                        profilePicUrl:
                                            'https://nostr.download/1aba957814cac9c324c54d94e0ba6606dc50af17f7c08654e9b9f139a9720d6d.jpeg',
                                        timestamp: DateTime.now(),
                                      ),
                                      Zap(
                                        nevent: '1',
                                        amount: 56,
                                        profileName: 'Pip',
                                        profilePicUrl:
                                            'https://m.primal.net/IfSZ.jpg',
                                        timestamp: DateTime.now(),
                                      ),
                                    ],
                                    reactions: [
                                      Reaction(
                                        emojiName: 'todo',
                                        emojiUrl:
                                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Femojiguide.org%2Fimages%2Femoji%2Fc%2F1e2fb481tsfvyc.png&f=1&nofb=1&ipt=73d8789f7a055e207ff06bd2278184a2ab6108a8c019f59d0526d05f91d925e7&ipo=images',
                                        profilePicUrl:
                                            'https://nostr.download/1aba957814cac9c324c54d94e0ba6606dc50af17f7c08654e9b9f139a9720d6d.jpeg',
                                        profileName: "ثعبان",
                                        timestamp: DateTime.now(),
                                      ),
                                      Reaction(
                                        emojiName: 'todo',
                                        emojiUrl:
                                            'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
                                        profilePicUrl:
                                            'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                                        profileName: "Niel Liesmons",
                                        timestamp: DateTime.now(),
                                      ),
                                    ],
                                    topReplies: [
                                      ReplyUserData(
                                        profileName: 'Vinney',
                                        profilePicUrl:
                                            'https://m.primal.net/HdAt.jpg',
                                      ),
                                      ReplyUserData(
                                        profileName: 'jrm',
                                        profilePicUrl:
                                            'https://pfp.nostr.build/e9e7963637e04d90ad2c33f21c6f112a188c5b001dd697e108991261487aa258.jpg',
                                      ),
                                      ReplyUserData(
                                        profileName: 'elsat',
                                        profilePicUrl:
                                            'https://image.nostr.build/ba781633731cd33bd20f58bbca208ae87db3f87c8f2256e23e4a8df543617c6c.png',
                                      ),
                                    ],
                                    totalReplies: 10,
                                  ),
                                ],
                              ),
                              settingsContent: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s64),
                                child: const AppText.reg14(
                                    'Reply Settings Content'),
                              ),
                              settingsDescription:
                                  'Choose which replies are displayed',
                            ),
                            TabData(
                              label: 'Shares',
                              icon: AppIcon.s20(
                                theme.icons.characters.share,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LineThicknessData.normal().medium,
                              ),
                              count: 5,
                              content: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s16),
                                child: Column(
                                  children: List.generate(
                                    5,
                                    (index) => AppContainer(
                                      margin: const AppEdgeInsets.only(
                                          bottom: AppGapSize.s12),
                                      height: 60,
                                      child: Center(
                                        child:
                                            AppText.reg14('Share ${index + 1}'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              settingsContent: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppText.med16('Share Settings'),
                                    const AppGap.s16(),
                                    AppSwitch(
                                      value: AppResponsiveTheme.of(context)
                                              .colorMode ==
                                          AppThemeColorMode.grey,
                                      onChanged: (bool value) {
                                        Future.microtask(() {
                                          AppResponsiveTheme.of(context)
                                              .setColorMode(
                                            value
                                                ? AppThemeColorMode.grey
                                                : null,
                                          );
                                        });
                                      },
                                    ),
                                    const AppGap.s8(),
                                    AppText.reg14(
                                      'Show share notifications',
                                      color: theme.colors.white66,
                                    ),
                                  ],
                                ),
                              ),
                              settingsDescription:
                                  'Configure share notifications',
                            ),
                            TabData(
                              label: 'Lists',
                              icon: AppIcon.s20(
                                theme.icons.characters.label,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LineThicknessData.normal().medium,
                              ),
                              count: 103,
                              content: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s16),
                                child: Column(
                                  children: List.generate(
                                    103,
                                    (index) => AppContainer(
                                      margin: const AppEdgeInsets.only(
                                          bottom: AppGapSize.s12),
                                      height: 60,
                                      child: Center(
                                        child:
                                            AppText.reg14('List ${index + 1}'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              settingsContent: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppText.med16('Like Settings'),
                                    const AppGap.s16(),
                                    const AppSwitch(),
                                    const AppGap.s8(),
                                    AppText.reg14(
                                      'Show like notifications',
                                      color: theme.colors.white66,
                                    ),
                                    const AppGap.s16(),
                                    const AppSwitch(),
                                    const AppGap.s8(),
                                    AppText.reg14(
                                      'Group likes together',
                                      color: theme.colors.white66,
                                    ),
                                  ],
                                ),
                              ),
                              settingsDescription:
                                  'Configure like notifications',
                            ),
                            TabData(
                              label: 'Tools',
                              icon: AppIcon.s20(
                                theme.icons.characters.tools,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LineThicknessData.normal().medium,
                              ),
                              content: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s16),
                                child: AppText.reg14('Display Tools in a Grid'),
                              ),
                            ),
                            TabData(
                              label: 'Details',
                              icon: AppIcon.s20(
                                theme.icons.characters.details,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LineThicknessData.normal().medium,
                              ),
                              content: AppContainer(
                                padding:
                                    const AppEdgeInsets.all(AppGapSize.s16),
                                child: AppText.reg14('Details Content'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const AppGap.s12(),
                AppAppSmallCard(
                  appName: 'Amethyst',
                  version: '1.21',
                  profilePicUrl:
                      'https://cdn.satellite.earth/1a4d9d7bb7f3e481aeb5f98b6626b5b4b85d90d59f4d4b00ffa7edbf1c19d6e7.png',
                  onUpdate: () {},
                ),
                const AppGap.s12(),
                AppAppSmallCard(
                  appName: 'Zaplab Design',
                  version: '1.21',
                  profilePicUrl:
                      'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
                  onUpdate: () {},
                ),
                const AppGap.s12(),
                AppAppSmallCard(
                  appName: 'Fountain',
                  version: '1.21',
                  profilePicUrl:
                      'https://cdn.satellite.earth/3bfffd395331892664cf589db1d14140e660bb237811cd9cad406f2d8168abb1.png',
                  onUpdate: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
