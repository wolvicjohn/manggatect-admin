import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
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
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 20, 116, 82),
              padding:
                  const EdgeInsets.symmetric(horizontal: 152, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
  }
}
