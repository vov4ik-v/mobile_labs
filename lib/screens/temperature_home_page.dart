import 'package:flutter/material.dart';
import 'package:mobile_labs/utils/temperature_logic.dart';
import 'package:mobile_labs/widgets/temperature_display.dart';
import 'package:mobile_labs/widgets/temperature_input.dart';
import 'package:mobile_labs/widgets/temperature_navigation.dart';

class TemperatureHomePage extends StatefulWidget {
  const TemperatureHomePage({super.key});

  @override
  State<TemperatureHomePage> createState() => _TemperatureHomePageState();
}

class _TemperatureHomePageState extends State<TemperatureHomePage> {
  String _inputText = '';
  int _topPadding = 0;
  int _bottomPadding = 0;

  @override
  Widget build(BuildContext context) {
    final currentColor = TemperatureLogic.getTextColor(_inputText);
    final displayText = TemperatureLogic.getDisplayText(_inputText);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(height: _topPadding.toDouble()),
                      TemperatureDisplay(
                        displayText: displayText,
                        currentColor: currentColor,
                      ),
                      SizedBox(height: _bottomPadding.toDouble()),
                      TemperatureNavigation(
                        onUpTaped: (value) => setState(() {
                          _bottomPadding += value;
                        }),
                        onDownTaped: (value) => setState(() {
                          _topPadding += value;
                        }),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TemperatureInput(
                            initialValue: _inputText,
                            onChanged: (value) =>
                                setState(() => _inputText = value),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
