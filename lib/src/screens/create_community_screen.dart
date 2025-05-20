import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({
    super.key,
  });

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Request focus after screen is built
    Future.microtask(() => _searchFocusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        onHomeTap: () => Navigator.of(context).pop(),
        alwaysShowTopBar: true,
        topBarContent: AppContainer(
          padding: const AppEdgeInsets.symmetric(
            vertical: AppGapSize.s4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppGap.s8(),
                  AppText.med14('New Community'),
                  const AppGap.s12(),
                  const Spacer(),
                  AppSmallButton(
                    onTap: () {},
                    rounded: true,
                    children: [
                      const AppGap.s4(),
                      AppText.med14('Next'),
                      const AppGap.s4(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        child: AppContainer(
          padding: const AppEdgeInsets.symmetric(
            horizontal: AppGapSize.s12,
          ),
          child: Column(
            children: [
              const AppGap.s64(),
              AppText.h1('// TODO'),
              const AppGap.s12(),
              AppText.med14(
                  'We should have 1) use existing profile 2) spin up new profile'),
            ],
          ),
        ));
  }
}
