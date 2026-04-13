import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/mqtt_cubit.dart';
import 'package:mobile_labs/cubits/mqtt_state.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/climate_info_card.dart';
import 'package:mobile_labs/widgets/connection_indicator.dart';
import 'package:mobile_labs/widgets/heating_toggle.dart';
import 'package:mobile_labs/widgets/mode_selector.dart';
import 'package:mobile_labs/widgets/temperature_control_circle.dart';

class RoomDetailPage extends StatelessWidget {
  final String name;
  final int temperature;
  final int humidity;
  final bool isHeatingOn;

  const RoomDetailPage({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.isHeatingOn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttCubit, MqttState>(
      builder: (context, mqttState) {
        final isConnecting = mqttState is MqttConnecting;
        final isConnected = mqttState is MqttConnected;
        final currentTemp = switch (mqttState) {
          MqttConnected(temperature: final t) =>
            double.tryParse(t)?.round() ?? temperature,
          _ => temperature,
        };

        return Scaffold(
          appBar: AppBar(
            title: Text(name),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              ConnectionIndicator(
                isConnecting: isConnecting,
                isConnected: isConnected,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TemperatureControlCircle(
                    current: currentTemp,
                    target: currentTemp + 1,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClimateInfoCard(
                        icon: Icons.water_drop_outlined,
                        label: 'Humidity',
                        value: '$humidity%',
                      ),
                      ClimateInfoCard(
                        icon: Icons.local_fire_department_outlined,
                        label: 'Heating',
                        value: isHeatingOn ? 'On' : 'Off',
                        isHighlight: isHeatingOn,
                      ),
                      const ClimateInfoCard(
                        icon: Icons.thermostat_auto_outlined,
                        label: 'Mode',
                        value: 'Comfort',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const ModeSelector(),
                  const SizedBox(height: 40),
                  HeatingToggle(isHeatingOn: isHeatingOn),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
