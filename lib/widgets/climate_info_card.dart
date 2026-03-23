import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';

class ClimateInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlight;

  const ClimateInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isHighlight ? Colors.white : AppColors.primary,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isHighlight
                  ? AppColors.primaryLight
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
