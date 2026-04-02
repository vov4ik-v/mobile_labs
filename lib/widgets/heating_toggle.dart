import 'package:flutter/cupertino.dart';
import 'package:mobile_labs/theme.dart';

class HeatingToggle extends StatelessWidget {
  final bool isHeatingOn;
  final ValueChanged<bool>? onChanged;

  const HeatingToggle({
    required this.isHeatingOn,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isHeatingOn
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
            value: isHeatingOn,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged ?? (_) {},
          ),
        ],
      ),
    );
  }
}
