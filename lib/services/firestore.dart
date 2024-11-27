import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  // Get collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  final FirebaseStorage storage =
      FirebaseStorage.instance; // Firebase Storage instance

  // Create
  // Future<String> addNote({
  //   required String longitude,
  //   required String latitude,
  //   required File? image,
  //   int? stage,
  //   String? title, // Add title as an optional parameter
  // }) async {
  //   try {
  //     print(
  //         'Attempting to save note with Longitude: $longitude, Latitude: $latitude');

  //     // Initialize imageUrl to an empty string if no image is provided
  //     String imageUrl = image != null ? await uploadImage(image) : '';

  //     // If no title is provided, use a default title (or leave it empty)
  //     title ??= 'Untitled'; // Default title is 'Untitled' if none is provided

  //     // Add note to Firestore
  //     DocumentReference docRef = await notes.add({
  //       'longitude': longitude,
  //       'latitude': latitude,
  //       'imageUrl': imageUrl, // Store image URL (or empty string)
  //       'timestamp': Timestamp.now(),
  //       'stage': stage ?? 0, // Set stage to provided value or default to 0
  //       'isArchived': false, // Set the initial value of isArchived to false
  //     });

  //     print('Note added with ID: ${docRef.id}');
  //     return docRef.id; // Return the document ID
  //   } catch (e) {
  //     print('Error adding data: $e');
  //     rethrow; // Re-throw the error to be handled by the caller
  //   }
  // }

  // Function to get the count of existing notes
  Future<int> getNotesCount() async {
    QuerySnapshot snapshot = await notes.get();
    return snapshot.docs.length; // Return the count of documents
  }

  // Upload image
  Future<String> uploadImage(File image) async {
    try {
      Reference ref = storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Create metadata object
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

      // Upload the image file with metadata
      await ref.putFile(image, metadata);

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Read - Stream notes that are not archived
  Stream<QuerySnapshot> getActiveNoteStream() {
    return notes
        .where('isArchived', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Read - Stream archived notes
  Stream<QuerySnapshot> getArchivedNoteStream() {
    return notes
        .where('isArchived', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Archive a specific note
  Future<void> archiveNote(String docID) async {
    try {
      await notes.doc(docID).update({
        'isArchived': true, // Set the isArchived field to true
      });
      print('Note archived successfully!');
    } catch (e) {
      print('Error archiving note: $e');
      rethrow;
    }
  }

  // Unarchive a specific note (restore the note)
  Future<void> unarchiveNote(String docID) async {
    try {
      await notes.doc(docID).update({
        'isArchived': false, // Set the isArchived field to false
      });
      print('Note unarchived successfully!');
    } catch (e) {
      print('Error unarchiving note: $e');
      rethrow;
    }
  }

  // Delete a specific note
  Future<void> deleteNote(String docID) async {
    try {
      await notes.doc(docID).delete();
      print('Note deleted successfully!');
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  // Permanently delete an archived note
  Future<void> deleteArchivedNote(String docID) async {
    try {
      await notes.doc(docID).delete();
      print('Archived note permanently deleted!');
    } catch (e) {
      print('Error deleting archived note: $e');
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

  // Read - Stream all notes (including archived)
  Stream<QuerySnapshot> getNoteStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }
}
