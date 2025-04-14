import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';

class ArchiveDialog extends StatelessWidget {
  final String docID;
  final FirestoreService firestoreService = FirestoreService();

  ArchiveDialog({super.key, required this.docID});

  // Method to archive a mango_tree by updating the 'isArchived' field in Firestore
  Future<void> archivemango_tree(BuildContext context) async {
    try {
      bool isCurrentlyArchived = false;

      await firestoreService.getmangoTreeById(docID).then((doc) {
        isCurrentlyArchived = doc['isArchived'] ?? false;
      });

      await firestoreService.updateArchiveStatus(docID, !isCurrentlyArchived);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  isCurrentlyArchived
                      ? 'Data and images deleted successfully'
                      : 'Data archived successfully',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF147452),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
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
      title: const Text('Restore Tree'),
      content: const Text(
        'Are you sure you want to restore this Tree?',
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
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
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () async {
            await archivemango_tree(context);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text("Restore", style: TextStyle(color: Colors.white)),
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
