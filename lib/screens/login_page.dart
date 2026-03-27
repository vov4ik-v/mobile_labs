import 'package:flutter/material.dart';
import 'package:mobile_labs/repositories/local_auth_repository.dart';
import 'package:mobile_labs/utils/validators.dart';
import 'package:mobile_labs/widgets/app_logo.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final emailError = Validators.validateEmail(
      _emailController.text,
    );
    final passwordError = Validators.validatePassword(
      _passwordController.text,
    );

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    return emailError == null && passwordError == null;
  }

  Future<void> _login() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(prefs);

    final user = await repository.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email or password. '
            'Please try again.',
          ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
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
                  text: _isLoading
                      ? 'Logging In...'
                      : 'Log In',
                  onPressed:
                      _isLoading ? () {} : _login,
                ),
                const SizedBox(height: 16),
                AuthFooterText(
                  question: "Don't have an account?",
                  actionText: 'Sign Up',
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/register',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
