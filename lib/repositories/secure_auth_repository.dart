import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';

class SecureAuthRepository implements AuthRepository {
  static const _userDataKey = 'user_data';
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _secureStorage;

  const SecureAuthRepository(this._secureStorage);

  @override
  Future<void> register(User user) async {
    await _secureStorage.write(key: _userDataKey, value: user.toJsonString());
    await _secureStorage.write(key: _tokenKey, value: user.email);
  }

  @override
  Future<User?> login(String email, String password) async {
    final savedUser = await _getSavedUser();
    if (savedUser == null) return null;

    if (savedUser.email == email && savedUser.password == password) {
      await _secureStorage.write(key: _tokenKey, value: email);
      return savedUser;
    }

    return null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token == null) return null;

    final savedUser = await _getSavedUser();
    if (savedUser?.email == token) {
      return savedUser;
    }

    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    await _secureStorage.write(key: _userDataKey, value: user.toJsonString());
  }

  @override
  Future<void> deleteUser() async {
    await _secureStorage.delete(key: _userDataKey);
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<User?> _getSavedUser() async {
    final jsonString = await _secureStorage.read(key: _userDataKey);
    return User.fromJsonString(jsonString);
  }
}
