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
  Future<String> addNote({
    required String longitude,
    required String latitude,
    required File? image, // Allow image to be nullable
    int? stage, // Optional stage for adding notes
  }) async {
    try {
      print(
          'Attempting to save note with Longitude: $longitude, Latitude: $latitude');

      // Initialize imageUrl to an empty string if no image is provided
      String imageUrl = image != null ? await uploadImage(image) : '';

      // Get the current count of notes to increment the title
      int noteCount = await getNotesCount();
      String title = 'Tagged-Tree ${noteCount + 1}'; // Generate the new title

      // Add note to Firestore
      DocumentReference docRef = await notes.add({
        'title': title,
        'longitude': longitude,
        'latitude': latitude,
        'imageUrl': imageUrl, // Store image URL (or empty string)
        'timestamp': Timestamp.now(),
        'stage': stage ?? 0, // Set stage to provided value or default to 0
      });

      print('Note added with ID: ${docRef.id}');
      return docRef.id; // Return the document ID
    } catch (e) {
      print('Error adding data: $e');
      rethrow; // Re-throw the error to be handled by the caller
    }
  }

  // Function to get the count of existing notes
  Future<int> getNotesCount() async {
    QuerySnapshot snapshot = await notes.get();
    return snapshot.docs.length; // Return the count of documents
  }

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

  // Read
  Stream<QuerySnapshot> getNoteStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  // Update
  Future<void> updateNote({
    required String docID,
    required String title,
    required String longitude,
    required String latitude,
    String? imageUrl,
    int? stage,
  }) async {
    try {
      await notes.doc(docID).update({
        'title': title,
        'longitude': longitude,
        'latitude': latitude,
        if (imageUrl != null)
          'imageUrl': imageUrl, // Update image URL if provided
        if (stage != null) 'stage': stage, // Update stage if provided
        'timestamp': Timestamp.now(),
      });
      print('Note updated successfully!');
    } catch (e) {
      print('Error updating note: $e');
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

  // Delete all notes
  Future<void> deleteAllNotes() async {
    try {
      QuerySnapshot snapshot = await notes.get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('All notes deleted successfully!');
    } catch (e) {
      print('Error deleting all notes: $e');
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
}
