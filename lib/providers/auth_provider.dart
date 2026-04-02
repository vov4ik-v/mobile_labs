import 'package:flutter/material.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _currentUser;
  bool _isLoading = true;
  String? _error;

  AuthProvider(this._authRepository) {
    _init();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _currentUser?.token;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _init() async {
    _currentUser =
        await _authRepository.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.login(
        email,
        password,
      );
      if (_currentUser == null) {
        _error = 'Invalid email or password';
      }
    } on Exception catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _currentUser != null;
  }

  Future<bool> register(User user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.register(user);
      _currentUser = user;
    } on Exception catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _currentUser != null;
  }

  Future<void> updateProfile(User user) async {
    await _authRepository.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await _authRepository.deleteUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }
}
