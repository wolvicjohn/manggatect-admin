import 'package:adminmangga/services/admin_panel.dart';
import 'package:flutter/material.dart';

class StageNotesPage extends StatelessWidget {
  final String stage;
  final List<Map<String, dynamic>> notes;

  const StageNotesPage({Key? key, required this.stage, required this.notes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Notes Table",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: notes.isNotEmpty
                    ? SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            1: FlexColumnWidth(1), // Longitude
                            2: FlexColumnWidth(1), // Latitude
                            3: FlexColumnWidth(1), // ID
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 20, 116, 82),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "ID",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Longitude",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Latitude",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...notes.map((note) {
                              return TableRow(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showNoteDetails(context, note);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(note['id'] ?? 'Unknown'),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showNoteDetails(context, note);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          note['longitude']?.toString() ??
                                              '0.0'),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showNoteDetails(context, note);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          note['latitude']?.toString() ??
                                              '0.0'),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      )
                    : const Center(child: Text("No Data...")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note['stage'] ?? 'Untitled'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Longitude: ${note['longitude'] ?? 'N/A'}"),
              Text("Latitude: ${note['latitude'] ?? 'N/A'}"),
              Text("ID: ${note['id'] ?? 'N/A'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
