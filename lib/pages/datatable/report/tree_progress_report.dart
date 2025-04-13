import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TreeProgressReport extends StatelessWidget {
  final String? docID;

  const TreeProgressReport({super.key, required this.docID});

  Color _getStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'flowering':
        return Colors.purple;
      case 'fruiting':
        return Colors.green;
      case 'harvesting':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStageIcon(String stage) {
    switch (stage.toLowerCase()) {
      case 'flowering':
        return '🌸';
      case 'fruiting':
        return '🥭';
      case 'harvesting':
        return '🌟';
      default:
        return '🌱';
    }
  }

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

                return Stack(
                  children: [
                    // Timeline line
                    if (!isLast)
                      Positioned(
                        left: 20,
                        top: 50,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline dot
                          Container(
                            margin:
                                const EdgeInsets.only(top: 8.0, right: 16.0),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: isLatest
                                  ? _getStageColor(history['stage'] ?? '')
                                  : Colors.white,
                              border: Border.all(
                                color: _getStageColor(history['stage'] ?? ''),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _getStageIcon(history['stage'] ?? ''),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),

                          // Content card
                          Expanded(
                            child: Card(
                              elevation: isLatest ? 3 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isLatest
                                      ? _getStageColor(history['stage'] ?? '')
                                      : Colors.grey.shade200,
                                  width: isLatest ? 2 : 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStageColor(
                                                    history['stage'] ?? '')
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            history['stage'] ?? 'N/A',
                                            style: TextStyle(
                                              color: _getStageColor(
                                                  history['stage'] ?? ''),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (isLatest)
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'Latest',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (history['moved_at'] != null)
                                      Text(
                                        DateFormat('EEEE, MMMM dd, yyyy h:mm a')
                                            .format(
                                                history['moved_at'].toDate()),
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    if (history['stageImageUrl'] != null) ...[
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          history['stageImageUrl'],
                                          height: 200,
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
