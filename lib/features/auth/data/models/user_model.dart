import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_user.dart';

class UserModel extends AuthUser {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'User',
      photoUrl: user.photoURL,
    );
  }
}
