import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'stage_maintenance_helper.dart';
import 'stage_utils.dart';

class HistoryTimelineItem extends StatelessWidget {
  final Map<String, dynamic> history;
  final bool isLatest;
  final bool isLast;

  const HistoryTimelineItem({
    super.key,
    required this.history,
    required this.isLatest,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              Container(
                margin: const EdgeInsets.only(top: 8.0, right: 16.0),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isLatest
                      ? getStageColor(history['stage'] ?? '')
                      : Colors.white,
                  border: Border.all(
                    color: getStageColor(history['stage'] ?? ''),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    getStageIcon(history['stage'] ?? ''),
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
                          ? getStageColor(history['stage'] ?? '')
                          : Colors.grey.shade200,
                      width: isLatest ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getStageColor(history['stage'] ?? '')
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    history['stage'] ?? 'N/A',
                                    style: TextStyle(
                                      color:
                                          getStageColor(history['stage'] ?? ''),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isLatest)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Previous Stage',
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
                            if (history['timestamp'] != null)
                              Row(
                                children: [
                                  Text(
                                    '${DateFormat('EEEE, MMMM dd, yyyy h:mm a').format(history['timestamp'].toDate())} '
                                    '(${(history['moved_at']).toDate().difference(history['timestamp'].toDate()).inDays} days ago)',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            if (history['stageImageUrl'] != null) ...[
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
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
                        // const SizedBox(height: 6),
                        // MaintenanceTipBox(
                        //     tip: getMaintenanceTip(history['stage'] ?? '')),
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
  }
}
