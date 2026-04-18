import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';
import 'package:mobile_labs/widgets/summary_card.dart';

class HomeHeader extends StatelessWidget {
  final String displayName;
  final String avgTemperature;
  final VoidCallback onProfileTap;
  final VoidCallback onResetLongPress;

  const HomeHeader({
    required this.displayName,
    required this.avgTemperature,
    required this.onProfileTap,
    required this.onResetLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Hello, $displayName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onProfileTap,
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      AppColors.primaryLight,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onLongPress: onResetLongPress,
            child: SummaryCard(
              temperature: avgTemperature,
              humidity: '48%',
              mode: 'Comfort',
              heatingStatus: 'On',
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Rooms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
