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
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Notifications",
      description: "For ${community.name}",
      children: [
        const AppGap.s8(),
        AppSelector(
          emphasized: true,
          children: [
            AppSelectorButton(
              selectedContent: [
                AppIcon.s16(
                  theme.icons.characters.bell,
                  color: theme.colors.whiteEnforced,
                ),
                AppGap.s8(),
                AppText.med14('21', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                AppIcon.s16(
                  theme.icons.characters.bell,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('21', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [
                AppIcon.s16(
                  theme.icons.characters.reply,
                  outlineColor: theme.colors.whiteEnforced,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14(
                  '12',
                  color: theme.colors.whiteEnforced,
                ),
              ],
              unselectedContent: [
                AppIcon.s16(
                  theme.icons.characters.reply,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('12', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [
                AppIcon.s18(
                  theme.icons.characters.zap,
                  color: theme.colors.whiteEnforced,
                ),
                AppGap.s8(),
                AppText.med14('5', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                AppIcon.s18(
                  theme.icons.characters.zap,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('5', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [
                AppIcon.s18(
                  theme.icons.characters.at,
                  outlineColor: theme.colors.whiteEnforced,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('2', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                AppIcon.s18(
                  theme.icons.characters.at,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('2', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: [
                AppIcon.s18(
                  theme.icons.characters.emojiFill,
                  color: theme.colors.whiteEnforced,
                ),
                AppGap.s8(),
                AppText.med14('2', color: theme.colors.whiteEnforced),
              ],
              unselectedContent: [
                AppIcon.s18(
                  theme.icons.characters.emojiLine,
                  outlineColor: theme.colors.white33,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('2', color: theme.colors.white33),
              ],
              isSelected: true,
              onTap: () {},
            ),
          ],
          onChanged: (index) {},
        ),
        const AppGap.s12(),
        AppNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
            createdAt: DateTime.now(),
          ).dummySign(),
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          model: PartialNote(
            'This is a :emeoji: Nostr note. Just for testing, nothing special. \n\nIt\'s mainly to test the top bar of the `AppScreen` widget of the Zaplab design package.',
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
