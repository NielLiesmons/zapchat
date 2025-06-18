import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';
import '../providers/search.dart';

class CreateMessageModal extends ConsumerStatefulWidget {
  final Model target;
  const CreateMessageModal({
    required this.target,
    super.key,
  });

  @override
  ConsumerState<CreateMessageModal> createState() => _CreateMessageModalState();
}

class _CreateMessageModalState extends ConsumerState<CreateMessageModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  // ignore: unused_field
  late PartialChatMessage _partialMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _partialMessage = PartialChatMessage('');

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
    setState(() {
      _partialMessage = PartialChatMessage(content);
    });
    // Update the controller's text
    if (_controller.text != content) {
      _controller.text = content;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: content.length),
      );
    }
  }

  void _sendMessage() async {
    final text = _controller.text;
    final signer = ref.read(Signer.activeSignerProvider)!;

    if (text.isNotEmpty) {
      final message = PartialChatMessage(
        text,
        createdAt: DateTime.now(),
      );
      final signedMessage = await message.signWith(signer);
      await ref.read(storageNotifierProvider.notifier).save({signedMessage});
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabInputModal(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              LabKeyboardSubmitHandler(
                onSubmit: _sendMessage,
                child: LabShortTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  placeholder: [
                    LabText.reg16(
                      'Your Message',
                      color: theme.colors.white33,
                    ),
                  ],
                  onSearchProfiles: ref.read(searchProvider).profileSearch,
                  onSearchEmojis: ref.read(searchProvider).emojiSearch,
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                  onCameraTap: () {}, // TODO: Implement camera tap
                  onEmojiTap: () {}, // TODO: Implement emoji tap
                  onGifTap: () {}, // TODO: Implement gif tap
                  onAddTap: () {}, // TODO: Implement add tap
                  onSendTap: _sendMessage,
                  onChevronTap: () {}, // TODO: Implement chevron tap
                  onProfileTap: (profile) =>
                      context.push('/profile/${profile.npub}', extra: profile),
                  onChanged: _onContentChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
