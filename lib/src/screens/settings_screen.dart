import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:zapchat/src/providers/theme_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInPubkeys = ref.watch(Signer.signedInPubkeysProvider);
    final currentProfile = ref.watch(Signer.activeProfileProvider);
    final themeState = ref.watch(themeSettingsProvider);

    if (signedInPubkeys.isEmpty) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    final state = ref.watch(query<Profile>(authors: signedInPubkeys));

    if (state case StorageLoading()) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    final profiles = state.models.cast<Profile>();

    if (profiles.isEmpty) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    if (currentProfile == null && profiles.isNotEmpty) {
      // If no current profile but we have user profiles, set the first one
      ref.read(Signer.signerProvider(profiles.first.pubkey))?.setActive();
    }

    if (currentProfile == null) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    final themeMode =
        themeState.value?.colorMode ?? AppResponsiveTheme.colorModeOf(context);
    final textScale = themeState.value?.textScale ?? AppTextScale.normal;

    return AppSettingsScreen(
      currentProfile: currentProfile,
      profiles: profiles,
      onSelect: (profile) {
        ref.read(Signer.signerProvider(profile.pubkey))?.setActive();
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
      onAppearanceTap: () => context.push('/settings/appearance'),
      appearanceDescription:
          '${themeMode.name.capitalize()} theme, ${textScale.name.capitalize()} text',
      onHostingTap: () => context.push('/settings/hosting'),
      hostingDescription: '21 GB on 3 Relays, 2 Servers',
      onSecurityTap: () => context.push('/settings/security'),
      securityDescription: 'Secure mode, Keys are backed up',
      onOtherDevicesTap: () => context.push('/settings/other-devices'),
      otherDevicesDescription: 'Last activity 12m ago',
      onInviteTap: () => context.push('/settings/invite'),
      onDisconnectTap: () => context.push('/settings/disconnect'),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
