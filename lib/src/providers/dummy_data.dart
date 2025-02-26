import 'package:zaplab_design/zaplab_design.dart';
import 'chat_screen.dart';

final dummyChatScreenProfiles = {
  'npub1': ChatScreenProfile(
    npub: 'npub1',
    profileName: 'Youser Naim',
    profilePicUrl:
        'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
    mainCount: 8,
    contentCounts: {
      'chat': 12,
      'post': 4,
      'article': 1,
      'app': 4,
      'wiki': 0,
      'book': 0
    },
  ),
  'npub2': ChatScreenProfile(
    npub: 'npub2',
    profileName: 'Zapchatters',
    profilePicUrl:
        'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
    mainCount: 24,
    contentCounts: {'chat': 6, 'post': 2, 'article': 1, 'wiki': 0, 'book': 0},
  ),
  'npub3': ChatScreenProfile(
    npub: 'npub3',
    profileName: 'franzap',
    profilePicUrl:
        'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
    mainCount: 24,
    contentCounts: {'chat': 16, 'app': 2, 'wiki': 1},
  ),
  // Add more profiles...
};

final dummyMessages = {
  'npub1': [
    Message(
      nevent: 'nevent1',
      npub: 'npub1',
      message: 'Ow, I see. This is not just a chat app, is it?',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      nevent: 'nevent2',
      npub: 'npub1',
      message: 'This is awesome!',
      profileName: 'John',
      profilePicUrl: 'https://example.com/john.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent3',
      npub: 'npub1',
      message: 'Yeah, loving the UX',
      profileName: 'John',
      profilePicUrl: 'https://example.com/john.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    Message(
      nevent: 'nevent4',
      npub: 'npub1',
      message: 'This is awesome!',
      profileName: 'John',
      profilePicUrl: 'https://example.com/john.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ],
  'npub2': [
    Message(
      nevent: 'nevent2',
      npub: 'npub2',
      message: 'This is awesome!',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2',
      npub: 'npub2',
      message: 'Are the margins ok?',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2',
      npub: 'npub4',
      message:
          'This is a message by the current user that is long enough to see if we have correct margins and paddings going on.',
      profileName: 'Niel Liesmons',
      profilePicUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent3',
      npub: 'npub2',
      message: 'Yeah, loving the UX',
      profileName: '⚡️ᗪㄖ匚⚡️',
      profilePicUrl:
          'https://primal.b-cdn.net/media-cache?s=s&a=1&u=https%3A%2F%2Fnostr.build%2Fi%2Fp%2Fnostr.build_fab35c1107ceb94a0a8cfb346f0299f2a1e0a447dfe3c57a1e741b61b741e35d.gif',
      timestamp: DateTime.now(),
    ),
    Message(
      nevent: 'nevent3',
      npub: 'npub3',
      message: 'Test message ',
      profileName: 'Pip',
      profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
      timestamp: DateTime.now(),
    ),
  ],
  'npub3': [
    Message(
      nevent: 'nevent1',
      npub: 'npub3',
      message: 'Hey, I just finished wiring all this up!',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ],
  // Add more messages...
};

final dummyPosts = {
  'npub1': [
    Post(
      npub: 'npub1',
      nevent: 'nevent1',
      profileName: 'Prof. Ille Namez',
      profilePicUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2FD5603AQGo4xFyJdt9_Q%2Fprofile-displayphoto-shrink_200_200%2F0%2F1697162085116%3Fe%3D2147483647%26v%3Dbeta%26t%3DkrXTtbRXKpTPHLaTG72YYdPiy3JVHjv5naMeZ5pBhwc&f=1&nofb=1&ipt=76b21679ded9ac6d0ecd3f3520538c08d6a9433fee07170a53845c7b26068631&ipo=images',
      content:
          'A new study on swipe actions shows that it cleans up interfaces like nothing else',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      reactions: [],
      zaps: [],
    ),
    Post(
      npub: 'npub4',
      nevent: 'nevent2',
      profileName: 'Prof. Ille Namez',
      profilePicUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2FD5603AQGo4xFyJdt9_Q%2Fprofile-displayphoto-shrink_200_200%2F0%2F1697162085116%3Fe%3D2147483647%26v%3Dbeta%26t%3DkrXTtbRXKpTPHLaTG72YYdPiy3JVHjv5naMeZ5pBhwc&f=1&nofb=1&ipt=76b21679ded9ac6d0ecd3f3520538c08d6a9433fee07170a53845c7b26068631&ipo=images',
      content:
          'A new study on swipe actions shows that it cleans up interfaces like nothing else',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      reactions: [],
      zaps: [],
    ),
  ],
  'npub2': [
    Post(
      npub: 'npub4',
      nevent: 'nevent2',
      profileName: 'Prof. Ille Namez',
      profilePicUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2FD5603AQGo4xFyJdt9_Q%2Fprofile-displayphoto-shrink_200_200%2F0%2F1697162085116%3Fe%3D2147483647%26v%3Dbeta%26t%3DkrXTtbRXKpTPHLaTG72YYdPiy3JVHjv5naMeZ5pBhwc&f=1&nofb=1&ipt=76b21679ded9ac6d0ecd3f3520538c08d6a9433fee07170a53845c7b26068631&ipo=images',
      content:
          'A new study on swipe actions shows that it cleans up interfaces like nothing else.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      reactions: [],
      zaps: [],
    ),
    Post(
      npub: 'npub4',
      nevent: 'nevent2',
      content:
          'I love that the UX is the same for all conversations in here. Chat, replies, threads, ... you can just swipe on them.',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 32)),
      reactions: [],
      zaps: [],
    ),
  ],
  'npub3': [
    Post(
      npub: 'npub4',
      nevent: 'nevent2',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      content: 'Test Poast',
      timestamp: DateTime.now().subtract(const Duration(minutes: 32)),
      reactions: [],
      zaps: [],
    ),
  ],
};

final dummyArticles = {
  'npub1': [
    Article(
      npub: 'npub1qqqqqq',
      nevent: 'article1',
      profileName: 'hodlbod',
      profilePicUrl: 'https://i.nostr.build/AZ0L.jpg',
      title: 'Doing DVMs',
      imageUrl:
          'https://coracle-media.us-southeast-1.linodeobjects.com/stephan-valentin-r74II0tE7tc-unsplash.jpg',
      timestamp: DateTime.now(),
      reactions: [],
      zaps: [],
    ),
    Article(
      npub: 'npub1qqqqqq',
      nevent: 'article1',
      profileName: 'Pip',
      profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
      title: 'Introducing Vertex — Social Graph as a Service',
      imageUrl:
          'https://blossom.primal.net/1e190b60f7db0ba86fdbf040ba53825059bdb423827a7bb821531d84f07be145.png',
      timestamp: DateTime.now(),
      reactions: [],
      zaps: [],
    ),
    Article(
      npub: 'npub1qqqqqq',
      nevent: 'article3',
      profileName: 'Silberengel',
      profilePicUrl: 'https://i.nostr.build/k1vuNUKWqrxLaprb.jpg',
      title: 'The Lone Wolf End Game',
      imageUrl:
          'https://img.freepik.com/premium-photo/lone-wolf-howling-dark-winter-night-sky-generated-by-ai_24640-100823.jpg',
      timestamp: DateTime.now(),
      reactions: [],
      zaps: [],
    ),
  ],
  'npub2': [
    Article(
      npub: 'npub1qqqqqq',
      nevent: 'article1',
      profileName: 'Niel Liesmons',
      profilePicUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      title: 'Proof Of Reign',
      imageUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftraveldigg.com%2Fwp-content%2Fuploads%2F2016%2F06%2FSalisbury-Cathedral-Image.jpg&f=1&nofb=1&ipt=53effeb1c04b97da14f69d85f9da35476303a4612e4af5c175f7a3ee008161aa&ipo=images',
      timestamp: DateTime.now(),
      reactions: [],
      zaps: [],
    ),
    Article(
      npub: 'npub1qqqqqq',
      nevent: 'article1',
      profileName: 'hodlbod',
      profilePicUrl: 'https://i.nostr.build/AZ0L.jpg',
      title: 'Doing DVMs',
      imageUrl:
          'https://coracle-media.us-southeast-1.linodeobjects.com/stephan-valentin-r74II0tE7tc-unsplash.jpg',
      content: 'Introducing Vertex — Social Graph as a Service',
      timestamp: DateTime.now(),
      reactions: [],
      zaps: [],
    ),
    Article(
      npub: 'npub1qqqqqq',
      nevent: 'article3',
      profileName: 'Silberengel',
      profilePicUrl: 'https://i.nostr.build/k1vuNUKWqrxLaprb.jpg',
      title: 'The Lone Wolf End Game',
      imageUrl:
          'https://img.freepik.com/premium-photo/lone-wolf-howling-dark-winter-night-sky-generated-by-ai_24640-100823.jpg',
      content: 'This is a test article',
      timestamp: DateTime.now(),
      reactions: [],
      zaps: [],
    ),
  ],
};
