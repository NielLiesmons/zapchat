import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class ShareModal extends ConsumerWidget {
  final Model model;

  const ShareModal({
    super.key,
    required this.model,
  });

  void _shareId(BuildContext context) {
    final eventId = model.event.id;
    Clipboard.setData(ClipboardData(text: eventId));
    LabToast.show(
      context,
      children: [LabText.reg14('Event ID copied to clipboard')],
    );
  }

  void _shareLink(BuildContext context) {
    final eventId = model.event.id;
    final link = 'https://nostr.com/e/$eventId';
    Clipboard.setData(ClipboardData(text: link));
    LabToast.show(
      context,
      children: [LabText.reg14('Link copied to clipboard')],
    );
  }

  void _shareRawCode(BuildContext context) {
    final rawEvent = model.event.toMap();
    final jsonString = rawEvent.toString();
    Clipboard.setData(ClipboardData(text: jsonString));
    LabToast.show(
      context,
      children: [LabText.reg14('Raw event copied to clipboard')],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = LabTheme.of(context);

    return LabModal(
      title: "Share",
      description: "Choose how to share this content",
      children: [
        const LabGap.s12(),
        Row(
          children: [
            Expanded(
              child: LabPanelButton(
                onTap: () => _shareId(context),
                isLight: true,
                child: Column(
                  children: [
                    LabIcon.s32(theme.icons.characters.copy,
                        outlineColor: theme.colors.blurpleLightColor,
                        outlineThickness: LabLineThicknessData.normal().medium),
                    const LabGap.s8(),
                    LabText.med16(
                      "ID",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Copy Event ID",
                      color: theme.colors.white66,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const LabGap.s12(),
            Expanded(
              child: LabPanelButton(
                onTap: () => _shareLink(context),
                isLight: true,
                child: Column(
                  children: [
                    LabIcon.s32(theme.icons.characters.link,
                        outlineColor: theme.colors.blurpleLightColor,
                        outlineThickness: LabLineThicknessData.normal().medium),
                    const LabGap.s8(),
                    LabText.med16(
                      "Link",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Copy Web Link",
                      color: theme.colors.white66,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const LabGap.s12(),
            Expanded(
              child: LabPanelButton(
                onTap: () => _shareRawCode(context),
                isLight: true,
                child: Column(
                  children: [
                    LabIcon.s32(theme.icons.characters.code,
                        outlineColor: theme.colors.blurpleLightColor,
                        outlineThickness: LabLineThicknessData.normal().medium),
                    const LabGap.s8(),
                    LabText.med16(
                      "Raw Code",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Copy JSON",
                      color: theme.colors.white66,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const LabGap.s4(),
      ],
    );
  }
}
