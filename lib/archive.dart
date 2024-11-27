import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart'; // Assuming FirestoreService is here

class ArchiveDialog extends StatelessWidget {
  final String docID;
  final FirestoreService firestoreService = FirestoreService();

  ArchiveDialog({super.key, required this.docID});

  // Method to archive a note by updating the 'isArchived' field in Firestore
  Future<void> archiveNote(BuildContext context) async {
    try {
      // Update the 'isArchived' field to true in Firestore for the document
      await firestoreService.archiveNote(docID);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note archived successfully')),
      );
    } catch (e) {
      // Handle any errors that occur during the archive operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error archiving note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Archive Note'),
      content: const Text(
        'Are you sure you want to archive this note?',
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            archiveNote(context); // Pass context to archiveNote method
            Navigator.pop(context); // Close the dialog after archiving
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text("Confirm Archive"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog without archiving
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

// Function to show the archive dialog
void showArchiveDialog(BuildContext context, String docID) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ArchiveDialog(docID: docID);
    },
  );
}
