import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/logo.png', height: 100),
        const SizedBox(width: 8),
        Row(
          children: [
            Text(
              'MANGGA',
              style: TextStyle(
                color: const Color.fromARGB(255, 127, 106, 25),
                fontSize: 25,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            Text(
              'TECH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: const Color.fromARGB(255, 20, 116, 82),
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
