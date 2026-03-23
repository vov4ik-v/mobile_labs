import 'package:flutter/material.dart';
import 'package:mobile_labs/theme.dart';

class AuthFooterText extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterText({
    required this.question,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
