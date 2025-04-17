import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/providers/current_profile.dart';
import 'package:zapchat/src/providers/user_profiles.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProfile = ref.watch(currentProfileProvider);
    final userProfiles = ref.watch(userProfilesProvider);

    if (currentProfile == null && userProfiles.isNotEmpty) {
      ref
          .read(currentProfileProvider.notifier)
          .setProfile(userProfiles.first.profile);
    }

    if (currentProfile == null) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    return AppSettingsScreen(
      currentProfile: currentProfile,
      profiles: userProfiles.map((up) => up.profile).toList(),
      onSelect: (profile) {
        ref.read(currentProfileProvider.notifier).setProfile(profile);
      },
      onAddProfile: () => context.push('/settings/get-started'),
      onHomeTap: () => context.pop(),
      onHistoryTap: () => context.push('/settings/history'),
      historyDescription: 'Last activity 12m ago',
      onDraftsTap: () => context.push('/settings/drafts'),
      draftsDescription: '21 Drafts',
      onLabelsTap: () => context.push('/settings/labels'),
      labelsDescription: '21 Public, 34 Private',
      onAppearanceTap: () => context.push('/settings/appearance'),
      appearanceDescription: 'Dark theme, Normal text',
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
