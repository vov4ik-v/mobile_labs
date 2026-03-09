import 'package:flutter/material.dart';

class TemperatureNavigation extends StatelessWidget {
  final ValueChanged<int> onUpTaped;
  final ValueChanged<int> onDownTaped;

  const TemperatureNavigation(
      {required this.onUpTaped, required this.onDownTaped, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => onDownTaped(3),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            foregroundColor: Colors.white,
          ),
          child: const Icon(Icons.remove, size: 24),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: () => onUpTaped(3),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            foregroundColor: Colors.white,
          ),
          child: const Icon(Icons.add, size: 24),
        ),
      ],
    );
  }
}
