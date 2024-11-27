import 'package:adminmangga/archive.dart';
import 'package:adminmangga/pages/TreeLocationPage.dart';
import 'package:adminmangga/pages/qrcodegeneratorpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';
import '../services/admin_panel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController stageController = TextEditingController();

  Map<String, dynamic>? selectedNote;

  // Archive data function
  Future<void> archiveData(String docID) async {
    try {
      // Update the document in Firestore by setting the 'archived' field to true
      await FirebaseFirestore.instance.collection('notes').doc(docID).update({
        'archived': true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data archived successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error archiving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Row(
        children: [
          // Table section inside a container
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
                        "Data",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firestoreService.getNoteStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> notesList =
                                snapshot.data!.docs;

                            return ListView(
                              children: [
                                Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  columnWidths: const {
                                    0: FlexColumnWidth(2), // Adjusted for docID
                                    1: FlexColumnWidth(1), // Adjusted for stage
                                    2: FlexColumnWidth(
                                        1), // Adjusted for timestamp
                                    3: FlexColumnWidth(
                                        2), // Adjusted for actions
                                  },
                                  children: [
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent,
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("DocID",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Stage",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Timestamp",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Actions",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...notesList.map((document) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;
                                      String docID = document.id;
                                      Timestamp timestamp = data['timestamp'];

                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(docID),
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
                                              timestamp != null
                                                  ? timestamp
                                                      .toDate()
                                                      .toString()
                                                  : 'N/A',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 20),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedNote = data;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.preview,
                                                    color: Colors
                                                        .white, // Icon color
                                                  ),
                                                  label: const Text(
                                                    'View',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .white, // Text color
                                                      fontWeight: FontWeight
                                                          .bold, // Text style
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .orange, // Background color of the button
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0,
                                                        horizontal:
                                                            16.0), // Padding around the text and icon
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Rounded corners
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 50),

                                                // Archive button
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    // Navigate to ArchivePage
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
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 16.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
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

          // View panel
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 214),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: selectedNote == null
                  ? const Center(
                      child: Text(
                        "Select data to View details.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "View Details",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(color: Colors.blueAccent, thickness: 2.0),
                        const SizedBox(height: 8.0),
                        selectedNote!['imageUrl'] != null
                            ? Image.network(
                                selectedNote!['imageUrl'] ?? '',
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text(
                                  "No image available",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                        const SizedBox(height: 8.0),
                        Column(
                          children: [
                            Text(
                              "Longitude: ${selectedNote!['longitude'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "Latitude: ${selectedNote!['latitude'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "Stage: ${selectedNote!['stage'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        // QR Code button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QRCodeGeneratorPage(
                                      docID: selectedNote!['docID'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor:
                                    Colors.white, // Set the text color to white
                              ),
                              child: const Text('Generate QR Code'),
                            ),
                            const SizedBox(height: 16.0),
                            // Location button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TreeLocationPage(
                                      latitude: selectedNote!['latitude'] ?? 'N/A',
                                      longitude:
                                          selectedNote!['longitude'] ?? 'N/A',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor:
                                    Colors.white, 
                              ),
                              child: const Text('Get Location'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
