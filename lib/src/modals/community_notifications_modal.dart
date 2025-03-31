import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';

class CommunityNotificationsModal extends ConsumerWidget {
  const CommunityNotificationsModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: "Notifications",
      children: [
        const AppGap.s8(),
        AppSelector(
          emphasized: true,
          children: [
            AppSelectorButton(
              selectedContent: [
                AppIcon.s16(
                  theme.icons.characters.bell,
                  color: AppColorsData.dark().white,
                ),
                AppGap.s8(),
                AppText.med14('21', color: AppColorsData.dark().white),
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
                  outlineColor: AppColorsData.dark().white,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14(
                  '12',
                  color: AppColorsData.dark().white,
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
                  color: AppColorsData.dark().white,
                ),
                AppGap.s8(),
                AppText.med14('5', color: AppColorsData.dark().white),
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
                  outlineColor: AppColorsData.dark().white,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
                AppGap.s8(),
                AppText.med14('2', color: AppColorsData.dark().white),
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
                  color: AppColorsData.dark().white,
                ),
                AppGap.s8(),
                AppText.med14('2', color: AppColorsData.dark().white),
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
          nevent: "fghjk",
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          nevent: "fghjk",
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          nevent: "fghjk",
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          nevent: "fghjk",
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          nevent: "fghjk",
          onActions: (nevent) {
            print(nevent);
          },
          onReply: (nevent) {
            print(nevent);
          },
        ),
        const AppGap.s8(),
        AppNotificationCard(
          nevent: "fghjk",
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
