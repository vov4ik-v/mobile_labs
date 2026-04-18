import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_labs/models/user.dart';
import 'package:mobile_labs/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  static const _userDataKey = 'user_data';

  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;

  const FirebaseAuthRepository(
    this._firebaseAuth,
    this._googleSignIn,
    this._secureStorage,
  );

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final fbUser = userCredential.user;
    if (fbUser == null) return null;

    final user = User(
      name: fbUser.displayName ?? 'User',
      email: fbUser.email ?? '',
      password: '',
      token: await fbUser.getIdToken(),
    );

    await _saveLocally(user);
    return user;
  }

  @override
  Future<void> register(User user) async {
    final credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    await credential.user?.updateDisplayName(user.name);
    final token = await credential.user?.getIdToken();
    await _saveLocally(user.copyWith(token: token));
  }

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    final credential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = credential.user;
    if (fbUser == null) return null;

    final user = User(
      name: fbUser.displayName ?? 'User',
      email: email,
      password: password,
      token: await fbUser.getIdToken(),
    );
    await _saveLocally(user);
    return user;
  }

  @override
  Future<User?> getCurrentUser() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser != null) {
      return User(
        name: fbUser.displayName ?? 'User',
        email: fbUser.email ?? '',
        password: '',
        token: await fbUser.getIdToken(),
      );
    }
    final jsonString =
        await _secureStorage.read(key: _userDataKey);
    return User.fromJsonString(jsonString);
  }

  @override
  Future<void> updateUser(User user) async {
    await _secureStorage.write(
      key: _userDataKey,
      value: user.toJsonString(),
    );
  }

  @override
  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser?.delete();
    await _secureStorage.delete(key: _userDataKey);
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _secureStorage.delete(key: _userDataKey);
  }

  Future<void> _saveLocally(User user) async {
    await _secureStorage.write(
      key: _userDataKey,
      value: user.toJsonString(),
    );
  }
}
