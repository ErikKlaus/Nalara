import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/decision.dart';
import '../../domain/repositories/decision_repository.dart';
import '../../data/datasources/decision_local_data_source.dart';
import '../../data/datasources/decision_remote_data_source.dart';
import '../../data/repositories/decision_repository_impl.dart';
import '../../data/models/decision_model.dart';

final decisionLocalDataSourceProvider = Provider<DecisionLocalDataSource>((
  ref,
) {
  return DecisionLocalDataSourceImpl(
    decisionBox: Hive.box<DecisionModel>(HiveConstants.decisionBox),
    outboxBox: Hive.box<DecisionModel>(HiveConstants.outboxBox),
  );
});

final decisionRemoteDataSourceProvider = Provider<DecisionRemoteDataSource>((
  ref,
) {
  return DecisionRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final decisionRepositoryProvider = Provider<DecisionRepository>((ref) {
  return DecisionRepositoryImpl(
    remoteDataSource: ref.watch(decisionRemoteDataSourceProvider),
    localDataSource: ref.watch(decisionLocalDataSourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

final decisionsStreamProvider = StreamProvider.autoDispose<List<Decision>>((
  ref,
) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return const Stream.empty();

  return ref.watch(decisionRepositoryProvider).watchDecisions(authUser.id);
});
