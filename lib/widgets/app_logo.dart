import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.thermostat,
            size: 44,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Smart Climate',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Control your home comfort easily',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
