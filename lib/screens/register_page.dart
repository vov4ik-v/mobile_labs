import 'package:flutter/material.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/local_auth_repository.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/utils/validators.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final nameError = Validators.validateName(
      _nameController.text,
    );
    final emailError = Validators.validateEmail(
      _emailController.text,
    );
    final passwordError = Validators.validatePassword(
      _passwordController.text,
    );
    final confirmError = Validators.validateConfirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmError;
    });

    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmError == null;
  }

  Future<void> _register() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(prefs);

    final user = User(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      await repository.register(user);

      if (!mounted) return;

      setState(() => _isLoading = false);

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

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
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
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
                CustomTextField(
                  label: 'Name',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  errorText: _nameError,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirm Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _confirmPasswordController,
                  errorText: _confirmPasswordError,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: _isLoading ? 'Signing Up...' : 'Sign Up',
                  onPressed: _isLoading ? () {} : _register,
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
