import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/auth_cubit.dart';
import 'package:mobile_labs/cubits/auth_state.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/utils/validators.dart';
import 'package:mobile_labs/widgets/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    final ne = Validators.validateName(_nameCtrl.text);
    final ee = Validators.validateEmail(_emailCtrl.text);
    final pe = Validators.validatePassword(_passwordCtrl.text);
    final ce = Validators.validateConfirmPassword(
      _confirmCtrl.text,
      _passwordCtrl.text,
    );
    setState(() {
      _nameError = ne;
      _emailError = ee;
      _passwordError = pe;
      _confirmError = ce;
    });
    return ne == null && ee == null && pe == null && ce == null;
  }

  Future<void> _register() async {
    if (!_validate()) return;
    final cubit = context.read<AuthCubit>();
    final user = User(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    final success = await cubit.register(user);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      final msg = switch (cubit.state) {
        AuthError(message: final m) => m,
        _ => 'Registration failed.',
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
            child: RegisterForm(
              nameController: _nameCtrl,
              emailController: _emailCtrl,
              passwordController: _passwordCtrl,
              confirmController: _confirmCtrl,
              nameError: _nameError,
              emailError: _emailError,
              passwordError: _passwordError,
              confirmError: _confirmError,
              isLoading: isLoading,
              onRegister: _register,
              onLoginTap: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}
