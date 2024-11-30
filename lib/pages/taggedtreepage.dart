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
            .collection('mango_trees')
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

          final allMangoTree = snapshot.data!.docs;

          return ListView.builder(
            itemCount: allMangoTree.length,
            itemBuilder: (context, index) {
              final mango_tree = allMangoTree[index].data() as Map<String, dynamic>;
              final String title = mango_tree['title'] ?? 'Untitled';
              final String longitude = mango_tree['longitude'] ?? 'N/A';
              final String latitude = mango_tree['latitude'] ?? 'N/A';
              final String? imageUrl = mango_tree['imageUrl'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(title),
                  onTap: () {
                    // Show the details in a dialog box
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(title),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Longitude: $longitude'),
                                Text('Latitude: $latitude'),
                                SizedBox(height: 8),
                                imageUrl != null && imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Text(
                                              'Image not available');
                                        },
                                      )
                                    : const Placeholder(
                                        fallbackHeight: 150,
                                        fallbackWidth: double.infinity,
                                      ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
