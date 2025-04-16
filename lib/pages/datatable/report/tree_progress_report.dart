import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'widgets/history_timeline_item.dart';

class TreeProgressReport extends StatelessWidget {
  final String? docID;

  const TreeProgressReport({super.key, required this.docID});

  @override
  Widget build(BuildContext context) {
    if (docID == null) {
      return _buildEmptyState("No history available.");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mango_tree')
          .doc(docID)
          .collection('history')
          .orderBy('moved_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
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
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState("No history records found.");
        }

        var historyDocs = snapshot.data!.docs;

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyDocs.length,
              itemBuilder: (context, index) {
                var history = historyDocs[index].data() as Map<String, dynamic>;
                bool isLatest = index == 0;
                bool isLast = index == historyDocs.length - 1;

                return HistoryTimelineItem(
                  history: history,
                  isLatest: isLatest,
                  isLast: isLast,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
