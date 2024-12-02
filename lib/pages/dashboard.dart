import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_panel.dart';
import 'stagemango_treepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, '/loginpage'));
    }

    return AdminPanel(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mango_tree')
            .where('isArchived', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Map<String, dynamic>> mango_treeList =
              snapshot.data!.docs.map((doc) {
            return {
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            };
          }).toList();

          // Count stages
          final Map<String, List<Map<String, dynamic>>> stageData = {
            'stage-1': [],
            'stage-2': [],
            'stage-3': [],
            'stage-4': [],
            'no data yet': [],
          };

          for (var mango_tree in mango_treeList) {
            final stage = mango_tree['stage'];
            if (stageData.containsKey(stage)) {
              stageData[stage]!.add(mango_tree);
            } else {
              stageData['no data yet']!.add(mango_tree);
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 116, 82),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 6),
                            blurRadius: 12.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      // margin: EdgeInsets.all(16),
                      child: const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Boxes Layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StageBox(
                        stage: 'stage-1', mango_tree: stageData['stage-1']!),
                    StageBox(
                        stage: 'stage-2', mango_tree: stageData['stage-2']!),
                    StageBox(
                        stage: 'stage-3', mango_tree: stageData['stage-3']!),
                    StageBox(
                        stage: 'stage-4', mango_tree: stageData['stage-4']!),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StageBox(
                        stage: 'Not classified',
                        mango_tree: stageData['no data yet']!),
                  ],
                ),
                const Row(
                  children: [
                    SizedBox(height: 16),
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
  final List<Map<String, dynamic>> mango_tree;

  const StageBox({Key? key, required this.stage, required this.mango_tree})
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
        return 'assets/images/logo.png';
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
              builder: (context) =>
                  Stagemango_treePage(stage: stage, mango_tree: mango_tree),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(0, 44, 155, 63),
          child: Container(
            decoration: BoxDecoration(
              border: const Border(
                top: BorderSide(
                  color: const Color.fromARGB(255, 20, 116, 82), // Border color here
                  width: 15, // Border width
                ),
              ),borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      getImageForStage(stage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Content over the background image
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${mango_tree.length}',
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stage,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
