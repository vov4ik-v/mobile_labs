import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/auth_cubit.dart';
import 'package:mobile_labs/cubits/flashlight_cubit.dart';
import 'package:mobile_labs/cubits/mqtt_cubit.dart';
import 'package:mobile_labs/cubits/room_cubit.dart';
import 'package:mobile_labs/repositories/local_auth_repository.dart';
import 'package:mobile_labs/repositories/room_repository.dart';
import 'package:mobile_labs/screens/home_page.dart';
import 'package:mobile_labs/screens/profile_page.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final mqttService = MqttService();

  final authRepository = LocalAuthRepository(prefs);
  const roomRepository = HardcodedRoomRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authRepository)),
        BlocProvider(create: (_) => RoomCubit(roomRepository)),
        BlocProvider(create: (_) => MqttCubit(mqttService)),
        BlocProvider(create: (_) => FlashlightCubit()),
      ],
      child: const SmartClimateApp(),
    ),
  );
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
      home: const HomePage(),
      routes: {
        '/home': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
