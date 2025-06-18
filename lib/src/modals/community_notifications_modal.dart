import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

// TODO: Get actual notifications from the specific community

class CommunityNotificationsModal extends ConsumerWidget {
  final Community community;

  const CommunityNotificationsModal({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);

    return LabModal(
      title: "Notifications",
      description: "For ${community.name}",
      children: [
        const LabGap.s8(),
        LabSelector(
          emphasized: true,
          children: [
            LabSelectorButton(
              selectedContent: [
                LabIcon.s16(
                  theme.icons.characters.bell,
                  color: theme.colors.whiteEnforced,
                ),
                LabGap.s8(),
                LabText.med14('21', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                LabIcon.s16(
                  theme.icons.characters.bell,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14('21', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [
                LabIcon.s16(
                  theme.icons.characters.reply,
                  outlineColor: theme.colors.whiteEnforced,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14(
                  '12',
                  color: theme.colors.whiteEnforced,
                ),
              ],
              unselectedContent: [
                LabIcon.s16(
                  theme.icons.characters.reply,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14('12', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [
                LabIcon.s18(
                  theme.icons.characters.zap,
                  color: theme.colors.whiteEnforced,
                ),
                LabGap.s8(),
                LabText.med14('5', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                LabIcon.s18(
                  theme.icons.characters.zap,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14('5', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [
                LabIcon.s18(
                  theme.icons.characters.at,
                  outlineColor: theme.colors.whiteEnforced,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14('2', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                LabIcon.s18(
                  theme.icons.characters.at,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14('2', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            LabSelectorButton(
              selectedContent: [
                LabIcon.s18(
                  theme.icons.characters.emojiFill,
                  color: theme.colors.whiteEnforced,
                ),
                LabGap.s8(),
                LabText.med14('2', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                LabIcon.s18(
                  theme.icons.characters.emojiLine,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
                LabGap.s8(),
                LabText.med14('2', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
          ],
          onChanged: (index) {},
        ),
        const LabGap.s12(),
        LabNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `LabScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const LabGap.s8(),
        LabNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `LabScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const LabGap.s8(),
        LabNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `LabScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const LabGap.s8(),
        LabNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `LabScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const LabGap.s8(),
        LabNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `LabScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const LabGap.s8(),
        LabNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `LabScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
      ],
    );
  }
}
