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

  void _shareContent(
      BuildContext context, String content, String successMessage) {
    final theme = LabTheme.of(context);
    Clipboard.setData(ClipboardData(text: content));
    Navigator.pop(context);
    LabToast.show(
      context,
      children: [
        const LabGap.s4(),
        LabContainer(
          height: theme.sizes.s32,
          width: theme.sizes.s32,
          decoration: BoxDecoration(
            gradient: theme.colors.blurple66,
            borderRadius: theme.radius.asBorderRadius().rad12,
          ),
          child: Center(
            child: LabIcon.s12(theme.icons.characters.check,
                outlineColor: theme.colors.whiteEnforced,
                outlineThickness: LabLineThicknessData.normal().thick),
          ),
        ),
        const LabGap.s16(),
        LabText.reg14(successMessage)
      ],
    );
  }

  String _getEncodedIdentifier() {
    if (model is ReplaceableModel || model is ParameterizableReplaceableModel) {
      return Utils.encodeShareableFromString(model.event.id, type: 'naddr');
    }
    return Utils.encodeShareableFromString(model.event.id, type: 'nevent');
  }

  void _shareId(BuildContext context) {
    final encodedId = _getEncodedIdentifier();
    _shareContent(context, encodedId, 'Identifier copied to clipboard');
  }

  void _shareLink(BuildContext context) {
    final encodedId = _getEncodedIdentifier();
    final link = 'https://njump.me/$encodedId';
    _shareContent(context, link, 'Link copied to clipboard');
  }

  void _shareRawCode(BuildContext context) {
    final rawEvent = model.event.toMap();
    final jsonString = rawEvent.toString();
    _shareContent(context, jsonString, 'Raw event copied to clipboard');
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
                    LabIcon.s24(theme.icons.characters.id,
                        outlineColor: theme.colors.blurpleLightColor,
                        outlineThickness: LabLineThicknessData.normal().medium),
                    const LabGap.s8(),
                    LabText.med14(
                      "ID",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Copy the Identifier",
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LabIcon.s24(theme.icons.characters.link,
                        outlineColor: theme.colors.blurpleLightColor,
                        outlineThickness: LabLineThicknessData.normal().medium),
                    const LabGap.s8(),
                    LabText.med14(
                      "Link",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Copy the Web Link",
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LabIcon.s24(theme.icons.characters.code,
                        outlineColor: theme.colors.blurpleLightColor,
                        outlineThickness: LabLineThicknessData.normal().medium),
                    const LabGap.s8(),
                    LabText.med14(
                      "Code",
                    ),
                    const LabGap.s4(),
                    LabText.reg12(
                      "Copy the Raw JSON",
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
