import 'package:flutter/material.dart';

class MaintenanceTipBox extends StatelessWidget {
  final String tip;

  const MaintenanceTipBox({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 25,
          ),
          const SizedBox(width: 12),
          Text(
            tip,
            style: TextStyle(
              fontSize: 18,
              color: Colors.green.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
