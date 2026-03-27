import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/repositories/secure_auth_repository.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/screens/login_page.dart';
import 'package:mobile_labs/screens/profile_page.dart';
import 'package:mobile_labs/screens/register_page.dart';
import 'package:mobile_labs/services/connectivity_service.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  final authRepository = SecureAuthRepository(prefs, secureStorage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        Provider(create: (_) => ConnectivityService()),
        Provider(create: (_) => MqttService()),
      ],
      child: const SmartClimateApp(),
    ),
  );
}

class SmartClimateApp extends StatelessWidget {
  const SmartClimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          title: 'Smart Climate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: AppColors.textPrimary,
            ),
            useMaterial3: true,
          ),
          home: authProvider.isAuthenticated
              ? const HomePage()
              : const LoginPage(),
          routes: {
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
            '/home': (_) => const HomePage(),
            '/profile': (_) => const ProfilePage(),
          },
        );
      },
    );
  }
}
