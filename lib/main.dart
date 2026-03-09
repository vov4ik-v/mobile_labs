import 'package:flutter/material.dart';
import 'package:mobile_labs/screens/temperature_home_page.dart';

void main() {
  runApp(const TemperatureSimulatorApp());
}

class TemperatureSimulatorApp extends StatelessWidget {
  const TemperatureSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Simulator',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF16161E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TemperatureHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
