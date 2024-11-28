import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  // Get collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  final FirebaseStorage storage = FirebaseStorage.instance;

  
  // Update the archive status of a note
  Future<void> updateArchiveStatus(String docID, bool isArchived) async {
    try {
      // Check if the document exists before updating
      DocumentSnapshot doc = await notes.doc(docID).get();
      if (doc.exists) {
        // Document exists, proceed to update
        await notes.doc(docID).update({'isArchived': isArchived});
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

  // Delete a specific note
  Future<void> deleteNote(String docID) async {
    try {
      await notes.doc(docID).delete();
      print('Note deleted');
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  // Get a specific note by ID
  Future<Map<String, dynamic>> getNoteById(String docID) async {
    try {
      DocumentSnapshot doc = await notes.doc(docID).get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching note by ID: $e');
      rethrow;
    }
  }

  // Get count of all notes
  Future<int> getNotesCount() async {
    try {
      QuerySnapshot snapshot = await notes.get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting notes: $e');
      rethrow;
    }
  }
}
