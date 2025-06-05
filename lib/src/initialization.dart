import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'dart:convert';

final zapchatInitializationProvider = FutureProvider<bool>((ref) async {
  try {
    await ref.read(initializationProvider(
      StorageConfiguration(
        databasePath: '',
        relayGroups: {},
        defaultRelayGroup: '',
      ),
    ).future);

    Model.register(kind: 1055, constructor: Book.fromMap);
    Model.register(kind: 10456, constructor: Group.fromMap);
    Model.register(kind: 145, constructor: Mail.fromMap);
    Model.register(kind: 35000, constructor: Task.fromMap);
    Model.register(kind: 30617, constructor: Repository.fromMap);
    Model.register(kind: 32767, constructor: Job.fromMap);
    Model.register(kind: 9321, constructor: CashuZap.fromMap);
    Model.register(
        kind: 33333,
        constructor: Service.fromMap); // TODO: Change to right kind
    Model.register(kind: 11, constructor: ForumPost.fromMap);

    final dummyProfiles = <Profile>[];
    final dummyNotes = <Note>[];
    final dummyChatMessages = <ChatMessage>[];
    final dummyArticles = <Article>[];
    final dummyCommunities = <Community>[];
    final dummyGroups = <Group>[];
    final dummyBooks = <Book>[];
    final dummyMails = <Mail>[];
    final dummyTasks = <Task>[];
    final dummyJobs = <Job>[];
    final dummyCashuZaps = <CashuZap>[];
    final dummyServices = <Service>[];
    final dummyForumPosts = <ForumPost>[];

    final jane = PartialProfile(
      name: 'Jane C.',
      pictureUrl:
          'https://cdn.satellite.earth/4b544d33c594e132b8ee1d278665632a4a3abfc30d249afb733b19fe1806522a.png',
      banner:
          'https://cdn.satellite.earth/4b544d33c594e132b8ee1d278665632a4a3abfc30d249afb733b19fe1806522a.png',
    ).dummySign(
        'e9434ae165ed91b286becfc2721ef1705d3537d051b387288898cc00d5c885be');

    final niel = PartialProfile(
      name: 'Niel Liesmons',
      pictureUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      banner:
          'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
    ).dummySign(
        'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be');

    final zapchat = PartialProfile(
      name: 'Zapchat',
      pictureUrl:
          'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
      banner:
          'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
    ).dummySign(
        '4239B36789abcdef0123456789abcdef0123456789abcdef0123456789abcdef');

    final proof = PartialProfile(
      name: 'Proof Of Reign',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.architecturaldigest.in%2Fwp-content%2Fuploads%2F2019%2F04%2FNorth-Rose-window-notre-dame-paris.jpg&f=1&nofb=1&ipt=b915d5a064b905567aa5fe9fbc8c38da207c4ba007316f5055e3e8cb1a009aa8&ipo=images',
    ).dummySign(
        'F954B79600b16b24a1bfb0519cfe4a5d1ad84959e3cce5d6d7a99d48660a1f78');

    final cypherchads = PartialProfile(
      name: 'Cypher Chads',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.imgflip.com%2F52wp8m.png',
    ).dummySign(
        'f683e87035f7ad4f44e0b98cfbd9537e16455a92cd38cefc4cb31db7557f5ef2');

    final franzap = PartialProfile(
      name: 'franzap',
      pictureUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
    ).dummySign(
        '7fa56f5d6962ab1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac194');

    final verbiricha = PartialProfile(
      name: 'verbiricha',
      pictureUrl:
          'https://npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg.blossom.band/3d84787d7284c879429eb0c8e6dcae0bf94cc50456d4046adf33cf040f8f5504.jpg',
    ).dummySign(
        '30B8C05d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac195');

    final communikeys = PartialProfile(
      name: 'Communikeys',
      pictureUrl:
          'https://cdn.satellite.earth/7873557e975cf404d12c04cd3e4b4e0e252a34998edd04de0d24a4dc8c6bddbc.png',
    ).dummySign(
        '9fa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac196');

    final nipsout = PartialProfile(
      name: 'Nips Out',
      pictureUrl:
          'https://cdn.satellite.earth/1895487e0fcd0db92babfa58501fd7cd319620c818e01d7bb941c4d465e4d685.png',
    ).dummySign(
        'afa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac197');

    final metabolism = PartialProfile(
      name: 'Metabolism Go Up',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fsaraichinwag.com%2Fwp-content%2Fuploads%2F2023%2F12%2Fwhy-am-i-craving-oranges.jpeg',
      about:
          'We discuss and research ways to improve your metabolism. We are not doctors, but we are passionate about health and fitness.',
      banner:
          'https://cdn.satellite.earth/5b8e0002026a4bd0804d0470295dfd209ef9c461957a85f62e00e2923ff18bf1.png',
    ).dummySign(
        '1203456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef');

    final hzrd149 = PartialProfile(
      name: 'hzrd149',
      pictureUrl:
          'https://cdn.hzrd149.com/5ed3fe5df09a74e8c126831eac999364f9eb7624e2b86d521521b8021de20bdc.png',
    ).dummySign(
        '266815e0c9210dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5');

    final thegang = PartialProfile(
      name: 'The Gang',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.fixthephoto.com%2Fblog%2Fimages%2Fgallery%2Fnews_preview_mob_image__preview_404.jpg',
    ).dummySign(
        '266813e0c9210dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5');

    final zapcloud = PartialProfile(
      name: 'Zapcloud',
      pictureUrl:
          'https://cdn.satellite.earth/8225a8244d1d65157adb58b1f7d16424cde1ea3f1b018a933d777ecec0959899.png',
    ).dummySign(
        '266813e0cff10dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5');

    dummyProfiles.addAll({
      jane,
      niel,
      zapchat,
      proof,
      cypherchads,
      franzap,
      verbiricha,
      communikeys,
      nipsout,
      metabolism,
      hzrd149,
      thegang,
      zapcloud,
    });

    // SignedInProfile for testing, to avoid signing in all the time

    // Add profiles to storage
    await ref
        .read(storageNotifierProvider.notifier)
        .save(dummyProfiles.toSet());

    // Set current profile and add to signed in profiles
    if (dummyProfiles.isNotEmpty) {
      final signer = DummySigner(ref, pubkey: dummyProfiles.first.pubkey);
      // TODO: Modify the active flag here to show Jane logged in, or no-one
      await signer.initialize(active: false);
    }

    // Create community after profiles are saved and indexed
    final zapchatCommunity = PartialCommunity(
      name: 'Zapchat',
      relayUrls: {'wss://relay.damus.io'},
      description:
          'Where Zapchat builders and users meet. A place to discuss, collaborate and  publish relevant content, including the app itself.',
      contentSections: {
        CommunityContentSection(
          content: 'Chat',
          kinds: {9},
          feeInSats: 100,
        ),
        CommunityContentSection(
          content: 'Threads',
          kinds: {1},
        ),
        CommunityContentSection(
          content: 'Articles',
          kinds: {30023},
        ),
        CommunityContentSection(
          content: 'Forum',
          kinds: {11},
        ),
        CommunityContentSection(
          content: 'Jobs',
          kinds: {32767},
        ),
        CommunityContentSection(
          content: 'Services',
          kinds: {33333},
        ),
        CommunityContentSection(
          content: 'Apps',
          kinds: {32267},
        ),
        CommunityContentSection(
          content: 'Books',
          kinds: {30040},
        ),
        CommunityContentSection(
          content: 'Docs',
          kinds: {30040},
        ),
        CommunityContentSection(
          content: 'Albums',
          kinds: {20},
        ),
        CommunityContentSection(
          content: 'Tasks',
          kinds: {30123},
        ),
      },
    ).dummySign(zapchat.pubkey);
    final cypherchadsCommunity = PartialCommunity(
      name: 'Cypher Chads',
      relayUrls: {'wss://relay.damus.io'},
      description: 'A community for Cypher Chads',
      contentSections: {
        CommunityContentSection(
          content: 'Chat',
          kinds: {9},
          feeInSats: 100,
        ),
        CommunityContentSection(
          content: 'Threads',
          kinds: {1},
        ),
        CommunityContentSection(
          content: 'Forum',
          kinds: {11},
        ),
        CommunityContentSection(
          content: 'Articles',
          kinds: {30023},
        ),
        CommunityContentSection(
          content: 'Jobs',
          kinds: {32767},
        ),
        CommunityContentSection(
          content: 'Services',
          kinds: {33333},
        ),
        CommunityContentSection(
          content: 'Apps',
          kinds: {32267},
        ),
        CommunityContentSection(
          content: 'Books',
          kinds: {30040},
        ),
        CommunityContentSection(
          content: 'Docs',
          kinds: {30040},
        ),
        CommunityContentSection(
          content: 'Albums',
          kinds: {20},
        ),
        CommunityContentSection(
          content: 'Tasks',
          kinds: {30123},
        ),
      },
    ).dummySign(cypherchads.pubkey);
    final communikeysCommunity = PartialCommunity(
      name: 'Communikeys',
      relayUrls: {'wss://relay.damus.io'},
      description: 'A community for Communikeys',
      contentSections: {
        CommunityContentSection(
          content: 'Chat',
          kinds: {9},
          feeInSats: 100,
        ),
        CommunityContentSection(
          content: 'Threads',
          kinds: {1},
        ),
      },
    ).dummySign(communikeys.pubkey);
    final nipsoutCommunity = PartialCommunity(
      name: 'Nips Out',
      relayUrls: {'wss://relay.damus.io'},
      description: 'A community for Nips Out',
      contentSections: {
        CommunityContentSection(
          content: 'Chat',
          kinds: {9},
          feeInSats: 100,
        ),
        CommunityContentSection(
          content: 'Wikis',
          kinds: {30818},
        ),
      },
    ).dummySign(nipsout.pubkey);
    final metabolismCommunity = PartialCommunity(
      name: 'Metabolism Go Up',
      relayUrls: {'wss://relay.damus.io'},
      description:
          'We discuss research and fund lab work around optimizing our human metabolism. We are not doctors or staet funded, on purpose. We are just a group of people who want to improve our health and fitness.',
      contentSections: {
        CommunityContentSection(
          content: 'Chat',
          kinds: {9},
          feeInSats: 100,
        ),
        CommunityContentSection(
          content: 'Threads',
          kinds: {1},
        ),
        CommunityContentSection(
          content: 'Wikis',
          kinds: {30818},
        ),
      },
    ).dummySign(metabolism.pubkey);
    dummyCommunities.addAll([
      zapchatCommunity,
      cypherchadsCommunity,
      communikeysCommunity,
      nipsoutCommunity,
      metabolismCommunity,
    ]);
    // Create groups
    final theGangGroup = PartialGroup(
      name: 'The Guys',
      relayUrls: {'wss://relay.damus.io'},
      description:
          'Where The Guys meet. A place to discuss, collaborate and  publish relevant content.',
      contentSections: {
        GroupContentSection(
          content: 'Chat',
          kinds: {9},
          feeInSats: 100,
        ),
        GroupContentSection(
          content: 'Threads',
          kinds: {1},
        ),
        GroupContentSection(
          content: 'Articles',
          kinds: {30023},
        ),
        GroupContentSection(
          content: 'Apps',
          kinds: {32267},
        ),
        GroupContentSection(
          content: 'Books',
          kinds: {30040},
        ),
        GroupContentSection(
          content: 'Docs',
          kinds: {30040},
        ),
        GroupContentSection(
          content: 'Albums',
          kinds: {20},
        ),
        GroupContentSection(
          content: 'Tasks',
          kinds: {30123},
        ),
      },
    ).dummySign(thegang.pubkey);

    dummyGroups.addAll([
      theGangGroup,
    ]);

    dummyNotes.addAll([
      PartialNote(
        'A new study on swipe actions shows that it cleans up interfaces like nothing else nostr:nevent1blablabla',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ).dummySign(niel.pubkey),
      PartialNote(
        'I love Zaplab',
        createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
      ).dummySign(franzap.pubkey),
      PartialNote(
        'A new study on swipe actions shows that it cleans up interfaces like nothing else.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ).dummySign(verbiricha.pubkey),
      PartialNote(
        'I love that the UX is the same for all conversations in here. Chat, replies, threads, ... you can just swipe on them.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
      ).dummySign(zapchat.pubkey),
      PartialNote(
        'Test Poast',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
      ).dummySign(zapchat.pubkey),
    ]);

    // Chat messages
    dummyChatMessages.addAll([
      PartialChatMessage(
        'Do you guys have pics from the farm visit??',
        createdAt: DateTime.now().subtract(const Duration(minutes: 21)),
        community: zapchatCommunity,
      ).dummySign(franzap.pubkey),
      PartialChatMessage(
        "I didn't have my phone",
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        community: zapchatCommunity,
      ).dummySign(franzap.pubkey),
      PartialChatMessage(
        'nostr:nevent1blablabla Yes! Let me check.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
        community: zapchatCommunity,
      ).dummySign(niel.pubkey),
      PartialChatMessage(
        '''https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg
                      https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F28%2F55%2F58%2F285558f2c9d2865c7f46f197228a42f4.jpg
                      https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.sheknows.com%2Fwp-content%2Fuploads%2F2018%2F08%2Fmom-toddler-gardening_bp3w3w.jpeg''',
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        community: zapchatCommunity,
      ).dummySign(verbiricha.pubkey),
      PartialChatMessage(
        'https://cdn.satellite.earth/ce1ada957054c84e7dc95ecaa6b14ddb452f4ab31632903d74ffe83bc6c8ff38.mp3',
        createdAt: DateTime.now().subtract(const Duration(minutes: 11)),
        community: zapchatCommunity,
      ).dummySign(zapchat.pubkey),
      PartialChatMessage(
        'Awesome!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
        community: zapchatCommunity,
      ).dummySign(niel.pubkey),
      PartialChatMessage(
        ':beautiful:',
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        community: zapchatCommunity,
      ).dummySign(niel.pubkey),
      PartialChatMessage(
        'Yeah, this was a great way to get the families together.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
        community: zapchatCommunity,
      ).dummySign(franzap.pubkey),
      PartialChatMessage(
        'I was just about to say that.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
        community: zapchatCommunity,
      ).dummySign(niel.pubkey),
      PartialChatMessage(
        'This is a test message with a link: https://zapchat.com',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        community: zapchatCommunity,
      ).dummySign(hzrd149.pubkey),
      PartialChatMessage(
        'This is a test message with a some ~~strike-through~~ text',
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        community: zapchatCommunity,
      ).dummySign(cypherchads.pubkey),
    ]);

    dummyArticles.addAll([
      (PartialArticle(
        'Zapchat For Dummies',
        'Content of the article',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        imageUrl:
            'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
        summary:
            'A brief introduction to a daily driver for Communities and Groups.',
      )).dummySign(zapchat.pubkey),
      (PartialArticle(
        'Communi-keys',
        """# The Key Pair
What a Nostr key pair has by default:

* A unique ID 
* A name 
* A description 
* An ability to sign stuff

# The Relay
What a Nostr relay has (or should have) by default:

* Permissions, Moderation, AUTH, ...
* Pricing & other costs to make the above work (cost per content type, subscriptions, xx publications per xx timeframe, ...)
* List of accepted content types
* (to add) Guidelines

# The Community
Since I need Communities to have all the above mentioned properties too, the simplest solution seems to be to just combine them. And when you already have a key pair and a relay, you just need the third basic Nostr building block to bring them together...

# The Event
To create a #communikey, a key pair (The Profile) needs to sign a (kind 30XXX) event that lays out the Community's :
1. Main relay + backup relays
2. Main blossom server + backup servers
3. (optional) Roles for specific npubs (admin, CEO, dictator, customer service, design lead, ...)
4. (optional) Community mint
5. (optional) "Welcome" Publication that serves as an introduction to the community 

This way: 
* **any existing npub** can become a Community
* Communities are not tied to one relay and have a truly unique ID
* Things are waaaaaay easier for relay operators/services to be compatible (relative to existing community proposals)
* Running one relay per community works an order of magnitude better, but isn't a requirement

**bold**

# The Publishers
What the Community enjoyers need to chat in one specific #communikey :
* Tag the npub in the (kind 9) chat message

What they needs to publish anything else in one or multiple #communikeys :
* Publish a (kind 32222 - Targeted publication) event that lists the npubs of the targeted Communities
* If the event is found on the main relay = The event is accepted

This way: 
* **any existing publication** can be targeted at a Community
* Communities can #interop on content and bring their members together in reply sections, etc...
* Your publication isn't tied **forever** to a specific relay

## Ncommunity
If nprofile = npub + relay hints, for profiles   
Then ncommunity = npub + relay hints, for communities
""",
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        imageUrl:
            'https://cdn.satellite.earth/7273fad49b4c3a17a446781a330553e1bb8de7a238d6c6b6cee30b8f5caf21f4.png',
        summary: 'Npub + Relay + 2 new event kinds = Ncommunity',
      )).dummySign(niel.pubkey),
      (PartialArticle(
        """Don't build on social, its a trap""",
        """To all existing nostr developers and new nostr developers, stop using kind 1 events... just stop whatever your doing and switch the kind to `Math.round(Math.random() * 10000)` trust me it will be better\n\n## What are kind 1 events\n\nkind 1 events are defined in [NIP-10](https://github.com/nostr-protocol/nips/blob/master/10.md) as "simple plaintext notes" or in other words social threads.\n\n## Don't trick your users\n\nMost users are joining nostr for the social experience, and secondly to find all the cool "other stuff" apps\nThey find friends, browse social threads, and reply to them. If a user signs into a new nostr client and it starts asking them to sign kind 1 events with blobs of JSON, they will sign it without thinking too much about it.\n\nThen when they return to their comfy social apps they will see that they made 10+ threads with massive amounts of gibberish that they don't remember threading. then they probably will go looking for the delete button and realize there isn't one...\n\nEven if those kind 1 threads don't contain JSON and have a nice fancy human readable syntax. they will still confuse users because they won't remember writing those social threads\n\n## What about "discoverability"\n\nIf your goal is to make your "other stuff" app visible to more users, then I would suggest using [NIP-19](https://github.com/nostr-protocol/nips/blob/master/19.md) and [NIP-89](https://github.com/nostr-protocol/nips/blob/master/89.md)\nThe first allows users to embed any other event kind into social threads as `nostr:nevent1` or `nostr:naddr1` links, and the second allows social clients to redirect users to an app that knows how to handle that specific kind of event\n\nSo instead of saving your apps data into kind 1 events. you can pick any kind you want, then give users a "share on nostr" button that allows them to compose a social thread (kind 1) with a `nostr:` link to your special kind of event and by extension you app\n\n## Why its a trap\n\nOnce users start using your app it becomes a lot more difficult to migrate to a new event kind or data format.\nThis sounds obvious, but If your app is built on kind 1 events that means you will be stuck with their limitations forever. \n\nFor example, here are some of the limitations of using kind 1\n - Querying for your apps data becomes much more difficult. You have to filter through all of a users kind 1 events to find which ones are created by your app\n - Discovering your apps data is more difficult for the same reason, you have to sift through all the social threads just to find the ones with you special tag or that contain JSON\n - Users get confused. as mentioned above users don't expect "other stuff" apps to be creating special social threads\n - Other nostr clients won't understand your data and will show it as a social thread with no option for users to learn about your app""",
        publishedAt: DateTime.now().subtract(const Duration(minutes: 20)),
        summary: 'As a developer, why you should not use kind 1 events.',
      )).dummySign(hzrd149.pubkey),
      (PartialArticle(
        'Metabolic Health Foods You Can Find in Any Store',
        'Content of the third article',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        imageUrl:
            'https://cdn.satellite.earth/5b8e0002026a4bd0804d0470295dfd209ef9c461957a85f62e00e2923ff18bf1.png',
        summary:
            'A deep dive into foods that are good for your metabolic health and you can actually find in stores.',
      )).dummySign(metabolism.pubkey),
    ]);

    dummyBooks.addAll([
      (PartialBook(
        'Eat Like A Human',
        'Content of the book',
        writer: 'Bill Schindler',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.hachettebookgroup.com%2Fwp-content%2Fuploads%2F2021%2F09%2F9780316244886.jpg',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).dummySign(franzap.pubkey),
      (PartialBook(
        'In Search Of The Physical Basis Of Life',
        'Content of the book',
        writer: 'Gilbert Ling',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fnwf-bucket.s3.me-south-1.amazonaws.com%2Fimages%2Fae%2Fabookstore%2Fcovers%2Fnormal%2F315%2F315121.jpg',
      )).dummySign(franzap.pubkey),
      (PartialBook(
        'En quête d\'amour',
        'Content of the book',
        writer: 'Anneke Lucas',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.squarespace-cdn.com%2Fcontent%2Fv1%2F59ab4dedc027d8465d8c085c%2F07cc0908-7279-4dcf-a85f-cca89fc8a245%2FGUQyi3xWoAAIAW3.jpg',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).dummySign(niel.pubkey),
      (PartialBook(
        'A Book with a surprsingly long title that is here to test text overflow',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).dummySign(franzap.pubkey),
      (PartialBook(
        'Bokk Title One',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).dummySign(franzap.pubkey),
      (PartialBook(
        'Book Title Two',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).dummySign(franzap.pubkey),
      (PartialBook(
        'Book Title Three',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).dummySign(franzap.pubkey),
      (PartialBook(
        'Book Title Four',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).dummySign(franzap.pubkey),
    ]);

    dummyMails.addAll([
      PartialMail(
        'Marriage Invitation',
        'Chicos & Chicas, \nMe and nostr:npub1blablabla are getting married and would love for you to be there. \nPlease let me know if you can make it. \n\nBest regards, \n\n**Fran**',
        recipientPubkeys: {
          'e9434ae165ed91b286becfc2721ef1705d3537d051b387288898cc00d5c885be', // jane
          '4239B36789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', // zapchat
          '266813e0cff10dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5', // zapcloud
          'f683e87035f7ad4f44e0b98cfbd9537e16455a92cd38cefc4cb31db7557f5ef2', // cypherchads
          '7fa56f5d6962ab1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac194', // franzap
          '30B8C05d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac195', // verbiricha
          '9fa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac196', // communikeys
          'afa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac197', // nipsout
          '1203456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', // metabolism
          '266815e0c9210dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5', // hzrd149
          '266813e0c9210dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5', // thegang
          '266813e0cff10dfa324c6cba357b14bee49da4209a9456f9484e5106cd408a5', // zapcloud
        },
      ).dummySign(franzap.pubkey),
      (PartialMail(
        'Re: Job Listing - Branding & Corprate Identity for Zapcloud',
        'Hey Zapcloud Team, \n\nI think I might be a good fit for this job. \n\nI have a lot of experience in branding and corporate identity, in the Nostr space specifically. \n\nHere\'s my [Portfolio](https://zapchat.com/portfolio) \n\nBest regards, \n\n**Niel**',
        recipientPubkeys: {
          'e9434ae165ed91b286becfc2721ef1705d3537d051b387288898cc00d5c885be', // jane
          '266813e0cff10dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5', // zapcloud
        },
      )).dummySign(niel.pubkey),
      (PartialMail(
        'Top-Up Time!',
        'Hey Jane! \n\n## Reminder \nYour Zapcloud budget is running low. \n\n[Top Up Here](https://zapchat.com/top-up) to avoid service disruption. \n\nList test: \n- Item 1 \n- Item 2 \n- Item 3 \n\nBest regards, \n\n**Zapcloud**',
        recipientPubkeys: {
          'e9434ae165ed91b286becfc2721ef1705d3537d051b387288898cc00d5c885be'
        },
      )).dummySign(zapcloud.pubkey),
    ]);

    dummyTasks.addAll([
      (PartialTask(
        'Task Title',
        'Task Content',
        status: 'open',
        slug: Utils.generateRandomHex64(),
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).dummySign(franzap.pubkey),
      (PartialTask(
        'Task Title',
        'Task Content',
        status: 'inProgress',
        slug: Utils.generateRandomHex64(),
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).dummySign(zapcloud.pubkey),
      (PartialTask(
        'Task Title',
        'Task Content',
        status: 'inReview',
        slug: Utils.generateRandomHex64(),
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).dummySign(niel.pubkey),
      (PartialTask(
        'Task Title',
        'Task Content',
        status: 'closed',
        slug: Utils.generateRandomHex64(),
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).dummySign(zapchat.pubkey),
    ]);

    dummyJobs.addAll([
      (PartialJob(
        'Logo & Branding Design',
        '''Zapcloud Brand Design \n## Project Overview\nZapcloud is an **all-in-one** hosting solution for Nostr and we need branding and bla bla bla.''',
        labels: {
          'Branding',
          'Design',
          'Logo',
          'Marketing',
        },
        location: 'Remote',
        employment: 'Task Based',
      )).dummySign(zapcloud.pubkey),
      (PartialJob(
        'Community Manager',
        '''Zapchat Community Manager \n## Project Overview\nZapchat is a Nostr community for the Zapchat project and we need a community manager to help us grow the community.''',
        labels: {
          'Community',
          'Moderation',
          'Content',
        },
        location: 'Remote',
        employment: 'Full-Time',
      )).dummySign(metabolism.pubkey),
      (PartialJob(
        'Food Forest Design',
        '''Food Forest Design \n## Project Overview\nFood Forest is a permaculture project in Winsconsin, USA and we need a design to help us grow plants and trees.''',
        labels: {
          'Permaculture',
          'Gardening',
          'Design',
        },
        location: 'Winsconsin, USA',
        employment: 'Task Based',
      )).dummySign(jane.pubkey),
    ]);

    // Add dummy zap requests
    dummyCashuZaps.addAll([
      (PartialCashuZap(
        'Thanks for the great content!',
        proof: jsonEncode({'amount': 1000}),
        url: 'https://cashu.mint.example.com',
        zappedEventId: '1234567890abcdef',
        recipientPubkey: niel.pubkey,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      )).dummySign(niel.pubkey),
      (PartialCashuZap(
        "nostr:nevent1234567890abcdef No, but here's a zap",
        proof: jsonEncode({'amount': 123}),
        url: 'https://cashu.mint.example.com',
        zappedEventId: '1234567890abcdef',
        recipientPubkey: franzap.pubkey,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      )).dummySign(verbiricha.pubkey),
    ]);

    dummyServices.addAll([
      (PartialService(
        'Nostr App Design',
        "Here's some text to convince you that a dude that spent under two years of his life designing and building UIs can do a wonderful job for you.",
        summary:
            'Pixel-perfect designs and front end builds for your Nostr app.',
        images: {
          'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
          'https://cdn.satellite.earth/723a6b2aaa7df2512da3e3858d70e0fbea01c0b2a43be91d3f6d42d3e004fd0a.png',
          'https://cdn.satellite.earth/d2403b5242834573a3c19d9024dda0e61defc76442247c19082755f48bbf13e9.png',
        },
      )).dummySign(niel.pubkey),
      (PartialService(
        'Custom Micro App',
        "Here's some text to convince you that we can build a decent app for you;",
        summary:
            'We build small custom Nostr apps for any platform, that can tap right into your existing Communities and Provate groups',
        images: {
          'https://cdn.satellite.earth/6375a73e1ee7b398c3910ac06cfd8fa79d5947fd898f68ba401960465d4e15bf.png',
        },
      )).dummySign(franzap.pubkey),
    ]);

    dummyForumPosts.addAll([
      (PartialForumPost(
        'Forum Post Title',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      )).dummySign(niel.pubkey),
      (PartialForumPost(
        'Forum Post Title',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      )).dummySign(franzap.pubkey),
      (PartialForumPost(
        'Forum Post Title',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      )).dummySign(zapchat.pubkey),
    ]);

    // Save all data
    await ref.read(storageNotifierProvider.notifier).save({
      ...dummyProfiles,
      ...dummyNotes,
      ...dummyArticles,
      ...dummyChatMessages,
      ...dummyCommunities,
      ...dummyGroups,
      ...dummyBooks,
      ...dummyMails,
      ...dummyTasks,
      ...dummyJobs,
      ...dummyCashuZaps,
      ...dummyServices,
      ...dummyForumPosts,
    });

    return true;
  } catch (e, stackTrace) {
    print('Error during initialization: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
