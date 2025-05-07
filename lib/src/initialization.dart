import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zapchat/src/providers/user_profiles.dart';
import 'package:zaplab_design/zaplab_design.dart';

final zapchatInitializationProvider = FutureProvider<bool>((ref) async {
  try {
    await ref.read(initializationProvider(
      StorageConfiguration(
        databasePath: '',
        relayGroups: {},
        defaultRelayGroup: '',
      ),
    ).future);

    // Register the Book model with kind 1055
    Model.register(kind: 1055, constructor: Book.fromMap);
    Model.register(kind: 10456, constructor: Group.fromMap);

    print('Models initialized with Book model registered');

    final dummyProfiles = <Profile>[];
    final dummyNotes = <Note>[];
    final dummyChatMessages = <ChatMessage>[];
    final dummyArticles = <Article>[];
    final dummyCommunities = <Community>[];
    final dummyGroups = <Group>[];
    final dummyBooks = <Book>[];

    print('Creating signer...');
    final signer = DummySigner(ref);
    print('Signer created');

    print('Creating profiles...');

    final niel = await PartialProfile(
      name: 'Niel Liesmons',
      pictureUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
      banner:
          'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
    ).signWith(signer,
        withPubkey:
            'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be');
    print(
        'Niel profile created - name: ${niel.name}, pubkey: ${niel.pubkey}, pictureUrl: ${niel.pictureUrl}');
    final zapchat = await PartialProfile(
      name: 'Zapchat',
      pictureUrl:
          'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
      banner:
          'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
    ).signWith(signer,
        withPubkey:
            '4239B36789abcdef0123456789abcdef0123456789abcdef0123456789abcdef');
    print(
        'Zapchat profile created - name: ${zapchat.name}, pubkey: ${zapchat.pubkey}, pictureUrl: ${zapchat.pictureUrl}');

    final proof = await PartialProfile(
      name: 'Proof Of Reign',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.architecturaldigest.in%2Fwp-content%2Fuploads%2F2019%2F04%2FNorth-Rose-window-notre-dame-paris.jpg&f=1&nofb=1&ipt=b915d5a064b905567aa5fe9fbc8c38da207c4ba007316f5055e3e8cb1a009aa8&ipo=images',
    ).signWith(signer,
        withPubkey:
            'F954B79600b16b24a1bfb0519cfe4a5d1ad84959e3cce5d6d7a99d48660a1f78');
    print(
        'Zapstore profile created - name: ${proof.name}, pubkey: ${proof.pubkey}, pictureUrl: ${proof.pictureUrl}');

    final cypherchads = await PartialProfile(
      name: 'Cypher Chads',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.imgflip.com%2F52wp8m.png',
    ).signWith(signer,
        withPubkey:
            'f683e87035f7ad4f44e0b98cfbd9537e16455a92cd38cefc4cb31db7557f5ef2');
    print(
        'Cypherchads profile created - name: ${cypherchads.name}, pubkey: ${cypherchads.pubkey}, pictureUrl: ${cypherchads.pictureUrl}');

    final franzap = await PartialProfile(
      name: 'franzap',
      pictureUrl:
          'https://nostr.build/i/nostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
    ).signWith(signer,
        withPubkey:
            '7fa56f5d6962ab1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac194');
    print(
        'Franzap profile created - name: ${franzap.name}, pubkey: ${franzap.pubkey}, pictureUrl: ${franzap.pictureUrl}');

    final verbiricha = await PartialProfile(
      name: 'verbiricha',
      pictureUrl:
          'https://npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg.blossom.band/3d84787d7284c879429eb0c8e6dcae0bf94cc50456d4046adf33cf040f8f5504.jpg',
    ).signWith(signer,
        withPubkey:
            '30B8C05d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac195');
    print(
        'Verbiricha profile created - name: ${verbiricha.name}, pubkey: ${verbiricha.pubkey}, pictureUrl: ${verbiricha.pictureUrl}');

    final communikeys = await PartialProfile(
      name: 'Communikeys',
      pictureUrl:
          'https://cdn.satellite.earth/7873557e975cf404d12c04cd3e4b4e0e252a34998edd04de0d24a4dc8c6bddbc.png',
    ).signWith(signer,
        withPubkey:
            '9fa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac196');

    final nipsout = await PartialProfile(
      name: 'Nips Out',
      pictureUrl:
          'https://cdn.satellite.earth/1895487e0fcd0db92babfa58501fd7cd319620c818e01d7bb941c4d465e4d685.png',
    ).signWith(signer,
        withPubkey:
            'afa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac197');

    final metabolism = await PartialProfile(
      name: 'Metabolism Go Up',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fsaraichinwag.com%2Fwp-content%2Fuploads%2F2023%2F12%2Fwhy-am-i-craving-oranges.jpeg',
      about:
          'We discuss and research ways to improve your metabolism. We are not doctors, but we are passionate about health and fitness.',
      banner:
          'https://cdn.satellite.earth/5b8e0002026a4bd0804d0470295dfd209ef9c461957a85f62e00e2923ff18bf1.png',
    ).signWith(signer,
        withPubkey:
            '1203456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef');

    final hzrd149 = await PartialProfile(
      name: 'hzrd149',
      pictureUrl:
          'https://cdn.hzrd149.com/5ed3fe5df09a74e8c126831eac999364f9eb7624e2b86d521521b8021de20bdc.png',
    ).signWith(signer,
        withPubkey:
            '266815e0c9210dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5');

    final thegang = await PartialProfile(
      name: 'The Gang',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.fixthephoto.com%2Fblog%2Fimages%2Fgallery%2Fnews_preview_mob_image__preview_404.jpg',
    ).signWith(signer,
        withPubkey:
            '266813e0c9210dfa324c6cba3573b14bee49da4209a9456f9484e5106cd408a5');

    dummyProfiles.addAll([
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
    ]);

    // Save profiles first and wait for them to be indexed
    print('Saving profiles to storage...');
    print(
        'Profiles to save: ${dummyProfiles.map((p) => '${p.name} (${p.pubkey})').join(', ')}');
    await ref
        .read(storageNotifierProvider.notifier)
        .save(Set.from(dummyProfiles));
    print('Profiles saved successfully');

    // Set initial user profiles and current profile
    print('Setting initial user profiles and current profile...');
    try {
      // Add profiles to userProfilesProvider
      for (final profile in dummyProfiles) {
        await ref.read(userProfilesProvider.notifier).addProfile(profile);
      }

      // Set current profile
      if (dummyProfiles.isNotEmpty) {
        await ref
            .read(userProfilesProvider.notifier)
            .setCurrentProfile(dummyProfiles.first);
      }
      print('Initial user profiles and current profile set');
    } catch (e, stackTrace) {
      print('Error setting initial profiles: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }

    // Wait a bit to ensure profiles are indexed
    await Future.delayed(const Duration(milliseconds: 100));

    dummyNotes.addAll([
      await PartialNote(
        'A new study on swipe actions shows that it cleans up interfaces like nothing else nostr:nevent1blablabla',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ).signWith(signer, withPubkey: niel.pubkey),
      await PartialNote(
        'I love Zaplab',
        createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
      ).signWith(signer, withPubkey: franzap.pubkey),
      await PartialNote(
        'A new study on swipe actions shows that it cleans up interfaces like nothing else.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ).signWith(signer, withPubkey: verbiricha.pubkey),
      await PartialNote(
        'I love that the UX is the same for all conversations in here. Chat, replies, threads, ... you can just swipe on them.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
      ).signWith(signer, withPubkey: zapchat.pubkey),
      await PartialNote(
        'Test Poast',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
      ).signWith(signer, withPubkey: zapchat.pubkey),
    ]);

    // Create community after profiles are saved and indexed
    final zapchatCommunity = await PartialCommunity(
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
    ).signWith(signer, withPubkey: zapchat.pubkey);
    final cypherchadsCommunity = await PartialCommunity(
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
      },
    ).signWith(signer, withPubkey: cypherchads.pubkey);
    final communikeysCommunity = await PartialCommunity(
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
    ).signWith(signer, withPubkey: communikeys.pubkey);
    final nipsoutCommunity = await PartialCommunity(
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
    ).signWith(signer, withPubkey: nipsout.pubkey);
    final metabolismCommunity = await PartialCommunity(
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
    ).signWith(signer, withPubkey: metabolism.pubkey);
    dummyCommunities.addAll([
      zapchatCommunity,
      cypherchadsCommunity,
      communikeysCommunity,
      nipsoutCommunity,
      metabolismCommunity,
    ]);
    // Create groups
    final theGangGroup = await PartialGroup(
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
    ).signWith(signer, withPubkey: thegang.pubkey);

    dummyGroups.addAll([
      theGangGroup,
    ]);

    // Chat messages
    dummyChatMessages.addAll([
      await PartialChatMessage(
        'Do you guys have pics from the farm visit??',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: franzap.pubkey),
      await PartialChatMessage(
        '''https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg
                      https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F28%2F55%2F58%2F285558f2c9d2865c7f46f197228a42f4.jpg
                      https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.sheknows.com%2Fwp-content%2Fuploads%2F2018%2F08%2Fmom-toddler-gardening_bp3w3w.jpeg''',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: verbiricha.pubkey),
      await PartialChatMessage(
        'https://cdn.satellite.earth/ce1ada957054c84e7dc95ecaa6b14ddb452f4ab31632903d74ffe83bc6c8ff38.mp3',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: zapchat.pubkey),
      await PartialChatMessage(
        'Awesome!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: niel.pubkey),
      await PartialChatMessage(
        ':beautiful:',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: niel.pubkey),
      await PartialChatMessage(
        'Yeah, this was a great way to get the families together.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: franzap.pubkey),
      await PartialChatMessage(
        'I was just about to say that.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: niel.pubkey),
      await PartialChatMessage(
        'Here\'s some more on that thing I said: nostr:nevent1blablabla',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        community: zapchatCommunity,
      ).signWith(signer, withPubkey: niel.pubkey),
    ]);

    dummyArticles.addAll([
      await (PartialArticle(
        'Zapchat For Dummies',
        'Content of the article',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        imageUrl:
            'https://cdn.satellite.earth/848413776358f99a9a90ebc2bac711262a76243795c95615d805dba0fd23c571.png',
        summary:
            'A brief introduction to a daily driver for Communities and Groups.',
      )).signWith(signer, withPubkey: zapchat.pubkey),
      await (PartialArticle(
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
      )).signWith(signer, withPubkey: niel.pubkey),
      await (PartialArticle(
        """Don't build on social, its a trap""",
        """To all existing nostr developers and new nostr developers, stop using kind 1 events... just stop whatever your doing and switch the kind to `Math.round(Math.random() * 10000)` trust me it will be better\n\n## What are kind 1 events\n\nkind 1 events are defined in [NIP-10](https://github.com/nostr-protocol/nips/blob/master/10.md) as \"simple plaintext notes\" or in other words social threads.\n\n## Don't trick your users\n\nMost users are joining nostr for the social experience, and secondly to find all the cool \"other stuff\" apps\nThey find friends, browse social threads, and reply to them. If a user signs into a new nostr client and it starts asking them to sign kind 1 events with blobs of JSON, they will sign it without thinking too much about it.\n\nThen when they return to their comfy social apps they will see that they made 10+ threads with massive amounts of gibberish that they don't remember threading. then they probably will go looking for the delete button and realize there isn't one...\n\nEven if those kind 1 threads don't contain JSON and have a nice fancy human readable syntax. they will still confuse users because they won't remember writing those social threads\n\n## What about \"discoverability\"\n\nIf your goal is to make your \"other stuff\" app visible to more users, then I would suggest using [NIP-19](https://github.com/nostr-protocol/nips/blob/master/19.md) and [NIP-89](https://github.com/nostr-protocol/nips/blob/master/89.md)\nThe first allows users to embed any other event kind into social threads as `nostr:nevent1` or `nostr:naddr1` links, and the second allows social clients to redirect users to an app that knows how to handle that specific kind of event\n\nSo instead of saving your apps data into kind 1 events. you can pick any kind you want, then give users a \"share on nostr\" button that allows them to compose a social thread (kind 1) with a `nostr:` link to your special kind of event and by extension you app\n\n## Why its a trap\n\nOnce users start using your app it becomes a lot more difficult to migrate to a new event kind or data format.\nThis sounds obvious, but If your app is built on kind 1 events that means you will be stuck with their limitations forever. \n\nFor example, here are some of the limitations of using kind 1\n - Querying for your apps data becomes much more difficult. You have to filter through all of a users kind 1 events to find which ones are created by your app\n - Discovering your apps data is more difficult for the same reason, you have to sift through all the social threads just to find the ones with you special tag or that contain JSON\n - Users get confused. as mentioned above users don't expect \"other stuff\" apps to be creating special social threads\n - Other nostr clients won't understand your data and will show it as a social thread with no option for users to learn about your app""",
        publishedAt: DateTime.now().subtract(const Duration(minutes: 20)),
        summary: 'As a developer, why you should not use kind 1 events.',
      )).signWith(signer, withPubkey: hzrd149.pubkey),
      await (PartialArticle(
        'Metabolic Health Foods You Can Find in Any Store',
        'Content of the third article',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        imageUrl:
            'https://cdn.satellite.earth/5b8e0002026a4bd0804d0470295dfd209ef9c461957a85f62e00e2923ff18bf1.png',
        summary:
            'A deep dive into foods that are good for your metabolic health and you can actually find in stores.',
      )).signWith(signer, withPubkey: metabolism.pubkey),
    ]);

    dummyBooks.addAll([
      await (PartialBook(
        'Eat Like A Human',
        'Content of the book',
        writer: 'Bill Schindler',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.hachettebookgroup.com%2Fwp-content%2Fuploads%2F2021%2F09%2F9780316244886.jpg',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).signWith(signer, withPubkey: franzap.pubkey),
      await (PartialBook(
        'In Search Of The Physical Basis Of Life',
        'Content of the book',
        writer: 'Gilbert Ling',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fnwf-bucket.s3.me-south-1.amazonaws.com%2Fimages%2Fae%2Fabookstore%2Fcovers%2Fnormal%2F315%2F315121.jpg',
      )).signWith(signer, withPubkey: franzap.pubkey),
      await (PartialBook(
        'En quête d\'amour',
        'Content of the book',
        writer: 'Anneke Lucas',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.squarespace-cdn.com%2Fcontent%2Fv1%2F59ab4dedc027d8465d8c085c%2F07cc0908-7279-4dcf-a85f-cca89fc8a245%2FGUQyi3xWoAAIAW3.jpg',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      )).signWith(signer, withPubkey: niel.pubkey),
      await (PartialBook(
        'A Book with a surprsingly long title that is here to test text overflow',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).signWith(signer, withPubkey: franzap.pubkey),
      await (PartialBook(
        'Bokk Title One',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).signWith(signer, withPubkey: franzap.pubkey),
      await (PartialBook(
        'Book Title Two',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).signWith(signer, withPubkey: franzap.pubkey),
      await (PartialBook(
        'Book Title Three',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).signWith(signer, withPubkey: franzap.pubkey),
      await (PartialBook(
        'Book Title Four',
        'Content of the book',
        writer: 'Author Name',
        imageUrl:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F55%2Fb1%2Fb5%2F55b1b5dbf1488a572f8aa37b0388d321.jpg&f=1&nofb=1&ipt=43e93f320b6e77480745c65d2b398a1ea50160090f58fc662cf980b64fe76c87',
      )).signWith(signer, withPubkey: franzap.pubkey),
    ]);

    // Save all data
    print('Saving data to storage...');
    await ref.read(storageNotifierProvider.notifier).save(Set.from([
          ...dummyProfiles,
          ...dummyNotes,
          ...dummyArticles,
          ...dummyChatMessages,
          ...dummyCommunities,
          ...dummyGroups,
          ...dummyBooks,
        ]));
    print('Data saved successfully');

    return true;
  } catch (e, stackTrace) {
    print('Error during initialization: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
