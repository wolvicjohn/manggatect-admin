import 'package:flutter/material.dart';

import 'stagefilterdropdown.dart';
import 'treemapview.dart';

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
          Container(
            width: double.infinity,
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
            child: const Text(
              'All Mango Tree Locations',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
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
