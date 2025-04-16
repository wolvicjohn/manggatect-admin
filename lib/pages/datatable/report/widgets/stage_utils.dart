import 'package:flutter/material.dart';

Color getStageColor(String stage) {
  switch (stage.toLowerCase()) {
    case 'stage-2':
      return Colors.purple;
    case 'stage-4':
      return Colors.green;
    case 'stage-3':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String getStageIcon(String stage) {
  switch (stage.toLowerCase()) {
    case 'stage-2':
      return '🌸';
    case 'stage-4':
      return '🥭';
    case 'stage-3':
      return '🌟';
    default:
      return '🌱';
  }
}
