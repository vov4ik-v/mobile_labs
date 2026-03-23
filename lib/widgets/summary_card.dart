import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';

class SummaryCard extends StatelessWidget {
  final String temperature;
  final String humidity;
  final String mode;
  final String heatingStatus;

  const SummaryCard({
    required this.temperature,
    required this.humidity,
    required this.mode,
    required this.heatingStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Average Temperature',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temperature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.waves,
                color: Colors.white,
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: humidity,
              ),
              _StatItem(
                icon: Icons.thermostat_auto_outlined,
                label: 'System',
                value: mode,
              ),
              _StatItem(
                icon: Icons.local_fire_department_outlined,
                label: 'Heating',
                value: heatingStatus,
                valueColor: heatingStatus == 'On'
                    ? Colors.white
                    : AppColors.primaryLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryLight, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryLight,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
