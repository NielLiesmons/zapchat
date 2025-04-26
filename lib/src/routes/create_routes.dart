import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../modals/create_new_stuff_modal.dart';

List<GoRoute> get createRoutes => [
      GoRoute(
        path: '/create',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: CreateNewStuffModal(),
          );
        },
      ),
    ];
