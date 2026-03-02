import 'package:flutter/material.dart';
import 'package:mobile_labs/utils/temperature_logic.dart';
import 'package:mobile_labs/widgets/temperature_display.dart';
import 'package:mobile_labs/widgets/temperature_input.dart';

class TemperatureHomePage extends StatefulWidget {
  const TemperatureHomePage({super.key});

  @override
  State<TemperatureHomePage> createState() => _TemperatureHomePageState();
}

class _TemperatureHomePageState extends State<TemperatureHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _inputText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = TemperatureLogic.getTextColor(_inputText);
    final displayText = TemperatureLogic.getDisplayText(_inputText);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.thermostat,
                      color: currentColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Temperature',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              TemperatureDisplay(
                displayText: displayText,
                currentColor: currentColor,
              ),

              const Spacer(),

              TemperatureInput(
                controller: _controller,
                onChanged: (value) => setState(() => _inputText = value),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
