import 'package:adminmangga/archive.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:intl/intl.dart';
import '../services/admin_panel.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  Map<String, dynamic>? selectedmango_tree;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Row(
        children: [
          // Table section inside a container
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Archived Data",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        // get data where isArchived is true
                        stream: FirebaseFirestore.instance
                            .collection('mango_tree')
                            .where('isArchived', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text("No Archived Data..."),
                            );
                          }

                          List<DocumentSnapshot> mango_treeList =
                              snapshot.data!.docs;

                          return ListView(
                            children: [
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                columnWidths: const {
                                  0: FlexColumnWidth(
                                      0.7), // Adjusted for imageStageUrl
                                  1: FlexColumnWidth(.5), // Adjusted for stage
                                  2: FlexColumnWidth(1), // Adjusted for date
                                  3: FlexColumnWidth(1), // Adjusted for actions
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
                                  ...mango_treeList.map((document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    String imageStageUrl =
                                        data['stageImageUrl'] ?? 'N/A';
                                    Timestamp? timestamp = data['timestamp'];

                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: imageStageUrl != 'N/A'
                                              ? Image.network(
                                                  imageStageUrl,
                                                  width:
                                                      70, 
                                                  height:
                                                      80, 
                                                  fit: BoxFit.cover,
                                                )
                                              : const Text('No Image'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              data['stage']?.toString() ??
                                                  'N/A'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat(
                                                    'EEEE, MMMM dd, yyyy h:mm a')
                                                .format(timestamp!.toDate()),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showArchiveDialog(
                                                  context, document.id);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
