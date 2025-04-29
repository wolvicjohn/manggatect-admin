import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/loading_widget.dart';
import '../searchfield/search_field.dart';
import 'widgets/tree_data_header.dart';
import 'widgets/tree_data_row.dart';

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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _loadMoreData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreData() async {
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

        if (mounted) {
          setState(() {
            _hasMore = querySnapshot.docs.length == _limit;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _hasMore = false;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TreeSearchField(controller: _searchController),
            const SizedBox(height: 16),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FixedColumnWidth(1.0),
                1: FixedColumnWidth(100.0),
                2: FixedColumnWidth(100.0),
                3: FixedColumnWidth(100.0),
                4: FixedColumnWidth(200.0),
                5: FixedColumnWidth(220.0),
              },
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade200),
                verticalInside: BorderSide(color: Colors.grey.shade200),
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
              children: [
                buildTableHeader(),
                ..._mangoTreeList
                    .where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['docID'] = doc.id;
                      final uploader =
                          (data['uploader'] ?? '').toString().toLowerCase();
                      final stage =
                          (data['stage'] ?? '').toString().toLowerCase();
                      final docID =
                          (data['docID'] ?? '').toString().toLowerCase();
                      return uploader.contains(_searchQuery) ||
                          docID.contains(_searchQuery) ||
                          stage.contains(_searchQuery);
                    })
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key + 1;
                      final document = entry.value;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      data['docID'] = document.id;
                      return buildTableRow(
                          context, data, index, widget.onSelectTree, () {
                        setState(() {
                          _mangoTreeList
                              .removeWhere((item) => item.id == data['docID']);
                        });
                      });
                    }),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LoadingWidget(),
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
}
