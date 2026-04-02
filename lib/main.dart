import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/providers/auth_provider.dart';
import 'package:mobile_labs/providers/room_provider.dart';
import 'package:mobile_labs/repositories/api_auth_repository.dart';
import 'package:mobile_labs/repositories/room_repository.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/screens/login_page.dart';
import 'package:mobile_labs/screens/profile_page.dart';
import 'package:mobile_labs/screens/register_page.dart';
import 'package:mobile_labs/services/api_service.dart';
import 'package:mobile_labs/services/connectivity_service.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  final connectivity = ConnectivityService();

  final authRepository = ApiAuthRepository(
    apiService,
    connectivity,
    secureStorage,
  );

  final roomRepository = CachedRoomRepository(
    apiService,
    connectivity,
    prefs,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RoomProvider(roomRepository),
        ),
        Provider(create: (_) => connectivity),
        Provider(
          create: (_) => MqttService(),
          dispose: (_, mqtt) => mqtt.dispose(),
        ),
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
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'Smart Climate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor:
                AppColors.background,
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
