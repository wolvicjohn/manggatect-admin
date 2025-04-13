import 'package:adminmangga/services/imagewidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adminmangga/services/delete.dart';
import 'package:adminmangga/services/archive.dart';
import '../../../services/loading_widget.dart';

class ArchiveTable extends StatelessWidget {
  const ArchiveTable({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mango_tree')
          .where('isArchived', isEqualTo: true)
          .orderBy('timestamp', descending: true)
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
              child: const LoadingWidget(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Archived Trees..."),
          );
        }

        List<DocumentSnapshot> mangolist = snapshot.data!.docs;

        return ListView(
          children: [
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(0.7),
                1: FlexColumnWidth(.5),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 20, 116, 82),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Image ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Stage",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Date",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Actions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                ...mangolist.map((document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String imageUrl = data['imageUrl'] ?? 'N/A';
                  Timestamp? timestamp = data['timestamp'];

                  return TableRow(
                    children: [
                      ImageWidget(imageUrl: imageUrl, width: 100, height: 100),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data['stage']?.toString() ?? 'N/A'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('EEEE, MMMM dd, yyyy h:mm a')
                              .format(timestamp!.toDate()),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showArchiveDialog(context, document.id);
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 5),
                              child: const Text(
                                "Restore",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                String imageUrl = document['imageUrl'];
                                String? stageImageUrl =
                                    document['stageImageUrl'];
                                showDeleteDialog(context, document.id, imageUrl,
                                    stageImageUrl);
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 5),
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        );
      },
    );
  }
}
