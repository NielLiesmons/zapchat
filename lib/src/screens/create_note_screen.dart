import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';
import '../providers/search.dart';

class CreateNoteScreen extends ConsumerStatefulWidget {
  const CreateNoteScreen({
    super.key,
  });

  @override
  ConsumerState<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends ConsumerState<CreateNoteScreen> {
  bool _hasRequiredFields = false;
  List<LongTextElement> _elements = [];

  @override
  void initState() {
    super.initState();
    // Start with a single paragraph element
    _elements = [
      LongTextElement(
        type: LongTextElementType.paragraph,
        content: '',
      ),
    ];
  }

  void _updateHasRequiredFields() {
    setState(() {
      _hasRequiredFields =
          _elements.any((element) => element.content.isNotEmpty);
    });
  }

  void _onElementsChanged(List<LongTextElement> elements) {
    setState(() {
      _elements = elements;
    });
    _updateHasRequiredFields();
  }

  void _onShareTap() {
    if (_hasRequiredFields) {
      context.push(
        '/share/note',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final resolvers = ref.watch(resolversProvider);
    final search = ref.watch(searchProvider);

    return LabScreen(
      onHomeTap: () => context.pop(),
      alwaysShowTopBar: true,
      topBarContent: LabContainer(
        padding: const LabEdgeInsets.symmetric(
          vertical: LabGapSize.s4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LabGap.s8(),
                LabText.med14('Create Note'),
                const LabGap.s12(),
                const Spacer(),
                LabKeyboardSubmitHandler(
                  onSubmit: _hasRequiredFields ? _onShareTap : () {},
                  enabled: _hasRequiredFields,
                  child: LabSmallButton(
                    onTap: _onShareTap,
                    rounded: true,
                    gradient: _hasRequiredFields
                        ? theme.colors.blurple
                        : theme.colors.blurple33,
                    children: [
                      const LabGap.s4(),
                      LabText.med14(
                        'Share',
                        color: _hasRequiredFields
                            ? theme.colors.white
                            : theme.colors.white66,
                      ),
                      const LabGap.s4(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LabGap.s48(),
          const LabGap.s2(),
          LabContainer(
            height: MediaQuery.of(context).size.height / theme.system.scale -
                80 -
                MediaQuery.of(context).viewInsets.bottom,
            padding: const LabEdgeInsets.all(
              LabGapSize.s16,
            ),
            child: Column(
              children: [
                // TODO: Change to long text WYSIWYG Editor
                LabShortTextField(
                  onEmojiTap: () {},
                  onGifTap: () {},
                  onAddTap: () {},
                  onProfileTap: (profile) {},
                  onCameraTap: () {},
                  onResolveEvent: resolvers.eventResolver,
                  onResolveProfile: resolvers.profileResolver,
                  onResolveEmoji: resolvers.emojiResolver,
                  onSearchProfiles: search.profileSearch,
                  onSearchEmojis: search.emojiSearch,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
