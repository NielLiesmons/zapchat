import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Notes',
      icon: const LabEmojiContentType(contentType: 'note'),
      content: Consumer(
        builder: (context, ref, _) {
          final notes = [];

          return Column(
            children: [
              notes.isNotEmpty
                  ? Column(children: [SizedBox.shrink()])
                  : LabContainer(
                      padding: const LabEdgeInsets.all(LabGapSize.s12),
                      child: LabModelEmptyStateCard(
                        contentType: "note",
                        onCreateTap: () {},
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
