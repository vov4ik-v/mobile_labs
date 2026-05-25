import 'package:flutter/material.dart';

class IconMapper {
  const IconMapper._();

  static const Map<String, IconData> _icons = {
    'chair_outlined': Icons.chair_outlined,
    'bed_outlined': Icons.bed_outlined,
    'soup_kitchen_outlined': Icons.soup_kitchen_outlined,
    'desk_outlined': Icons.desk_outlined,
    'living': Icons.chair_outlined,
    'bedroom': Icons.bed_outlined,
    'kitchen': Icons.soup_kitchen_outlined,
    'office': Icons.desk_outlined,
  };

  static IconData fromString(String name) {
    return _icons[name] ?? Icons.room_outlined;
  }
}
