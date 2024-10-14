import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';
import '../services/admin_panel.dart';
import 'TreeLocationPage.dart';
import 'QRCodeGeneratorPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();

  // Controllers for the text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController stageController = TextEditingController();

  // Method to open the dialog for updating notes
  void openNoteBox({required String docID}) {
    firestoreService.getNoteById(docID).then((data) {
      titleController.text = data['title'] ?? '';
      longitudeController.text = data['longitude'] ?? '';
      latitudeController.text = data['latitude'] ?? '';
      stageController.text = data['stage'].toString();
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Enter title"),
            ),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(hintText: "Enter longitude"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(hintText: "Enter latitude"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: stageController,
              decoration: const InputDecoration(hintText: "Enter stage"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              firestoreService.updateNote(
                docID: docID,
                title: titleController.text,
                longitude: longitudeController.text,
                latitude: latitudeController.text,
                stage: int.tryParse(stageController.text),
              );

              titleController.clear();
              longitudeController.clear();
              latitudeController.clear();
              stageController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete All Data"),
        content: const Text(
            "Are you sure you want to delete all data? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await firestoreService.deleteAllNotes();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getNoteStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> notesList = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = notesList[index];
                            String docID = document.id;
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            String imageUrl = data['imageUrl'] ?? '';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                leading: imageUrl.isNotEmpty
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.blue, width: 2),
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey,
                                      ),
                                title: Text(
                                  data['title'] ?? 'Untitled',
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Longitude: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data['longitude'] ?? '0.0'}',
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Latitude: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data['latitude'] ?? '0.0'}',
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Stage: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data['stage'] ?? 'N/A'}',
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'ID: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          docID,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          openNoteBox(docID: docID),
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          firestoreService.deleteNote(docID),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final latitude = double.tryParse(
                                                data['latitude'] ?? '0.0') ??
                                            0.0;
                                        final longitude = double.tryParse(
                                                data['longitude'] ?? '0.0') ??
                                            0.0;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TreeLocationPage(
                                              latitude: latitude,
                                              longitude: longitude,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.map,
                                          color: Colors.green),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                QRCodeGeneratorPage(
                                                    docID: docID),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.qr_code,
                                          color: Colors.purple),
                                    ),
                                  ],
                                ),
                              ),
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
          // Positioned delete all button at the bottom right
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _showDeleteAllConfirmationDialog,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
    );
  }
}
