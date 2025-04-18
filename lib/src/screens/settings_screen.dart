import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/providers/user_profiles.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfilesState = ref.watch(userProfilesProvider);

    if (userProfilesState.isLoading) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    final (profiles, currentProfile) = userProfilesState.value!;

    if (currentProfile == null && profiles.isNotEmpty) {
      // If no current profile but we have user profiles, set the first one
      ref.read(userProfilesProvider.notifier).setCurrentProfile(profiles.first);
    }

    if (currentProfile == null) {
      return const Center(
        child: AppLoadingDots(),
      );
    }

    return AppSettingsScreen(
      currentProfile: currentProfile,
      profiles: profiles,
      onSelect: (profile) {
        ref.read(userProfilesProvider.notifier).setCurrentProfile(profile);
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
