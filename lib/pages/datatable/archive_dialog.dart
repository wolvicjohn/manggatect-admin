import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void showArchiveDialog(BuildContext context, String docID) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Archive Confirmation"),
        content: const Text("Are you sure you want to archive this data?"),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('mango_tree')
                  .doc(docID)
                  .update({'isArchived': true});
              Navigator.pop(context);
            },
            child: const Text(
              "Archive",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
