import 'package:flutter/material.dart';

import '../../services/header.dart';
import 'widgets/stage_card.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomHeader(
                  title: 'Mango Stages Information',
                  description:
                      'Learn about the different stages of mango tree growth.',
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),

            // Stages
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                StageCard(
                  title: 'Stage 1 | Budding Phase stage',
                  description:
                      'This is the initial stage where the mango tree starts growing.',
                  image: 'assets/images/stage1.jpg',
                ),
                StageCard(
                  title: 'Stage 2 | Flowers Blossom stage',
                  description: 'The tree begins to form small buds and leaves.',
                  image: 'assets/images/stage2.jpg',
                ),
                StageCard(
                  title: 'Stage 3 | Complete bloom stage',
                  description:
                      'Flowers start blooming, indicating fruit formation soon.',
                  image: 'assets/images/stage3.jpg',
                ),
                StageCard(
                  title: 'Stage 4 | Fruit setting stage',
                  description:
                      'The fruits are fully formed and ready for harvest.',
                  image: 'assets/images/stage4.jpg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
