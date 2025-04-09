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

  // Delete a specific mangoTree
  Future<void> deletemangoTree(String docID) async {
    try {
      await mangoTree.doc(docID).delete();
      print('mangoTree deleted');
    } catch (e) {
      print('Error deleting mangoTree: $e');
      rethrow;
    }
  }

  // Get a specific mangoTree by ID
  Future<Map<String, dynamic>> getmangoTreeById(String docID) async {
    try {
      DocumentSnapshot doc = await mangoTree.doc(docID).get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching mangoTree by ID: $e');
      rethrow;
    }
  }

  // Get count of all mangoTree
  Future<int> getmangoTreeCount() async {
    try {
      QuerySnapshot snapshot = await mangoTree.get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting mangoTree: $e');
      rethrow;
    }
  }
  
Future<void> deleteNote(String docID) async {
  await FirebaseFirestore.instance
      .collection('mango_tree') 
      .doc(docID)
      .delete();
}


}
