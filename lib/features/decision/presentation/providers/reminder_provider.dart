import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/reminder_data_source.dart';
import '../../domain/entities/reminder.dart';

final reminderDataSourceProvider = Provider<ReminderDataSource>((ref) {
  return ReminderDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final remindersStreamProvider = StreamProvider.autoDispose<List<Reminder>>((
  ref,
) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return const Stream.empty();

  return ref.watch(reminderDataSourceProvider).watchReminders(authUser.id);
});

final reminderControllerProvider =
    StateNotifierProvider<ReminderController, AsyncValue<void>>((ref) {
      return ReminderController(ref.watch(reminderDataSourceProvider), ref);
    });

class ReminderController extends StateNotifier<AsyncValue<void>> {
  final ReminderDataSource _dataSource;
  final Ref _ref;

  ReminderController(this._dataSource, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> dismissReminder(String reminderId) async {
    final authUser = _ref.read(authStateProvider).value;
    if (authUser == null) {
      state = AsyncValue.error(
        const AuthFailure('Authentication required'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();
    try {
      await _dataSource.dismissReminder(authUser.id, reminderId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
