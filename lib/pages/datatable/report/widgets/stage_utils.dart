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

String getMaintenanceTip(String stage) {
  switch (stage.toLowerCase()) {
    case 'stage-1':
      return 'Water regularly and ensure adequate sunlight.';
    case 'stage-2':
      return 'Check for early signs of pests and continue watering.';
    case 'stage-3':
      return 'Apply fertilizer and monitor flower development.';
    case 'stage-4':
      return 'Ensure fruit protection and prepare for harvest.';
    default:
      return 'General care: water, sunlight, and check for issues.';
  }
}
