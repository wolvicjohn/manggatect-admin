import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  // Get collection
  final CollectionReference mangoTree =
      FirebaseFirestore.instance.collection('mango_tree');
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Update the archive status of a mangoTree
  Future<void> updateArchiveStatus(String docID, bool isArchived) async {
    try {
      // Check if the document exists before updating
      DocumentSnapshot doc = await mangoTree.doc(docID).get();
      if (doc.exists) {
        // Document exists, proceed to update
        await mangoTree.doc(docID).update({'isArchived': isArchived});
        debugPrint('Archive status updated successfully');
      } else {
        // Document doesn't exist
        debugPrint('No document found with the ID: $docID');
      }
    } catch (e) {
      debugPrint('Error updating archive status: $e');
      rethrow; // Rethrow error after logging it
    }
  }

  // Delete a specific mangoTree
  Future<void> deletemangoTree(String docID) async {
    try {
      await mangoTree.doc(docID).delete();
      debugPrint('mangoTree deleted');
    } catch (e) {
      debugPrint('Error deleting mangoTree: $e');
      rethrow;
    }
  }

  // Get a specific mangoTree by ID
  Future<Map<String, dynamic>> getmangoTreeById(String docID) async {
    try {
      DocumentSnapshot doc = await mangoTree.doc(docID).get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error fetching mangoTree by ID: $e');
      rethrow;
    }
  }

  // Get count of all mangoTree
  Future<int> getmangoTreeCount() async {
    try {
      QuerySnapshot snapshot = await mangoTree.get();
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error counting mangoTree: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(
      String docID, String? imageUrl, String? stageImageUrl) async {
    try {
      // Always delete the Firestore document
      await FirebaseFirestore.instance
          .collection('mango_tree')
          .doc(docID)
          .delete();

      // Delete the main image from Firebase Storage only if the imageUrl is not null
      if (imageUrl != null) {
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
      }

      // If stageImageUrl is not null, delete the corresponding stage image
      if (stageImageUrl != null) {
        final stageRef = FirebaseStorage.instance.refFromURL(stageImageUrl);
        await stageRef.delete();
      }
    } catch (e) {
      debugPrint('Error deleting tree: $e');
    }
  }
}
