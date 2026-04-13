import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Mode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ModeTab(label: 'Comfort', isActive: true, icon: Icons.weekend),
            _ModeTab(label: 'Eco', isActive: false, icon: Icons.eco),
            _ModeTab(
              label: 'Away',
              isActive: false,
              icon: Icons.directions_run,
            ),
            _ModeTab(
              label: 'Off',
              isActive: false,
              icon: Icons.power_settings_new,
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final IconData icon;

  const _ModeTab({
    required this.label,
    required this.isActive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive ? AppShadows.card : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
