import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';

class DeleteDialog extends StatelessWidget {
  final String docID;
  final String? imageUrl;
  final String? stageImageUrl;
  final FirestoreService firestoreService = FirestoreService();

  DeleteDialog({
    super.key,
    required this.docID,
    required this.imageUrl,
    this.stageImageUrl,
  });

  // Method to delete mango_tree data and corresponding images
  Future<void> deleteMangoTree(BuildContext context) async {
    try {
      // Calls the updated deleteNote method to delete the Firestore doc and images
      await firestoreService.deleteNote(docID, imageUrl, stageImageUrl);

      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Data and images deleted successfully',
                  style: TextStyle(fontSize: 16),
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
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: const Text(
        'Are you sure you want to permanently delete this data?',
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await deleteMangoTree(context);
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
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// Function to show the delete dialog
void showDeleteDialog(BuildContext context, String docID, String? imageUrl,
    String? stageImageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteDialog(
        docID: docID,
        imageUrl: imageUrl,
        stageImageUrl: stageImageUrl,
      );
    },
  );
}
