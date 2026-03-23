import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }
}
