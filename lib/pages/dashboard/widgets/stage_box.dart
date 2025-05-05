import 'package:flutter/material.dart';

class StageBox extends StatelessWidget {
  final String stage;
  final List<Map<String, dynamic>> mango_tree;

  const StageBox({Key? key, required this.stage, required this.mango_tree})
      : super(key: key);

  // Method to get the corresponding image for each stage
  String getImageForStage(String stage) {
    switch (stage) {
      case 'stage 1':
        return 'assets/images/stage1.jpg';
      case 'stage 2':
        return 'assets/images/stage2.jpg';
      case 'stage 3':
        return 'assets/images/stage3.jpg';
      case 'stage 4':
        return 'assets/images/stage4.jpg';
      default:
        return 'assets/images/logo.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNotClassified = stage == 'Not classified';

    return Expanded(
      child: Column(
        children: [
          if (!isNotClassified)
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(
                      color: Color.fromARGB(255, 20, 116, 82),
                      width: 15,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ClipOval(
                              child: Image.asset(
                                getImageForStage(stage),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${mango_tree.length}',
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 20, 116, 82),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                stage,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 20, 116, 82),
                                ),
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
        ],
      ),
    );
  }
}
