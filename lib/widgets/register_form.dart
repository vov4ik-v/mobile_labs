import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final bool isLoading;
  final VoidCallback onRegister;
  final VoidCallback onLoginTap;

  const RegisterForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.isLoading,
    required this.onRegister,
    required this.onLoginTap,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmError,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 40),
        CustomTextField(
          label: 'Name',
          icon: Icons.person_outline,
          controller: nameController,
          errorText: nameError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          controller: emailController,
          errorText: emailError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
          controller: passwordController,
          errorText: passwordError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Confirm Password',
          icon: Icons.lock_outline,
          isPassword: true,
          controller: confirmController,
          errorText: confirmError,
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: isLoading ? 'Signing Up...' : 'Sign Up',
          onPressed: isLoading ? () {} : onRegister,
        ),
        const SizedBox(height: 24),
        AuthFooterText(
          question: 'Already have an account?',
          actionText: 'Log In',
          onTap: onLoginTap,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
