import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/pages/datatable/archive_dialog.dart';
import 'package:intl/intl.dart';

class TreeDataTable extends StatelessWidget {
  final Function(Map<String, dynamic>) onSelectTree;

  const TreeDataTable({super.key, required this.onSelectTree});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mango_tree')
          .where('isArchived', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "No data available",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }

        List<DocumentSnapshot> mangoTreelist = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 850, // Fixed width to accommodate all columns
                    child: SingleChildScrollView(
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FixedColumnWidth(100.0), // Image
                          1: FixedColumnWidth(150.0), // Stage
                          2: FixedColumnWidth(180.0), // Uploader
                          3: FixedColumnWidth(200.0), // Date
                          4: FixedColumnWidth(220.0), // Actions
                        },
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey.shade200),
                          verticalInside:
                              BorderSide(color: Colors.grey.shade200),
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                        children: [
                          _buildTableHeader(),
                          ...mangoTreelist.map((document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            data['docID'] = document.id;
                            return _buildTableRow(context, data);
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 116, 82),
        borderRadius: BorderRadius.circular(4.0),
      ),
      children: [
        _headerCell("Image"),
        _headerCell("Stage"),
        _headerCell("Uploader"),
        _headerCell("Date Uploaded"),
        _headerCell("Actions"),
      ],
    );
  }

  TableRow _buildTableRow(BuildContext context, Map<String, dynamic> data) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: data['imageUrl'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    data['imageUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error_outline),
                      );
                    },
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
        ),
        _dataCell(
          data['stage']?.toString() ?? 'N/A',
          customStyle: TextStyle(
            color: _getStageColor(data['stage']?.toString() ?? ''),
            fontWeight: FontWeight.w600,
          ),
        ),
        _dataCell(data['uploader']?.toString() ?? 'N/A'),
        _dataCell(
          DateFormat('MMM dd, yyyy HH:mm').format(data['timestamp'].toDate()),
          customStyle: const TextStyle(
            fontFamily: 'monospace',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () => onSelectTree(data),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text("View"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => showArchiveDialog(context, data['docID']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  static Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  static Widget _dataCell(String text, {TextStyle? customStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        text,
        style: customStyle ??
            const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
      ),
    );
  }

  static Color _getStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'flowering':
        return Colors.purple;
      case 'fruiting':
        return Colors.green;
      case 'harvesting':
        return Colors.orange;
      default:
        return Colors.black87;
    }
  }
}
