import 'package:adminmangga/archive.dart';
import 'package:adminmangga/services/delete.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  Map<String, dynamic>? selectedmango_tree;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 116, 82),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 6),
                                blurRadius: 12.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          // margin: EdgeInsets.all(16),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Archive',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                ' Previously archived mango trees. Allows administrator to restore or permanently delete entries.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        // get data where isArchived is true
                        stream: FirebaseFirestore.instance
                            .collection('mango_tree')
                            .where('isArchived', isEqualTo: true)
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                  indicatorType:
                                      Indicator.lineScalePulseOutRapid,
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

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text("No Archived Trees..."),
                            );
                          }

                          List<DocumentSnapshot> mangoTreelist =
                              snapshot.data!.docs;

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
                                  ...mangoTreelist.map((document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    String imageStageUrl =
                                        data['imageUrl'] ?? 'N/A';
                                    Timestamp? timestamp = data['timestamp'];

                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: imageStageUrl != 'N/A'
                                              ? Image.network(
                                                  imageStageUrl,
                                                  width: 100,
                                                  height: 100,
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
                                                .format(
                                                    data['timestamp'].toDate()),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  showArchiveDialog(
                                                      context, document.id);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  String imageUrl =
                                                      document['imageUrl'];
                                                  String stageImageUrl =
                                                      document['stageImageUrl'];
                                                  // Call the delete function
                                                  showDeleteDialog(
                                                      context,
                                                      document.id,
                                                      imageUrl,
                                                      stageImageUrl);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
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
