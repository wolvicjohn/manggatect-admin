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
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: isNotClassified
            ? Colors.white
            : const Color.fromARGB(0, 44, 155, 63),
        child: Container(
          decoration: BoxDecoration(
            border: isNotClassified
                ? const Border(
                    top: BorderSide(
                      color: Color.fromARGB(255, 175, 32, 32),
                      width: 15,
                    ),
                  )
                : const Border(
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
              if (!isNotClassified)
                Positioned.fill(
                  child: Image.asset(
                    getImageForStage(stage),
                    fit: BoxFit.fill,
                  ),
                ),
              if (!isNotClassified)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${mango_tree.length}',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: isNotClassified ? Colors.black : Colors.white,
                        shadows: isNotClassified
                            ? []
                            : [
                                Shadow(
                                  color: Colors.black.withOpacity(0.6),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stage,
                      style: TextStyle(
                        fontSize: 20,
                        color: isNotClassified ? Colors.black : Colors.white,
                        shadows: isNotClassified
                            ? []
                            : [
                                Shadow(
                                  color: Colors.black.withOpacity(0.6),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
