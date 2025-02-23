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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('mango_tree').doc(docID).update({'isArchived': true});
              Navigator.pop(context);
            },
            child: const Text("Archive"),
          ),
        ],
      );
    },
  );
}
