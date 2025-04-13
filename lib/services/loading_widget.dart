import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const LoadingIndicator(
          indicatorType: Indicator.lineScalePulseOutRapid,
          colors: [
            Color.fromARGB(255, 20, 116, 82),
            Colors.yellow,
            Colors.red,
            Colors.blue,
            Colors.orange,
          ],
          strokeWidth: 3,
        ),
      ),
    );
  }
}
