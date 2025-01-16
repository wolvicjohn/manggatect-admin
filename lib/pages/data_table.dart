import 'package:adminmangga/archive.dart';
import 'package:adminmangga/pages/TreeLocationPage.dart';
import 'package:adminmangga/pages/qrcodegeneratorpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();
  Map<String, dynamic>? selectedmango_tree;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
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
                        "Uploaded Mango Tree Data",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('mango_tree')
                            .where('isArchived', isEqualTo: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> mangoTreelist =
                                snapshot.data!.docs;

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return ListView(
                                  children: [
                                    Table(
                                      border:
                                          TableBorder.all(color: Colors.grey),
                                      columnWidths: {
                                        0: const FlexColumnWidth(
                                            0.5), // Image column
                                        1: const FlexColumnWidth(
                                            0.3), // Stage column
                                        2: const FlexColumnWidth(0.5),
                                        3: FlexColumnWidth(
                                            constraints.maxWidth > 600
                                                ? 1
                                                : 0.8), // Date column
                                        4: FlexColumnWidth(
                                            constraints.maxWidth > 600
                                                ? 1
                                                : 0.8), // Actions column
                                      },
                                      children: [
                                        const TableRow(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 20, 116, 82),
                                          ),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Image",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Stage",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Uploader",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Date Uploaded",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Actions",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...mangoTreelist.map((document) {
                                          Map<String, dynamic> data = document
                                              .data() as Map<String, dynamic>;
                                          String docID = document.id;
                                          Timestamp timestamp =
                                              data['timestamp'];
                                          String imageStageUrl =
                                              data['stageImageUrl'] ?? '';
                                          data['docID'] = docID;

                                          return TableRow(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: imageStageUrl.isNotEmpty
                                                    ? Image.network(
                                                        imageStageUrl,
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover)
                                                    : const Text('No Image'),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(data['stage']
                                                            ?.toString() ??
                                                        'N/A'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(data['uploader']
                                                            ?.toString() ??
                                                        'N/A'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      DateFormat(
                                                              'EEEE, MMMM dd, yyyy h:mm a')
                                                          .format(timestamp
                                                              .toDate()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        // View Button
                                                        ElevatedButton.icon(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedmango_tree =
                                                                  data;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.preview,
                                                            color: Colors.white,
                                                          ),
                                                          label: const Text(
                                                            'View',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.orange,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        16.0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            elevation: 5,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                                16.0), // Space between buttons

                                                        // Archive Button
                                                        ElevatedButton.icon(
                                                          onPressed: () {
                                                            showArchiveDialog(
                                                                context, docID);
                                                          },
                                                          icon: const Icon(
                                                            Icons.archive,
                                                            color: Colors.white,
                                                          ),
                                                          label: const Text(
                                                            'Archive',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        16.0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            elevation: 5,
                                                          ),
                                                        ),
                                                      ],
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
                          } else {
                            return const Center(child: Text("No Data..."));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: selectedmango_tree == null
                    ? const Center(
                        child: Text(
                          "Select data to view details.",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          const Text(
                            "Tree Details",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                              color: Colors.blueAccent, thickness: 1.5),
                          const SizedBox(height: 16.0),

                          // Content Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tree Image Card
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8.0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Tree Image',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      selectedmango_tree!['imageUrl'] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                selectedmango_tree![
                                                        'imageUrl'] ??
                                                    '',
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Center(
                                              child: Text(
                                                "No image available",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),

                              // Flower Stage Card
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8.0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Flower Stage',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      selectedmango_tree!['stageImageUrl'] !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                selectedmango_tree![
                                                        'stageImageUrl'] ??
                                                    '',
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Center(
                                              child: Text(
                                                "No image available",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // Details Section
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Uploaded by: ${selectedmango_tree!['uploader'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "DocID: ${selectedmango_tree!['docID'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  "Longitude: ${selectedmango_tree!['longitude'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Latitude: ${selectedmango_tree!['latitude'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Stage: ${selectedmango_tree!['stage'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  String docID = selectedmango_tree?['docID'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QRCodeGeneratorPage(docID: docID),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Generate QR Code",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TreeLocationPage(
                                        latitude: double.tryParse(
                                                selectedmango_tree![
                                                        'latitude'] ??
                                                    '0.0') ??
                                            0.0,
                                        longitude: double.tryParse(
                                                selectedmango_tree![
                                                        'longitude'] ??
                                                    '0.0') ??
                                            0.0,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Get Location",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // Progress Report
                          const Divider(
                              color: Colors.blueAccent, thickness: 1.5),
                          const Text(
                            "Progress Report",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('mango_tree')
                                .doc(selectedmango_tree!['docID'])
                                .collection('history')
                                .orderBy('moved_at', descending: true)
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
                                  child: Text("No history available."),
                                );
                              }

                              var historyDocs = snapshot.data!.docs;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: historyDocs.length,
                                itemBuilder: (context, index) {
                                  var history = historyDocs[index].data()
                                      as Map<String, dynamic>;

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 0.0),
                                    elevation: 3.0,
                                    child: ListTile(
                                      title: Text(
                                        "Stage: ${history['stage'] ?? 'N/A'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (history['moved_at'] != null)
                                            Text(
                                              "Updated on: ${DateFormat('EEEE, MMMM dd, yyyy h:mm a').format(history['moved_at'].toDate())}",
                                            ),
                                        ],
                                      ),
                                      trailing: history['stageImageUrl'] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                history['stageImageUrl'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              );
                            },
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
