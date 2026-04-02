import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/services/mqtt_service.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/climate_info_card.dart';
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
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  int _currentTemp = 0;
  StreamSubscription<String>? _tempSubscription;
  bool _isConnecting = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _currentTemp = widget.temperature;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initMqtt();
    });
  }

  Future<void> _initMqtt() async {
    final mqtt = Provider.of<MqttService>(context, listen: false);
    final connected = await mqtt.connectAndListen();

    if (!mounted) return;

    setState(() {
      _isConnecting = false;
      _isConnected = connected;
    });

    _tempSubscription = mqtt.temperatureStream.listen((tempString) {
      final doubleTemp = double.tryParse(tempString);
      if (doubleTemp != null && mounted) {
        setState(() {
          _currentTemp = doubleTemp.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _tempSubscription?.cancel();
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
          if (_isConnecting)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                color: _isConnected ? Colors.green : Colors.red,
                size: 24,
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClimateInfoCard(
                    icon: Icons.water_drop_outlined,
                    label: 'Humidity',
                    value: '${widget.humidity}%',
                  ),
                  ClimateInfoCard(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Heating',
                    value: widget.isHeatingOn ? 'On' : 'Off',
                    isHighlight: widget.isHeatingOn,
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Heating System',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isHeatingOn
                              ? 'Currently active'
                              : 'Currently inactive',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    CupertinoSwitch(
                      value: widget.isHeatingOn,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
