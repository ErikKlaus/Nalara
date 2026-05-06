import '../entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;
  Future<AuthUser> signInWithGoogle();
  Future<void> signOut();
  AuthUser? get currentUser;
}
