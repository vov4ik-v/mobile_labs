import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/climate_info_card.dart';
import 'package:mobile_labs/widgets/connection_indicator.dart';
import 'package:mobile_labs/widgets/heating_toggle.dart';
import 'package:mobile_labs/widgets/mode_selector.dart';
import 'package:mobile_labs/widgets/temperature_control_circle.dart';
import 'package:provider/provider.dart';

class RoomDetailPage extends StatefulWidget {
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
  State<RoomDetailPage> createState() =>
      _RoomDetailPageState();
}

class _RoomDetailPageState
    extends State<RoomDetailPage> {
  int _currentTemp = 0;
  StreamSubscription<String>? _tempSub;
  bool _isConnecting = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _currentTemp = widget.temperature;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initMqtt());
  }

  Future<void> _initMqtt() async {
    final mqtt = Provider.of<MqttService>(
      context,
      listen: false,
    );
    final ok = await mqtt.connectAndListen();
    if (!mounted) return;
    setState(() {
      _isConnecting = false;
      _isConnected = ok;
    });
    _tempSub = mqtt.temperatureStream.listen((s) {
      final v = double.tryParse(s);
      if (v != null && mounted) {
        setState(() => _currentTemp = v.round());
      }
    });
  }

  @override
  void dispose() {
    _tempSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
            isConnecting: _isConnecting,
            isConnected: _isConnected,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TemperatureControlCircle(
                current: _currentTemp,
                target: _currentTemp + 1,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  ClimateInfoCard(
                    icon: Icons.water_drop_outlined,
                    label: 'Humidity',
                    value: '${widget.humidity}%',
                  ),
                  ClimateInfoCard(
                    icon: Icons
                        .local_fire_department_outlined,
                    label: 'Heating',
                    value: widget.isHeatingOn
                        ? 'On'
                        : 'Off',
                    isHighlight: widget.isHeatingOn,
                  ),
                  const ClimateInfoCard(
                    icon: Icons
                        .thermostat_auto_outlined,
                    label: 'Mode',
                    value: 'Comfort',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const ModeSelector(),
              const SizedBox(height: 40),
              HeatingToggle(
                isHeatingOn: widget.isHeatingOn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
