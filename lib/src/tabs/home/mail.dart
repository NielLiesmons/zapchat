import 'package:zaplab_design/zaplab_design.dart';

class MailTab extends StatelessWidget {
  const MailTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = LabTheme.of(context);

    return TabData(
      label: 'Mail',
      icon: const LabEmojiContentType(contentType: 'mail'),
      content: const MailTab(),
      optionsDescription: "Mail settings",
      optionssContent: LabContainer(
        child: Column(
          children: [
            LabSectionTitle("Mail"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      child: LabModelEmptyStateCard(
        contentType: "mail",
        onCreateTap: () {},
      ),
    );
  }
}
