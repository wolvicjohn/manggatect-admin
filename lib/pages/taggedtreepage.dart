import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaggedTreePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tagged Trees'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('notes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tagged trees found.'));
          }

          final notes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index].data() as Map<String, dynamic>;
              final String title = note['title'] ?? 'Untitled';
              final String longitude = note['longitude'] ?? 'N/A';
              final String latitude = note['latitude'] ?? 'N/A';
              final String? imageUrl = note['imageUrl'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Longitude: $longitude'),
                      Text('Latitude: $latitude'),
                      SizedBox(height: 8),
                      imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                    'Image not available'); 
                              },
                            )
                          :const Placeholder(
                              fallbackHeight: 150,
                              fallbackWidth: double.infinity,
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
