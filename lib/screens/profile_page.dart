import 'package:flutter/material.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/local_auth_repository.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/utils/validators.dart';
import 'package:mobile_labs/widgets/primary_button.dart';
import 'package:mobile_labs/widgets/profile_info_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(prefs);
    final user = await repository.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _editName() async {
    final controller = TextEditingController(
      text: _user?.name ?? '',
    );
    String? errorText;

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Name'),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: errorText,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final validation =
                        Validators.validateName(
                      controller.text,
                    );
                    if (validation != null) {
                      setDialogState(
                        () => errorText = validation,
                      );
                      return;
                    }
                    Navigator.pop(
                      dialogContext,
                      controller.text.trim(),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (!mounted) return;

    if (newName != null && _user != null) {
      final updatedUser = _user!.copyWith(name: newName);
      final prefs =
          await SharedPreferences.getInstance();
      final repository = LocalAuthRepository(prefs);
      await repository.updateUser(updatedUser);
      setState(() => _user = updatedUser);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(prefs);
    await repository.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete '
            'your account? This action cannot '
            'be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final prefs =
          await SharedPreferences.getInstance();
      final repository = LocalAuthRepository(prefs);
      await repository.deleteUser();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            _ProfileHeader(
              name: _user?.name ?? 'Unknown',
              email: _user?.email ?? '',
            ),
            const SizedBox(height: 32),
            Container(
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
                    subtitle:
                        _user?.name ?? 'Unknown',
                    onTap: _editName,
                    trailing: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 72,
                  ),
                  ProfileInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle:
                        _user?.email ?? 'Unknown',
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    indent: 72,
                  ),
                  ProfileInfoTile(
                    icon: Icons
                        .thermostat_auto_outlined,
                    title: 'Preferred Mode',
                    subtitle: 'Comfort',
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    indent: 72,
                  ),
                  ProfileInfoTile(
                    icon: Icons.info_outline,
                    title: 'App Version',
                    subtitle: '1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: PrimaryButton(
                text: 'Log Out',
                onPressed: _logout,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _deleteAccount,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(
                      color: Colors.redAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Delete Account'),
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
  final String name;
  final String email;

  const _ProfileHeader({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            Icons.person,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
