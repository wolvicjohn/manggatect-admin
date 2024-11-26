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

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Row(
        children: [
          // Table section inside a container
          Expanded(
            flex: 3,
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
                        "Notes Data",
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
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1.5),
                                    2: FlexColumnWidth(1.5),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(2),
                                  },
                                  children: [
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Title",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Longitude",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Latitude",
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
                                          child: Text("Actions",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...notesList.map((document) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;

                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                data['title'] ?? 'Untitled'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                data['longitude'] ?? '0.0'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                Text(data['latitude'] ?? '0.0'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                data['stage']?.toString() ??
                                                    'N/A'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                // View icon with text
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedNote = data;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.preview,
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                  ],
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
          // Preview panel
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        "Select a note to preview details.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Preview Details",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(color: Colors.blueAccent, thickness: 2.0),
                        const SizedBox(height: 8.0),
                        // Check if an image URL is present in selectedNote
                        selectedNote!['imageUrl'] != null
                            ? Image.network(
                                selectedNote!['imageUrl'] ?? '',
                                width: double.infinity,
                                height: 200.0,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text(
                                  "No image available",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Title: ${selectedNote!['title'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0),
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
                        const SizedBox(height: 16.0),
                        const Divider(color: Colors.blueAccent, thickness: 2.0),

                        // Buttons Section
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // ignore: prefer_const_constructors
                                    builder: (context) => QRCodeGeneratorPage(
                                        docID: 'YourDocumentID'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text("Scan QR Code"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Check if selectedNote has valid latitude and longitude values
                                if (selectedNote != null) {
                                  final latitude = selectedNote!['latitude'];
                                  final longitude = selectedNote!['longitude'];

                                  // Ensure latitude and longitude are valid doubles
                                  if (latitude != null && longitude != null) {
                                    final latitudeDouble =
                                        double.tryParse(latitude.toString());
                                    final longitudeDouble =
                                        double.tryParse(longitude.toString());

                                    if (latitudeDouble != null &&
                                        longitudeDouble != null) {
                                      // Navigate to TreeLocationPage with the latitude and longitude as doubles
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TreeLocationPage(
                                            latitude: latitudeDouble,
                                            longitude: longitudeDouble,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Show an error message if latitude or longitude is invalid
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Invalid location data')),
                                      );
                                    }
                                  } else {
                                    // Show an error message if latitude or longitude is missing
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'No valid location data available')),
                                    );
                                  }
                                } else {
                                  // Show an error message if no note is selected
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please select a note first')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 68, 255, 137),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text("Location"),
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
