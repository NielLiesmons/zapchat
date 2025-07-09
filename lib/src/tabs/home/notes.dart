import 'package:zaplab_design/zaplab_design.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Notes',
      icon: const LabEmojiContentType(contentType: 'note'),
      content: Builder(
        builder: (context) {
          return LabContainer(
            child: const LabLoadingFeed(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
