import 'dart:convert';

import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthRepository implements AuthRepository {
  static const _usersDataKey = 'users_data';
  static const _currentEmailKey = 'current_user_email';

  final SharedPreferences _prefs;

  const LocalAuthRepository(this._prefs);

  List<User> _getSavedUsers() {
    final jsonString = _prefs.getString(_usersDataKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveUsers(List<User> users) async {
    final jsonList = users.map((user) => user.toJson()).toList();
    await _prefs.setString(_usersDataKey, jsonEncode(jsonList));
  }

  @override
  Future<void> register(User user) async {
    final users = _getSavedUsers();

    if (users.any((u) => u.email == user.email)) {
      throw Exception('Користувач з таким email вже існує');
    }

    users.add(user);
    await _saveUsers(users);
    await _prefs.setString(_currentEmailKey, user.email);
  }

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    final users = _getSavedUsers();

    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      await _prefs.setString(_currentEmailKey, email);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final currentEmail = _prefs.getString(_currentEmailKey);
    if (currentEmail == null) return null;

    final users = _getSavedUsers();
    try {
      return users.firstWhere((u) => u.email == currentEmail);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    final users = _getSavedUsers();
    final index = users.indexWhere((u) => u.email == user.email);

    if (index != -1) {
      users[index] = user;
      await _saveUsers(users);
    }
  }

  @override
  Future<void> deleteUser() async {
    final currentEmail = _prefs.getString(_currentEmailKey);
    if (currentEmail == null) return;

    final users = _getSavedUsers();
    users.removeWhere((u) => u.email == currentEmail);
    await _saveUsers(users);
    await _prefs.remove(_currentEmailKey);
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_currentEmailKey);
  }

}
