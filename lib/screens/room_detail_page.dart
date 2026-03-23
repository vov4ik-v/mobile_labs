import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/climate_info_card.dart';
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
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TemperatureControlCircle(
                current: temperature,
                target: temperature + 1,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  ClimateInfoCard(
                    icon: Icons.water_drop_outlined,
                    label: 'Humidity',
                    value: '$humidity%',
                  ),
                  ClimateInfoCard(
                    icon: Icons
                        .local_fire_department_outlined,
                    label: 'Heating',
                    value: isHeatingOn ? 'On' : 'Off',
                    isHighlight: isHeatingOn,
                  ),
                  const ClimateInfoCard(
                    icon:
                        Icons.thermostat_auto_outlined,
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
                  borderRadius:
                      BorderRadius.circular(24),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Heating System',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isHeatingOn
                              ? 'Currently active'
                              : 'Currently inactive',
                          style: const TextStyle(
                            fontSize: 14,
                            color:
                                AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    CupertinoSwitch(
                      value: isHeatingOn,
                      activeTrackColor:
                          AppColors.primary,
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
