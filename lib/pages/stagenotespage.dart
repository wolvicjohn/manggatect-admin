import 'package:flutter/material.dart';

class StageNotesPage extends StatelessWidget {
  final String stage;
  final List<Map<String, dynamic>> notes;

  const StageNotesPage({Key? key, required this.stage, required this.notes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$stage'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(note['title'] ?? 'Untitled'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Longitude: ${note['longitude'] ?? '0.0'}'),
                  Text('Latitude: ${note['latitude'] ?? '0.0'}'),
                  Text('ID: ${note['id']}',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
