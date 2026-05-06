import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/auth_user.dart';

abstract class UserProfileDataSource {
  Future<void> createUserProfile(AuthUser user, {String language});
  Future<Map<String, dynamic>?> getUserProfile(String uid);
}

class UserProfileDataSourceImpl implements UserProfileDataSource {
  final FirebaseFirestore firestore;

  UserProfileDataSourceImpl({required this.firestore});

  @override
  Future<void> createUserProfile(
    AuthUser user, {
    String language = 'id',
  }) async {
    final ref = firestore.collection('users').doc(user.id);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.update({'updatedAt': FieldValue.serverTimestamp()});
      return;
    }

    await ref.set({
      'uid': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'language': language,
      'onboardingDone': false,
      'currentStreak': 0,
      'longestStreak': 0,
      'lastActiveDate': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return null;
    return snapshot.data();
  }
}
