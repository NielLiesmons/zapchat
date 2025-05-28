import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../routes/event_routes.dart';

class SettingsHostingModal extends ConsumerWidget {
  const SettingsHostingModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Hosting",
      children: [
        const AppGap.s8(),
        AppHostingCard(
          name: 'Zapcloud',
          usedStorage: 45.7,
          totalStorage: 100.0,
          services: [
            HostingService(
              name: 'Mailbox Relay',
              status: HostingStatus.online,
              onAdjust: () {
                // Handle Mailbox Relay adjustment
              },
            ),
            HostingService(
              name: 'Media Server',
              status: HostingStatus.warning,
              onAdjust: () {
                // Handle Media Server adjustment
              },
            ),
            HostingService(
              name: 'Private Relay',
              status: HostingStatus.offline,
              onAdjust: () {
                // Handle Private Relay adjustment
              },
            ),
          ],
        ),
        const AppGap.s12(),
        AppPanelButton(
          child: Column(
            children: [
              AppContainer(
                width: theme.sizes.s48,
                height: theme.sizes.s48,
                decoration: BoxDecoration(
                  color: theme.colors.white8,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcon.s20(
                    theme.icons.characters.plus,
                    outlineThickness: AppLineThicknessData.normal().thick,
                    outlineColor: theme.colors.white33,
                  ),
                ),
              ),
              const AppGap.s12(),
              AppText.med14(
                'Add a Hosting solution',
                color: theme.colors.white33,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
