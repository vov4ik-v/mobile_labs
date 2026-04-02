import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/auth_cubit.dart';
import 'package:mobile_labs/cubits/auth_state.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/utils/validators.dart';
import 'package:mobile_labs/widgets/app_logo.dart';
import 'package:mobile_labs/widgets/auth_footer_text.dart';
import 'package:mobile_labs/widgets/custom_text_field.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    final ee = Validators.validateEmail(_emailCtrl.text);
    final pe = Validators.validatePassword(_passwordCtrl.text);
    setState(() {
      _emailError = ee;
      _passwordError = pe;
    });
    return ee == null && pe == null;
  }

  Future<void> _login() async {
    if (!_validate()) return;
    final cubit = context.read<AuthCubit>();
    final success = await cubit.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      final msg = switch (cubit.state) {
        AuthError(message: final m) => m,
        _ => 'Invalid email or password.',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthCubit>().state is AuthLoading;

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
                  controller: _emailCtrl,
                  errorText: _emailError,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordCtrl,
                  errorText: _passwordError,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: isLoading ? 'Logging In...' : 'Log In',
                  onPressed: isLoading ? () {} : _login,
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
