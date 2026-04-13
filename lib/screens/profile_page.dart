// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/auth_cubit.dart';
import 'package:mobile_labs/cubits/auth_state.dart';
import 'package:mobile_labs/utils/profile_dialogs.dart';
import 'package:mobile_labs/widgets/profile_actions.dart';
import 'package:mobile_labs/widgets/profile_header.dart';
import 'package:mobile_labs/widgets/profile_info_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _editName(BuildContext context) async {
    final cubit = context.read<AuthCubit>();
    final user = cubit.currentUser;
    if (user == null) return;

    final newName = await showEditNameDialog(context, user.name);
    if (newName == null) return;
    await cubit.updateProfile(user.copyWith(name: newName));
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Log Out',
      content: 'Are you sure you want to log out?',
      confirmText: 'Log Out',
    );
    if (!confirmed) return;

    await context.read<AuthCubit>().logout();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Account',
      content: 'Are you sure? This cannot be undone.',
      confirmText: 'Delete',
    );
    if (!confirmed) return;

    await context.read<AuthCubit>().deleteUser();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = switch (state) {
          AuthAuthenticated(user: final u) => u,
          _ => null,
        };
        return Scaffold(
          appBar: AppBar(title: const Text('Profile'), centerTitle: true),
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
                  onEditName: () => _editName(context),
                ),
                const SizedBox(height: 32),
                ProfileActions(
                  onLogout: () => _logout(context),
                  onDelete: () => _deleteAccount(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
