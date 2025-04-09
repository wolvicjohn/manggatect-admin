import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/pages/datatable/archive_dialog.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TreeDataTable extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelectTree;

  const TreeDataTable({super.key, required this.onSelectTree});

  @override
  TreeDataTableState createState() => TreeDataTableState();
}

class TreeDataTableState extends State<TreeDataTable> {
  final int _limit = 10;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<DocumentSnapshot> _mangoTreeList = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(1.0), // Number
                  1: FixedColumnWidth(100.0), // Image
                  2: FixedColumnWidth(100.0), // Stage
                  3: FixedColumnWidth(100.0), // Uploader
                  4: FixedColumnWidth(200.0), // Date
                  5: FixedColumnWidth(220.0), // Actions
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200),
                  verticalInside: BorderSide(color: Colors.grey.shade200),
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
                children: [
                  _buildTableHeader(),
                  ..._mangoTreeList.asMap().entries.map((entry) {
                    final index = entry.key + 1; // start from 1
                    final document = entry.value;
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    data['docID'] = document.id;
                    return _buildTableRow(context, data, index);
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOutRapid,
                    colors: [
                      Color.fromARGB(255, 20, 116, 82),
                      Colors.yellow,
                      Colors.red,
                      Colors.blue,
                      Colors.orange,
                    ],
                    strokeWidth: 3,
                  ),
                ),
              ),
            if (_hasMore)
              TextButton(
                onPressed: _loadMoreData,
                child: const Text('Load More',
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 116, 82),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMoreData();
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Query query = FirebaseFirestore.instance
          .collection('mango_tree')
          .where('isArchived', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .limit(_limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        _mangoTreeList.addAll(querySnapshot.docs);
        setState(() {
          _hasMore = querySnapshot.docs.length == _limit;
        });
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 116, 82),
        borderRadius: BorderRadius.circular(4.0),
      ),
      children: [
        Center(child: _headerCell("No.")),
        _headerCell("Image"),
        _headerCell("Stage"),
        _headerCell("Uploader"),
        _headerCell("Date Uploaded"),
        _headerCell("Actions"),
      ],
    );
  }

  TableRow _buildTableRow(
      BuildContext context, Map<String, dynamic> data, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(index.toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: data['imageUrl'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                      imageUrl: data['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const LoadingIndicator(
                              indicatorType: Indicator.lineScalePulseOutRapid,
                              colors: [
                                Color.fromARGB(255, 20, 116, 82),
                                Colors.yellow,
                                Colors.red,
                                Colors.blue,
                                Colors.orange,
                              ],
                              strokeWidth: 3,
                            ),
                          ),
                      errorWidget: (context, url, error) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.error_outline),
                          )),
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
            fontFamily: 'sans-serif',
          ),
        ),
        _dataCell(
          data['uploader']?.toString() ?? 'N/A',
          customStyle: TextStyle(
            color: _getUploaderColor(data['uploader']?.toString() ?? ''),
            fontFamily: 'sans-serif',
          ),
        ),
        _dataCell(
          DateFormat('EEEE, MMMM dd, yyyy h:mm a')
              .format(data['timestamp'].toDate()),
          customStyle: const TextStyle(
            fontFamily: 'sans-serif',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => widget.onSelectTree(data),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5),
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text("View"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => showArchiveDialog(context, data['docID']),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5),
                icon: const Icon(Icons.archive, size: 16),
                label: const Text("Archive"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getUploaderColor(String uploader) {
    final int hash = uploader.hashCode;
    final int r = 50 + (hash & 0x7F);
    final int g = 50 + ((hash >> 7) & 0x7F);
    final int b = 50 + ((hash >> 14) & 0x7F);
    return Color.fromARGB(255, r, g, b);
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
