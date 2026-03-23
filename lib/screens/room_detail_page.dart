import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/climate_info_card.dart';
import 'package:mobile_labs/widgets/mode_selector.dart';
import 'package:mobile_labs/widgets/temperature_control_circle.dart';

class RoomDetailPage extends StatelessWidget {
  const RoomDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Living Room'),
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
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const TemperatureControlCircle(current: 23, target: 24),
              const SizedBox(height: 32),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClimateInfoCard(
                    icon: Icons.water_drop_outlined,
                    label: 'Humidity',
                    value: '45%',
                  ),
                  ClimateInfoCard(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Heating',
                    value: 'On',
                    isHighlight: true,
                  ),
                  ClimateInfoCard(
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Heating System',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Currently active',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    CupertinoSwitch(
                      value: true,
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
