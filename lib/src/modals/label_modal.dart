import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';
import '../providers/search.dart';

class LabelModal extends ConsumerStatefulWidget {
  final Model model;

  const LabelModal({
    super.key,
    required this.model,
  });

  @override
  ConsumerState<LabelModal> createState() => _LabelModalState();
}

class _LabelModalState extends ConsumerState<LabelModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Request focus after modal is built
    Future.microtask(() => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onContentChanged(String content) {
    // Update the controller's text
    if (_controller.text != content) {
      _controller.text = content;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: content.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabInputModal(
      children: [
        const LabGap.s8(),
        LabText.h1("Label"),
        const LabGap.s12(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LabEmojiContentType(
                contentType: getModelContentType(widget.model),
                size: theme.sizes.s24),
            const LabGap.s8(),
            LabText.reg16("${getModelName(widget.model)} by ",
                color: theme.colors.white66),
            LabText.bold16("${widget.model.author.value?.name}",
                color: theme.colors.white66),
          ],
        ),
        const LabGap.s24(),
        LabInputTextField(
          controller: _controller,
          focusNode: _focusNode,
          placeholder: 'Search / Add Label',
          onChanged: _onContentChanged,
        ),
        const LabGap.s4(),
        LabContainer(
          width: double.infinity,
          padding: const LabEdgeInsets.all(LabGapSize.s8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  LabLabel(
                    "Urgent",
                    onTap: () {},
                  ),
                  LabLabel(
                    "Marketing",
                    onTap: () {},
                  ),
                  LabLabel(
                    "Bugs",
                    onTap: () {},
                  ),
                  LabLabel(
                    "R&D",
                    onTap: () {},
                  ),
                  LabLabel(
                    "Big Picture",
                    onTap: () {},
                  ),
                  LabLabel(
                    "Design",
                    onTap: () {},
                  ),
                  LabLabel(
                    "Would Be Nice",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
