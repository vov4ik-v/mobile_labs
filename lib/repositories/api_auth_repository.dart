import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';
import 'package:mobile_labs/services/api_service.dart';
import 'package:mobile_labs/services/connectivity_service.dart';

class ApiAuthRepository implements AuthRepository {
  static const _userDataKey = 'user_data';
  static const _tokenKey = 'auth_token';

  final ApiService _apiService;
  final ConnectivityService _connectivity;
  final FlutterSecureStorage _secureStorage;

  const ApiAuthRepository(
    this._apiService,
    this._connectivity,
    this._secureStorage,
  );

  @override
  Future<void> register(User user) async {
    final isOnline = await _connectivity.hasConnection();

    if (isOnline) {
      final response = await _apiService.register(
        user.name,
        user.email,
        user.password,
      );
      final token = response['token'] as String;
      await _saveLocally(user, token);
    } else {
      throw const ApiException('No internet connection');
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    final isOnline = await _connectivity.hasConnection();

    if (isOnline) {
      final response = await _apiService.login(email, password);
      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;
      final user = User(
        name: userData['name'] as String,
        email: userData['email'] as String,
        password: password,
        token: token,
      );
      await _saveLocally(user, token);
      return user;
    }

    return _loginOffline(email, password);
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token == null) return null;

    final jsonString = await _secureStorage.read(key: _userDataKey);
    final user = User.fromJsonString(jsonString);
    return user?.copyWith(token: token);
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

  Future<void> _saveLocally(User user, String token) async {
    await _secureStorage.write(key: _userDataKey, value: user.toJsonString());
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<User?> _loginOffline(String email, String password) async {
    final jsonString = await _secureStorage.read(key: _userDataKey);
    final savedUser = User.fromJsonString(jsonString);
    if (savedUser?.email == email && savedUser?.password == password) {
      final token = await _secureStorage.read(key: _tokenKey);
      return savedUser?.copyWith(token: token);
    }
    return null;
  }
}
