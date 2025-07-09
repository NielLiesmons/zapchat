import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityProductsFeed extends ConsumerWidget {
  final Community community;

  const CommunityProductsFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<Product>());

    if (state case StorageLoading()) {
      return const LabLoadingFeed();
    }

    final products = state.models.cast<Product>();

    return LabContainer(
      child: Column(
        children: [
          for (final product in products)
            Column(
              children: [
                // LabFeedProduct(
                //   service: service,
                //   isUnread: true,
                //   onTap: (model) =>
                //       context.push('/service/${model.id}', extra: model),
                //   onProfileTap: (profile) =>
                //       context.push('/service/${profile.npub}', extra: profile),
                // ),
              ],
            ),
        ],
      ),
    );
  }
}
