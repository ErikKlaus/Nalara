import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failures.dart';
import '../models/reminder_model.dart';

abstract class ReminderDataSource {
  Stream<List<ReminderModel>> watchReminders(String userId);
  Future<void> createReminder(ReminderModel reminder);
  Future<void> dismissReminder(String userId, String reminderId);
}

class ReminderDataSourceImpl implements ReminderDataSource {
  final FirebaseFirestore firestore;

  ReminderDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _remindersRef(String userId) {
    return firestore.collection('users').doc(userId).collection('reminders');
  }

  @override
  Stream<List<ReminderModel>> watchReminders(String userId) {
    return _remindersRef(userId)
        .orderBy('scheduledAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReminderModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> createReminder(ReminderModel reminder) async {
    try {
      await _remindersRef(reminder.userId)
          .doc(reminder.id)
          .set(reminder.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> dismissReminder(String userId, String reminderId) async {
    try {
      await _remindersRef(userId).doc(reminderId).update({
        'isDismissed': true,
        'dismissedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
