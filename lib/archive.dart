import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';

class ArchiveDialog extends StatelessWidget {
  final String docID;
  final FirestoreService firestoreService = FirestoreService();

  ArchiveDialog({super.key, required this.docID});

  // Method to archive a note by updating the 'isArchived' field in Firestore
  Future<void> archiveNote(BuildContext context) async {
    try {
      bool isCurrentlyArchived = false;

      await firestoreService.getNoteById(docID).then((doc) {
        isCurrentlyArchived = doc['isArchived'] ?? false;
      });

      await firestoreService.updateArchiveStatus(docID, !isCurrentlyArchived);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCurrentlyArchived
              ? 'Data Restoration success'
              : 'Data archived successfully'),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during the archive operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error archiving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Archive Data'),
      content: const Text(
        'Are you sure you want to archive this Data?',
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
            Navigator.pop(context);
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
