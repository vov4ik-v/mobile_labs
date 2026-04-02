import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/auth_state.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    _init();
  }

  User? get currentUser => switch (state) {
    AuthAuthenticated(user: final u) => u,
    _ => null,
  };

  String? get token => currentUser?.token;

  Future<void> _init() async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<bool> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
        return true;
      }
      emit(const AuthError('Invalid email or password'));
      return false;
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<bool> register(User user) async {
    emit(const AuthLoading());
    try {
      await _authRepository.register(user);
      emit(AuthAuthenticated(user));
      return true;
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<void> updateProfile(User user) async {
    await _authRepository.updateUser(user);
    emit(AuthAuthenticated(user));
  }

  Future<void> deleteUser() async {
    await _authRepository.deleteUser();
    emit(const AuthUnauthenticated());
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
