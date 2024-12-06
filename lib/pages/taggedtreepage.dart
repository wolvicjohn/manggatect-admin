import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class TaggedTreePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TaggedTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: const Text('Tagged Trees'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('mango_trees')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tagged trees found.'));
          }

          final allMangoTree = snapshot.data!.docs;

          return ListView.builder(
            itemCount: allMangoTree.length,
            itemBuilder: (context, index) {
              final mangoTree =
                  allMangoTree[index].data() as Map<String, dynamic>;
              final String title = mangoTree['title'] ?? 'Untitled';
              final String longitude = mangoTree['longitude'] ?? 'N/A';
              final String latitude = mangoTree['latitude'] ?? 'N/A';
              final String? imageUrl = mangoTree['imageUrl'];

              return Card(
                margin: const EdgeInsets.all(8.0),
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
                                const SizedBox(height: 8),
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
                              child: const Text('Close'),
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
