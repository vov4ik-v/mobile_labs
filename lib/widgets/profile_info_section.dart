import 'package:flutter/material.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/profile_info_tile.dart';

class ProfileInfoSection extends StatelessWidget {
  final User? user;
  final VoidCallback onEditName;

  const ProfileInfoSection({
    required this.user,
    required this.onEditName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          ProfileInfoTile(
            icon: Icons.person_outline,
            title: 'Name',
            subtitle: user?.name ?? 'Unknown',
            onTap: onEditName,
            trailing: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
          const Divider(height: 1, indent: 72),
          ProfileInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: user?.email ?? 'Unknown',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 72),
          ProfileInfoTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
