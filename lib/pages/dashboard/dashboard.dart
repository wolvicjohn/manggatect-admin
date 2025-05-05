import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../services/header.dart';
import '../../services/loading_widget.dart';
import 'widgets/chart_widget.dart';
import 'widgets/description_widget.dart';
import 'widgets/stage_box.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, '/loginpage'));
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mango_tree')
            .where('isArchived', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Map<String, dynamic>> mangoTreelist =
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

          for (var mango_tree in mangoTreelist) {
            final stage = mango_tree['stage'];
            if (stageData.containsKey(stage)) {
              stageData[stage]!.add(mango_tree);
            } else {
              stageData['no data yet']!.add(mango_tree);
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomHeader(title: 'Dashboard', description: ''),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pie Chart
                    DoughnutChartWidget(
                      stageData: stageData,
                      mangoTreeList: mangoTreelist,
                    ),

                    // Boxes
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StageBox(
                                  stage: 'stage 1',
                                  mango_tree: stageData['stage-1']!),
                              StageBox(
                                  stage: 'stage 2',
                                  mango_tree: stageData['stage-2']!),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StageBox(
                                  stage: 'stage 3',
                                  mango_tree: stageData['stage-3']!),
                              StageBox(
                                  stage: 'stage 4',
                                  mango_tree: stageData['stage-4']!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const DescriptionWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChartData {
  final String stage;
  final int count;

  _ChartData(this.stage, this.count);
}
