import 'dart:convert';

class Room {
  final int id;
  final String name;
  final String icon;
  final double temperature;
  final int humidity;
  final bool isHeatingOn;

  const Room({
    required this.id,
    required this.name,
    required this.icon,
    required this.temperature,
    required this.humidity,
    required this.isHeatingOn,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'chair_outlined',
      temperature: (json['temperature'] as num).toDouble(),
      humidity: json['humidity'] as int,
      isHeatingOn: json['isHeatingOn'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'temperature': temperature,
      'humidity': humidity,
      'isHeatingOn': isHeatingOn,
    };
  }

  static List<Room> fromJsonList(String jsonString) {
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map(
          (item) => Room.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  static String toJsonList(List<Room> rooms) {
    return jsonEncode(rooms.map((r) => r.toJson()).toList());
  }
}
