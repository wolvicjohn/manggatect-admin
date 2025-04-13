import 'package:flutter/material.dart';

import '../../../services/header.dart';
import 'stagefilterdropdown.dart';
import '../treemapview.dart';

class AllTreeLocationPage extends StatefulWidget {
  const AllTreeLocationPage({Key? key}) : super(key: key);

  @override
  AllTreeLocationPageState createState() => AllTreeLocationPageState();
}

class AllTreeLocationPageState extends State<AllTreeLocationPage> {
  String selectedStage = 'All Stages';
  final List<String> stages = [
    'All Stages',
    'stage-1',
    'stage-2',
    'stage-3',
    'stage-4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(
              title: 'All Mango Tree Locations',
              description:
                  'An interactive map that visualizes the locations of all mango trees.'),
          Expanded(
            child: Stack(
              children: [
                TreeMapView(selectedStage: selectedStage),
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: StageFilterDropdown(
                    selectedStage: selectedStage,
                    stages: stages,
                    onChanged: (value) {
                      setState(() {
                        selectedStage = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
