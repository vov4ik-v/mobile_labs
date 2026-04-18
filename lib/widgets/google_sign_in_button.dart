// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  final bool isLoading;

  const GoogleSignInButton({
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => _signIn(context),
        icon: const Icon(Icons.g_mobiledata, size: 28),
        label: const Text('Sign in with Google'),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    final success = await authProvider.signInWithGoogle();

    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      final error =
          authProvider.error ?? 'Google sign-in failed.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
