import 'dart:convert';

class User {
  final String name;
  final String email;
  final String password;

  const User({
    required this.name,
    required this.email,
    required this.password,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static User? fromJsonString(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    return User.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}
