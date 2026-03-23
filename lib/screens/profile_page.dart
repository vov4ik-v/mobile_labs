import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/primary_button.dart';
import 'package:mobile_labs/widgets/profile_info_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _ProfileHeader(),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  ProfileInfoTile(
                    icon: Icons.person_outline,
                    title: 'Account Info',
                    subtitle: 'volodymyr@example.com',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  ProfileInfoTile(
                    icon: Icons.thermostat_auto_outlined,
                    title: 'Preferred Mode',
                    subtitle: 'Comfort',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  ProfileInfoTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications',
                    subtitle: 'On',
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
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: PrimaryButton(
                text: 'Log Out',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            Icons.person,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Volodymyr',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Smart Home Owner',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
