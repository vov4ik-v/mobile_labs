import 'package:mobile_labs/models/user.dart';

abstract class AuthRepository {
  Future<void> register(User user);

  Future<User?> login(String email, String password);

  Future<User?> getCurrentUser();

  Future<void> updateUser(User user);

  Future<void> deleteUser();

  Future<void> logout();
}
