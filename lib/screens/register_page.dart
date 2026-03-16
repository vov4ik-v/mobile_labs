import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join Smart Climate today',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                const CustomTextField(
                  label: 'Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Confirm Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Sign Up',
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                const SizedBox(height: 24),
                AuthFooterText(
                  question: 'Already have an account?',
                  actionText: 'Log In',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
