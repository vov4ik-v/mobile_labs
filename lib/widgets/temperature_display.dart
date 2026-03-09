import 'package:flutter/material.dart';

class TemperatureDisplay extends StatelessWidget {
  final String displayText;
  final Color currentColor;

  const TemperatureDisplay({
    required this.displayText,
    required this.currentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          shape: BoxShape.circle,
          border: Border.all(
            color: currentColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: currentColor.withValues(alpha: 0.05),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 500),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w800,
              color: currentColor,
              shadows: [
                Shadow(
                  color: currentColor.withValues(alpha: 0.6),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Text(displayText, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
