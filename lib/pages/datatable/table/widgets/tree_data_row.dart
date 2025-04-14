import 'package:adminmangga/services/imagewidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/archive_dialog.dart';
import 'tree_data_utils.dart';

TableRow buildTableRow(
  BuildContext context,
  Map<String, dynamic> data,
  int index,
  Function(Map<String, dynamic>) onSelectTree,
  VoidCallback onArchived,
) {
  return TableRow(
    children: [
      _DataCell(text: index.toString()),
      ImageWidget(
        imageUrl: data['imageUrl'], width: 100, height: 100,
      ),
      _DataCell(text: data['stage']?.toString() ?? 'N/A'),
      _DataCell(
        text: data['uploader']?.toString() ?? 'N/A',
        color: getUploaderColor(data['uploader']?.toString() ?? ''),
      ),
      _DataCell(
        text: DateFormat('EEEE, MMMM dd, yyyy h:mm a')
            .format(data['timestamp'].toDate()),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => onSelectTree(data),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text("View"),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => showArchiveDialog(
                context,
                data['docID'],
                onArchived,
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(Icons.archive, size: 16),
              label: const Text("Archive"),
            ),
          ],
        ),
      ),
    ],
  );
}

class _DataCell extends StatelessWidget {
  final String text;
  final Color? color;

  const _DataCell({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }
}
