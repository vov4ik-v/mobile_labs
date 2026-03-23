import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthRepository implements AuthRepository {
  static const _userDataKey = 'user_data';
  static const _currentEmailKey = 'current_user_email';

  final SharedPreferences _prefs;

  const LocalAuthRepository(this._prefs);

  @override
  Future<void> register(User user) async {
    await _prefs.setString(
      _userDataKey,
      user.toJsonString(),
    );
    await _prefs.setString(_currentEmailKey, user.email);
  }

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    final savedUser = _getSavedUser();
    if (savedUser == null) return null;

    if (savedUser.email == email &&
        savedUser.password == password) {
      await _prefs.setString(_currentEmailKey, email);
      return savedUser;
    }

    return null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final currentEmail = _prefs.getString(_currentEmailKey);
    if (currentEmail == null) return null;

    final savedUser = _getSavedUser();
    if (savedUser?.email == currentEmail) {
      return savedUser;
    }

    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    await _prefs.setString(
      _userDataKey,
      user.toJsonString(),
    );
  }

  @override
  Future<void> deleteUser() async {
    await _prefs.remove(_userDataKey);
    await _prefs.remove(_currentEmailKey);
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_currentEmailKey);
  }

  User? _getSavedUser() {
    final jsonString = _prefs.getString(_userDataKey);
    return User.fromJsonString(jsonString);
  }
}
