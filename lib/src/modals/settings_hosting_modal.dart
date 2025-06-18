import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../routes/event_routes.dart';

class SettingsHostingModal extends ConsumerWidget {
  const SettingsHostingModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);

    return LabModal(
      title: "Hosting",
      children: [
        const LabGap.s8(),
        LabHostingCard(
          name: 'Zapcloud',
          type: 'Pro',
          usedStorage: 45.7,
          totalStorage: 100.0,
          services: [
            HostingService(
              name: 'Your Mailbox',
              description: 'Nostr Relay',
              status: HostingStatus.online,
              onAdjust: () {
                // Handle Mailbox Relay adjustment
              },
            ),
            HostingService(
              name: 'Your Content',
              description: "Nostr Relay",
              status: HostingStatus.offline,
              onAdjust: () {
                // Handle Private Relay adjustment
              },
            ),
            HostingService(
              name: 'Your Media',
              description: 'Blossom Server',
              status: HostingStatus.warning,
              onAdjust: () {
                // Handle Media Server adjustment
              },
            ),
          ],
        ),
        const LabGap.s12(),
        LabPanelButton(
          child: Column(
            children: [
              LabContainer(
                width: theme.sizes.s48,
                height: theme.sizes.s48,
                decoration: BoxDecoration(
                  color: theme.colors.white8,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: LabIcon.s20(
                    theme.icons.characters.plus,
                    outlineThickness: LabLineThicknessData.normal().thick,
                    outlineColor: theme.colors.white33,
                  ),
                ),
              ),
              const LabGap.s12(),
              LabText.med14(
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
