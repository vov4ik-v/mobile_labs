import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2196F3);
  static const primaryLight = Color(0xFFBBDEFB);
  static const accent = Color(0xFF00BCD4);
  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const divider = Color(0xFFE2E8F0);
  static const heatingOn = Color(0xFFFF7043);
  static const heatingOff = Color(0xFF90A4AE);
}

abstract final class AppShadows {
  static final card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
