import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Mango Tree Stages Information",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 20, 116, 82),
                  ),
                ),
              ),

              // Stages as Cards
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  _buildStageCard(
                    title: 'Stage 1 | Budding Phase stage',
                    description:
                        'This is the initial stage where the mango tree starts growing.',
                    color: Colors.white70,
                    image: 'assets/images/stage1.jpg',
                  ),
                  _buildStageCard(
                    title: 'Stage 2 | Flowers Blossom stage',
                    description:
                        'The tree begins to form small buds and leaves.',
                    color: Colors.white70,
                    image: 'assets/images/stage2.jpg',
                  ),
                  _buildStageCard(
                    title: 'Stage 3 | Complete bloom stage',
                    description:
                        'Flowers start blooming, indicating fruit formation soon.',
                    color: Colors.white70,
                    image: 'assets/images/stage3.jpg',
                  ),
                  _buildStageCard(
                    title: 'Stage 4 | Fruit setting stage',
                    description:
                        'The fruits are fully formed and ready for harvest.',
                    color: Colors.white70,
                    image: 'assets/images/stage4.jpg',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a stage card
  Widget _buildStageCard({
    required String title,
    required String description,
    required Color color,
    required String image,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: 250.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image,
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10.0),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for bullet points
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.green[600],
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
