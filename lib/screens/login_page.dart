// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/utils/validators.dart';
import 'package:mobile_labs/widgets/app_logo.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/google_sign_in_button.dart';
import 'package:mobile_labs/widgets/or_divider.dart';
import 'package:mobile_labs/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final emailError = Validators.validateEmail(_emailController.text);
    final passwordError = Validators.validatePassword(_passwordController.text);

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    return emailError == null && passwordError == null;
  }

  Future<void> _login() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    if (!context.mounted) return;
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!context.mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      final error = authProvider.error ??
          'Invalid email or password.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

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
                CustomTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  errorText: _emailError,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                  errorText: _passwordError,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: _isLoading ? 'Logging In...' : 'Log In',
                  onPressed: _isLoading ? () {} : _login,
                ),
                const SizedBox(height: 16),
                const OrDivider(),
                const SizedBox(height: 16),
                GoogleSignInButton(
                  isLoading: _isLoading,
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
