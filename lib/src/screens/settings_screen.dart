import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import '../providers/theme_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInPubkeys = ref.watch(Signer.signedInPubkeysProvider);
    final activePubkey = ref.watch(Signer.activePubkeyProvider);
    print('[DEBUG] activePubkey: $activePubkey');
    final activeProfile =
        ref.watch(Signer.activeProfileProvider(LocalAndRemoteSource()));
    final themeState = ref.watch(themeSettingsProvider);

    if (signedInPubkeys.isEmpty) {
      return const Center(
        child: LabLoadingDots(),
      );
    }

    final profilesState = ref.watch(query<Profile>(authors: signedInPubkeys));

    if (profilesState case StorageLoading()) {
      return const Center(
        child: LabLoadingDots(),
      );
    }

    final profiles = profilesState is StorageData<Profile>
        ? profilesState.models
        : <Profile>[];
    final profilePubkeys = profiles.map((p) => p.pubkey).toSet();
    final incompleteProfilePubkeys =
        signedInPubkeys.where((k) => !profilePubkeys.contains(k)).toList();

    final themeMode =
        themeState.value?.colorMode ?? LabResponsiveTheme.colorModeOf(context);
    final textScale = themeState.value?.textScale ?? LabTextScale.normal;

    return LabSettingsScreen(
      activeProfile: activeProfile,
      activePubkey: activePubkey,
      profiles: profiles,
      incompleteProfilePubkeys: incompleteProfilePubkeys,
      onSelect: (profile) {
        print('[DEBUG] onSelect called for pubkey: ${profile.pubkey}');
        ref.read(Signer.signerProvider(profile.pubkey))?.setAsActivePubkey();
      },
      onSelectIncomplete: (pubkey) {
        print('[DEBUG] onSelectIncomplete called for pubkey: $pubkey');
        ref.read(Signer.signerProvider(pubkey))?.setAsActivePubkey();
      },
      onViewProfile: (profile) =>
          context.push('/profile/${profile.npub}', extra: profile),
      onAddProfile: () => context.push('/settings/add-profile'),
      onHomeTap: () => context.pop(),
      onHistoryTap: () => context.push('/settings/history'),
      historyDescription: 'Last activity 12m ago',
      onDraftsTap: () => context.push('/settings/drafts'),
      draftsDescription: '21 Drafts',
      onLabelsTap: () => context.push('/settings/labels'),
      labelsDescription: '21 Public, 34 Private',
      onPreferencesTap: () => context.push('/settings/appearance'),
      preferencesDescription:
          '${themeMode.name.capitalize()} theme, ${textScale.name.capitalize()} text',
      onHostingTap: () => context.push('/settings/hosting'),
      hostingDescription: '47.5 GB / 100 GB',
      hostingStatuses: [
        HostingStatus.online,
        HostingStatus.warning,
        HostingStatus.offline,
      ],
      onSignerTap: () => context.push('/settings/security'),
      signerDescription: 'Secure mode, Keys are backed up',
      onInviteTap: () => context.push('/settings/invite'),
      onDisconnectTap: () async {
        await LabConfirmationModal.show(
          context,
          description: activeProfile != null
              ? 'Disconnect ${activeProfile.name}'
              : activePubkey != null
                  ? 'Disconnect ${formatNpub(Utils.encodeShareableFromString(activePubkey, type: 'npub'))}'
                  : 'Disconnect',
          onConfirm: () async {
            final signer = ref.read(Signer.activeSignerProvider);
            if (signer != null) {
              await signer.signOut();
            }
            context.go('/');
          },
        );
      },
    );
  }
}
