import 'package:flutter/material.dart';
import 'package:mobile_labs/widgets/app_logo.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
                const SizedBox(height: 40),
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
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Log In',
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                ),
                const SizedBox(height: 16),
                AuthFooterText(
                  question: "Don't have an account?",
                  actionText: 'Sign Up',
                  onTap: () => Navigator.pushNamed(context, '/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
