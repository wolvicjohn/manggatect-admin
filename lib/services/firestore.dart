import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  // Get collection
  final CollectionReference mango_tree =
      FirebaseFirestore.instance.collection('mango_tree');
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Update the archive status of a mango_tree
  Future<void> updateArchiveStatus(String docID, bool isArchived) async {
    try {
      // Check if the document exists before updating
      DocumentSnapshot doc = await mango_tree.doc(docID).get();
      if (doc.exists) {
        // Document exists, proceed to update
        await mango_tree.doc(docID).update({'isArchived': isArchived});
        print('Archive status updated successfully');
      } else {
        // Document doesn't exist
        print('No document found with the ID: $docID');
      }
    } catch (e) {
      print('Error updating archive status: $e');
      rethrow; // Rethrow error after logging it
    }
  }

  // Delete a specific mango_tree
  Future<void> deletemango_tree(String docID) async {
    try {
      await mango_tree.doc(docID).delete();
      print('mango_tree deleted');
    } catch (e) {
      print('Error deleting mango_tree: $e');
      rethrow;
    }
  }

  // Get a specific mango_tree by ID
  Future<Map<String, dynamic>> getmango_treeById(String docID) async {
    try {
      DocumentSnapshot doc = await mango_tree.doc(docID).get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching mango_tree by ID: $e');
      rethrow;
    }
  }

  // Get count of all mango_tree
  Future<int> getmango_treeCount() async {
    try {
      QuerySnapshot snapshot = await mango_tree.get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting mango_tree: $e');
      rethrow;
    }
  }
}
