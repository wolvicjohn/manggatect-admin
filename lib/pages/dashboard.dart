import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_panel.dart';
import 'stagenotespage.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Map<String, dynamic>> notesList =
              snapshot.data!.docs.map((doc) {
            return {
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            };
          }).toList();

          // Count notes by stages
          final Map<String, List<Map<String, dynamic>>> stageData = {
            'stage-1': [],
            'stage-2': [],
            'stage-3': [],
            'stage-4': [],
          };

          for (var note in notesList) {
            final stage = note['stage'];
            if (stageData.containsKey(stage)) {
              stageData[stage]!.add(note);
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                const Text(
                  'Tagged Tree Classification',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Boxes Layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StageBox(stage: 'stage-1', notes: stageData['stage-1']!),
                    StageBox(stage: 'stage-2', notes: stageData['stage-2']!),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StageBox(stage: 'stage-3', notes: stageData['stage-3']!),
                    StageBox(stage: 'stage-4', notes: stageData['stage-4']!),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom widget to display stage boxes
class StageBox extends StatelessWidget {
  final String stage;
  final List<Map<String, dynamic>> notes;

  const StageBox({Key? key, required this.stage, required this.notes})
      : super(key: key);

  // Method to get the corresponding image for each stage
  String getImageForStage(String stage) {
    switch (stage) {
      case 'stage-1':
        return 'assets/images/stage1.jpg';
      case 'stage-2':
        return 'assets/images/stage2.jpg';
      case 'stage-3':
        return 'assets/images/stage3.jpg';
      case 'stage-4':
        return 'assets/images/stage4.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StageNotesPage(stage: stage, notes: notes),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          color: Colors.green, // Card background color
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image on the left
                Image.asset(
                  getImageForStage(stage),
                  height: 150,
                  width: 150,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${notes.length}',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stage,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
