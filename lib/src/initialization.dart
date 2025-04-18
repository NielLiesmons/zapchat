import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zapchat/src/providers/user_profiles.dart';

final zapchatInitializationProvider = FutureProvider<bool>((ref) async {
  try {
    await ref.read(initializationProvider(
      StorageConfiguration(
        databasePath: '',
        relayGroups: {},
        defaultRelayGroup: '',
      ),
    ).future);
    print('Models initialized');

    final dummyProfiles = <Profile>[];
    final dummyNotes = <Note>[];
    final dummyChatMessages = <ChatMessage>[];
    final dummyArticles = <Article>[];
    final dummyCommunities = <Community>[];

    print('Creating signer...');
    final signer = DummySigner();
    print('Signer created');

    print('Creating profiles...');
    final zapchat = await PartialProfile(
      name: 'Zapchat',
      pictureUrl:
          'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png',
    ).signWith(signer,
        withPubkey:
            'edb470271297ac5a61f277f3cd14de54c67eb5ccd20ef0d9df29be18685bb004');
    print(
        'Zapchat profile created - name: ${zapchat.name}, pubkey: ${zapchat.pubkey}, pictureUrl: ${zapchat.pictureUrl}');

    final zapstore = await PartialProfile(
      name: 'Zapstore',
      pictureUrl:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.architecturaldigest.in%2Fwp-content%2Fuploads%2F2019%2F04%2FNorth-Rose-window-notre-dame-paris.jpg&f=1&nofb=1&ipt=b915d5a064b905567aa5fe9fbc8c38da207c4ba007316f5055e3e8cb1a009aa8&ipo=images',
    ).signWith(signer,
        withPubkey:
            '27487c9600b16b24a1bfb0519cfe4a5d1ad84959e3cce5d6d7a99d48660a1f78');
    print(
        'Zapstore profile created - name: ${zapstore.name}, pubkey: ${zapstore.pubkey}, pictureUrl: ${zapstore.pictureUrl}');

    final niel = await PartialProfile(
      name: 'Niel Liesmons',
      pictureUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
    ).signWith(signer,
        withPubkey:
            'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be');
    print(
        'Niel profile created - name: ${niel.name}, pubkey: ${niel.pubkey}, pictureUrl: ${niel.pictureUrl}');

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
          'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
    ).signWith(signer,
        withPubkey:
            '7fa56f5d69645b1e3cd424e758c3002b8665f7b0d8dcee9fe9e288d7751ac194');
    print(
        'Verbiricha profile created - name: ${verbiricha.name}, pubkey: ${verbiricha.pubkey}, pictureUrl: ${verbiricha.pictureUrl}');

    dummyProfiles
        .addAll([zapchat, niel, zapstore, cypherchads, franzap, verbiricha]);

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
          content: 'Posts',
          kinds: {1},
        ),
        CommunityContentSection(
          content: 'Articles',
          kinds: {30023},
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
          content: 'Posts',
          kinds: {1},
        ),
      },
    ).signWith(signer, withPubkey: cypherchads.pubkey);
    dummyCommunities.addAll([zapchatCommunity, cypherchadsCommunity]);

    // //Chat messages
    // dummyChatMessages.addAll([
    //   await PartialChatMessage(
    //     'Ow, I see. This is not just a chat app, is it?',
    //     createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    //     community: zapchatCommunity,
    //   ).signWith(signer, withPubkey: cypherchads.pubkey),
    //   await PartialChatMessage(
    //     '''https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fgardening-season-little-baby-watches-as-his-mother-waters-flowers-watering-can-vertical-family-concept-246956758.jpg
    //                   https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F28%2F55%2F58%2F285558f2c9d2865c7f46f197228a42f4.jpg
    //                   https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.sheknows.com%2Fwp-content%2Fuploads%2F2018%2F08%2Fmom-toddler-gardening_bp3w3w.jpeg''',
    //     createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    //     community: zapchatCommunity,
    //   ).signWith(signer, withPubkey: zapchat.pubkey),
    //   await PartialChatMessage(
    //     'Yeah, loving the UX',
    //     createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
    //     community: zapchatCommunity,
    //   ).signWith(signer, withPubkey: verbiricha.pubkey),
    //   await PartialChatMessage(
    //     'This is awesome!',
    //     createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    //     community: zapchatCommunity,
    //   ).signWith(signer, withPubkey: verbiricha.pubkey),
    // ]);

    // dummyArticles.addAll([
    //   await (PartialArticle(
    //     'A new study on swipe actions shows that it cleans up interfaces like nothing else.',
    //     'A new study on swipe actions shows that it cleans up interfaces like nothing else.',
    //     publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    //   )..internal.addTagValue('image',
    //           'https://cdn.satellite.earth/307b087499ae5444de1033e62ac98db7261482c1531e741afad44a0f8f9871ee.png'))
    //       .signWith(signer, withPubkey: verbiricha.pubkey),
    // ]);

    // Save all data
    print('Saving data to storage...');
    await ref.read(storageNotifierProvider.notifier).save(Set.from([
          ...dummyProfiles,
          ...dummyNotes,
          // ...dummyArticles,
          // ...dummyChatMessages,
          ...dummyCommunities,
        ]));
    print('Data saved successfully');

    return true;
  } catch (e, stackTrace) {
    print('Error during initialization: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
