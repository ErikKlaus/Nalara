import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/decision.dart';
import '../../domain/repositories/decision_repository.dart';
import '../datasources/decision_local_data_source.dart';
import '../datasources/decision_remote_data_source.dart';
import '../models/decision_model.dart';

class DecisionRepositoryImpl implements DecisionRepository {
  final DecisionRemoteDataSource remoteDataSource;
  final DecisionLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  DecisionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Stream<List<Decision>> watchDecisions(String userId) {
    return remoteDataSource.watchDecisions(userId).map((models) {
      localDataSource.cacheDecisions(models);
      return models;
    });
  }

  @override
  Future<void> addDecision(Decision decision) async {
    final isConnected = await connectivityService.isConnected;
    final model = DecisionModel.fromEntity(decision);

    if (isConnected) {
      await remoteDataSource.addDecision(model);
    } else {
      final offlineModel = DecisionModel(
        id: model.id,
        userId: model.userId,
        status: model.status,
        inputText: model.inputText,
        category: model.category,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        notes: model.notes,
        expiresAt: model.expiresAt,
        isSynced: false,
        resultJson: model.resultJson,
      );
      await localDataSource.addDecisionToOutbox(offlineModel);
    }
  }

  @override
  Future<void> updateDecision(Decision decision) async {
    final isConnected = await connectivityService.isConnected;
    final model = DecisionModel.fromEntity(decision);

    if (isConnected) {
      await remoteDataSource.updateDecision(model);
    } else {
      final offlineModel = DecisionModel(
        id: model.id,
        userId: model.userId,
        status: model.status,
        inputText: model.inputText,
        category: model.category,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        notes: model.notes,
        expiresAt: model.expiresAt,
        isSynced: false,
        resultJson: model.resultJson,
      );
      await localDataSource.addDecisionToOutbox(offlineModel);
    }
  }

  @override
  Future<void> syncOfflineDecisions(String userId) async {
    final outboxDecisions = localDataSource
        .getOutboxDecisions()
        .where((d) => d.userId == userId)
        .toList();

    if (outboxDecisions.isEmpty) return;

    for (var decision in outboxDecisions) {
      try {
        final syncedDecision = DecisionModel(
          id: decision.id,
          userId: decision.userId,
          status: decision.status,
          inputText: decision.inputText,
          category: decision.category,
          createdAt: decision.createdAt,
          updatedAt: decision.updatedAt,
          notes: decision.notes,
          expiresAt: decision.expiresAt,
          isSynced: true,
          resultJson: decision.resultJson,
        );
        // Using addDecision to upsert since we use set() internally
        await remoteDataSource.addDecision(syncedDecision);
        await localDataSource.removeDecisionFromOutbox(decision.id);
      } catch (e) {
        // Skip and retry later if sync fails
        continue;
      }
    }
  }
}
