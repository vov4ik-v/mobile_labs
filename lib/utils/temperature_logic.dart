import 'package:flutter/material.dart';

class TemperatureLogic {
  static Color getTextColor(String input) {
    final lowerInput = input.trim().toLowerCase();

    if (lowerInput == 'avada kedavra') {
      return Colors.blueAccent;
    }

    final number = double.tryParse(input.trim());
    if (number != null) {
      if (!number.isFinite) {
        return Colors.white70;
      }
      if (number >= 30) {
        return Colors.redAccent;
      } else if (number <= 0) {
        return Colors.blueAccent;
      } else if (number >= 20 && number < 30) {
        return Colors.greenAccent;
      } else if (number > 0 && number < 20) {
        return Colors.orangeAccent;
      }
    }

    return Colors.white70;
  }

  static String getDisplayText(String input) {
    final lowerInput = input.trim().toLowerCase();

    if (lowerInput == 'avada kedavra') {
      return '0°C';
    }

    if (input.trim().isEmpty) {
      return '--°C';
    }

    final number = double.tryParse(input.trim());
    if (number != null) {
      if (!number.isFinite) {
        return '--°C';
      }
      if (number == number.truncateToDouble()) {
        return '${number.truncate()}°C';
      }
      return '$number°C';
    }

    return '--°C';
  }
}
