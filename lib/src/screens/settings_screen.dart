import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/providers/user_profiles.dart';
import 'package:zapchat/src/providers/theme_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfilesState = ref.watch(userProfilesProvider);
    final themeState = ref.watch(themeSettingsProvider);

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

    final themeMode =
        themeState.value?.colorMode ?? AppResponsiveTheme.colorModeOf(context);
    final textScale = themeState.value?.textScale ?? AppTextScale.normal;

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
