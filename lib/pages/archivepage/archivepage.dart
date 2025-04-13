import 'package:flutter/material.dart';
import '../../services/header.dart';
import 'widgets/archive_table.dart';


class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(
              title: 'Archive',
              description:
                  'Archived Trees. Restore or Delete the data permanently.'),
          SizedBox(height: 16),
          Expanded(child: ArchiveTable()),
        ],
      ),
    );
  }
}
