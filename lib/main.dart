import 'package:flutter/material.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/screens/login_page.dart';
import 'package:mobile_labs/screens/profile_page.dart';
import 'package:mobile_labs/screens/register_page.dart';
import 'package:mobile_labs/screens/room_detail_page.dart';
import 'package:mobile_labs/theme.dart';

void main() {
  runApp(const SmartClimateApp());
}

class SmartClimateApp extends StatelessWidget {
  const SmartClimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Climate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/room-detail': (_) =>
            const RoomDetailPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
