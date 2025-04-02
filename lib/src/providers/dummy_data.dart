import 'package:zaplab_design/zaplab_design.dart';
import 'chat_screen.dart';

final dummyChatScreenProfiles = {
  'npub1': ChatScreenProfile(
    npub: 'npub1',
    profileName: 'franzap',
    profilePicUrl:
        'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
    mainCount: 24,
    contentCounts: {'chat': 16, 'app': 2, 'wiki': 1},
  ),
  'npub2': ChatScreenProfile(
    npub: 'npub2',
    profileName: 'Zapchat',
    profilePicUrl:
        'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
    mainCount: 14,
    contentCounts: {
      'chat': 6,
      'post': 2,
      'article': 1,
      'work-out': 0,
      'wiki': 0,
      'book': 0,
      'repo': 0,
      'doc': 0,
      'app': 0,
      'task': 0,
      'image': 0,
      'video': 0,
    },
  ),

  'npub3': ChatScreenProfile(
    npub: 'npub3',
    profileName: 'Youser Naim',
    profilePicUrl:
        'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
    mainCount: 8,
    contentCounts: {'post': 2, 'article': 0, 'app': 0, 'wiki': 0, 'book': 0},
  ),
  // Add more profiles...
};

final dummyMessages = {
  'npub1': [
    Message(
      nevent: 'nevent1jhbkjdsnfdkglfh',
      npub: 'npub1',
      message: 'nostr:nevent1jhbkjdsnfdkgl This one you mean?',
      profileName: 'franzap',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      nevent: 'nevent2tfyghj',
      npub: 'npub1',
      message:
          '''https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg
                    https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F28%2F55%2F58%2F285558f2c9d2865c7f46f197228a42f4.jpg
                    https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.sheknows.com%2Fwp-content%2Fuploads%2F2018%2F08%2Fmom-toddler-gardening_bp3w3w.jpeg''',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent3kbsdgju',
      npub: 'npub1',
      message: 'Yeah, loving the UX',
      profileName: 'John',
      profilePicUrl: 'https://example.com/john.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    Message(
      nevent: 'nevent4hsosppsnh',
      npub: 'npub1',
      message: 'This is awesome!',
      profileName: 'John',
      profilePicUrl: 'https://example.com/john.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ],
  'npub2': [
    Message(
      nevent: 'nevent2gsdoppppp',
      npub: 'npub2',
      message: 'Love it! :emoji:',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent4rtyuin',
      npub: 'npub2',
      message: '''We're using `kind 1111` for that too, right?''',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2uidsfgcvb',
      npub: 'npub4',
      message:
          'https://thetestdata.com/assets/audio/mp3/thetestdata-sample-mp3-3.mp3',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      reactions: [
        Reaction(
          nevent: 'nevent2dfghjk',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl:
              'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
          emojiUrl:
              'https://image.nostr.build/f1ac401d3f222908d2f80df7cfadc1d73f4e0afa3a3ff6e8421bf9f0b37372a6.gif',
          emojiName: '👍',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        Reaction(
          nevent: 'nevent2wxcvbn',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl:
              'https://vcavallo.nyc3.cdn.digitaloceanspaces.com/images/denim-shirt-sideways.jpeg',
          emojiUrl:
              'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
          emojiName: '👍',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
      zaps: [
        Zap(
          amount: 100,
          nevent: 'nevent2fghxcvtyu',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl: 'https://i.nostr.build/fJRIxKVK4Gyl32OF.png',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
    ),
    Message(
      nevent: 'nevent2uiortyui',
      npub: 'npub3',
      message: '''👍 ''',
      profileName: 'Niel Liesmons',
      profilePicUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent4rtyuin',
      npub: 'npub2',
      message: 'Yeah, that\'s right! We should do that.',
      profileName: 'franzap',
      profilePicUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2fghjksoskjkn',
      npub: 'npub1',
      message:
          '''https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fphotokaz.com%2Fwp-content%2Fuploads%2F2012%2F08%2F2012-08-18-Lions-Binkert-Hike-9870-MKH.jpg
                    https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F28%2F55%2F58%2F285558f2c9d2865c7f46f197228a42f4.jpg
                    https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.sheknows.com%2Fwp-content%2Fuploads%2F2018%2F08%2Fmom-toddler-gardening_bp3w3w.jpeg https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg''',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2hsosokbnahh',
      npub: 'npub1',
      message: '''These are some pics!''',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2aaaabhjck',
      npub: 'npub4',
      message:
          '''https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fphotokaz.com%2Fwp-content%2Fuploads%2F2012%2F08%2F2012-08-18-Lions-Binkert-Hike-9870-MKH.jpg
                    https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F28%2F55%2F58%2F285558f2c9d2865c7f46f197228a42f4.jpg
                    https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.sheknows.com%2Fwp-content%2Fuploads%2F2018%2F08%2Fmom-toddler-gardening_bp3w3w.jpeg https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg''',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      reactions: [
        Reaction(
          nevent: 'nevent2dfghjk',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl:
              'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
          emojiUrl:
              'https://image.nostr.build/f1ac401d3f222908d2f80df7cfadc1d73f4e0afa3a3ff6e8421bf9f0b37372a6.gif',
          emojiName: '👍',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        Reaction(
          nevent: 'nevent2wxcvbn',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl:
              'https://vcavallo.nyc3.cdn.digitaloceanspaces.com/images/denim-shirt-sideways.jpeg',
          emojiUrl:
              'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
          emojiName: '👍',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
      zaps: [
        Zap(
          amount: 100,
          nevent: 'nevent2fghxcvtyu',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl: 'https://i.nostr.build/fJRIxKVK4Gyl32OF.png',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
    ),
    Message(
      nevent: 'nevent2tyudfwxcvbn',
      npub: 'npub3',
      message: 'nostr:npub1fghj rhymes with Chip',
      profileName: 'Niel Liesmons',
      profilePicUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2uiortyui',
      npub: 'npub3',
      message: '''🌰 🐿''',
      profileName: 'Niel Liesmons',
      profilePicUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      nevent: 'nevent2uidsfgcvb',
      npub: 'npub4',
      message: 'Audio messages **coming** in hot 🔥',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now(),
    ),
    Message(
      nevent: 'nevent2yufghxcvbn',
      npub: 'npub4',
      message:
          'https://thetestdata.com/assets/audio/mp3/thetestdata-sample-mp3-3.mp3',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now(),
    ),
    Message(
      nevent: 'nevent3iosdfghvbn',
      npub: 'npub2',
      message: ':emoji:',
      profileName: '⚡️ᗪㄖ匚⚡️',
      profilePicUrl:
          'https://primal.b-cdn.net/media-cache?s=s&a=1&u=https%3A%2F%2Fnostr.build%2Fi%2Fp%2Fnostr.build_fab35c1107ceb94a0a8cfb346f0299f2a1e0a447dfe3c57a1e741b61b741e35d.gif',
      timestamp: DateTime.now(),
    ),
    Message(
      nevent: 'nevent3tyuidsfgcvb',
      npub: 'npub3',
      message:
          'Test `test` https://cdn.satellite.earth/05978bb8e64ff8d9aea73b6bd3bd2576b5b4fdc8744a1e5bcdfcf8ba080dcd87.mp3',
      profileName: 'Pip',
      profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
      timestamp: DateTime.now(),
    ),
    Message(
      nevent: 'nevent3uiopsdfghklm',
      npub: 'npub3',
      message:
          'https://audio-samples.github.io/samples/mp3/blizzard_biased/sample-1.mp3',
      profileName: 'Pip',
      profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
      timestamp: DateTime.now(),
    ),
    Message(
      nevent: 'nevent2ydcncjkkdkjbze',
      npub: 'npub4',
      message:
          '''https://audio-samples.github.io/samples/mp3/blizzard_biased/sample-4.mp3''',
      profileName: 'Youser Naim',
      profilePicUrl:
          'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
      timestamp: DateTime.now(),
      reactions: [
        Reaction(
          nevent: 'nevent2',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl:
              'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
          emojiUrl:
              'https://image.nostr.build/f1ac401d3f222908d2f80df7cfadc1d73f4e0afa3a3ff6e8421bf9f0b37372a6.gif',
          emojiName: '👍',
          timestamp: DateTime.now(),
        ),
        Reaction(
          nevent: 'nevent2',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl:
              'https://vcavallo.nyc3.cdn.digitaloceanspaces.com/images/denim-shirt-sideways.jpeg',
          emojiUrl:
              'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
          emojiName: '👍',
          timestamp: DateTime.now(),
        ),
      ],
      zaps: [
        Zap(
          amount: 100,
          nevent: 'nevent2',
          npub: 'npub1',
          profileName: 'John',
          profilePicUrl: 'https://i.nostr.build/fJRIxKVK4Gyl32OF.png',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
    ),
  ],
  'npub3': [
    Message(
      nevent: 'nevent1hjvzcbvvfjoie',
      npub: 'npub3',
      message: 'Hey, I just finished wiring all this up!',
      profileName: 'Youser Naim',
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

final dummyProfilesInUse = [
  Profile(
    npub:
        'npub149p5act9a5qm9p47elp8w8h3wpwn2d7s2xecw2ygnrxqp4wgsklq9g722q', // Current user's npub
    profileName: 'Niel Liesmons',
    profilePicUrl:
        'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
  ),
  Profile(
    npub: 'npub1ak68qfcjj7k95c0jwleu69x72nr8adwv6g80pkwl9xlps6zmkqzqrxy8fx',
    profileName: 'Zapchat',
    profilePicUrl:
        'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
  ),
  Profile(
    npub: 'npub1yay8e9sqk94jfgdlkpgeelj2t5ddsj2eu0xwt4kh4xw5ses2rauqnstrdv',
    profileName: 'Proof Of Reign',
    profilePicUrl:
        'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.architecturaldigest.in%2Fwp-content%2Fuploads%2F2019%2F04%2FNorth-Rose-window-notre-dame-paris.jpg&f=1&nofb=1&ipt=b915d5a064b905567aa5fe9fbc8c38da207c4ba007316f5055e3e8cb1a009aa8&ipo=images',
  ),
];
