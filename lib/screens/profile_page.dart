// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/utils/profile_dialogs.dart';
import 'package:mobile_labs/widgets/primary_button.dart';
import 'package:mobile_labs/widgets/profile_header.dart';
import 'package:mobile_labs/widgets/profile_info_section.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _editName() async {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    final user = auth.currentUser;
    if (user == null) return;

    final newName = await showEditNameDialog(
      context,
      user.name,
    );

    if (!context.mounted || newName == null) return;
    await auth.updateProfile(
      user.copyWith(name: newName),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Log Out',
      content: 'Are you sure you want to log out?',
      confirmText: 'Log Out',
    );
    if (!confirmed || !context.mounted) return;

    await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).logout();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Account',
      content:
          'Are you sure? This cannot be undone.',
      confirmText: 'Delete',
    );
    if (!confirmed || !context.mounted) return;

    await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).deleteUser();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                ProfileHeader(
                  name: user?.name ?? 'Unknown',
                  email: user?.email ?? '',
                ),
                const SizedBox(height: 32),
                ProfileInfoSection(
                  user: user,
                  onEditName: _editName,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'Log Out',
                        onPressed: _logout,
                      ),
                      const SizedBox(height: 16),
                      _buildDeleteButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton() => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: _deleteAccount,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.redAccent,
            side: const BorderSide(color: Colors.redAccent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text('Delete Account'),
        ),
      );
}
