import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../models/decision_model.dart';

abstract class DecisionRemoteDataSource {
  Stream<List<DecisionModel>> watchDecisions(String userId);
  Future<void> addDecision(DecisionModel decision);
  Future<void> updateDecision(DecisionModel decision);
}

class DecisionRemoteDataSourceImpl implements DecisionRemoteDataSource {
  final FirebaseFirestore firestore;

  DecisionRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _decisionsRef(String userId) {
    return firestore.collection('users').doc(userId).collection('decisions');
  }

  @override
  Stream<List<DecisionModel>> watchDecisions(String userId) {
    return _decisionsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DecisionModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> addDecision(DecisionModel decision) async {
    try {
      await _decisionsRef(
        decision.userId,
      ).doc(decision.id).set(decision.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateDecision(DecisionModel decision) async {
    try {
      await _decisionsRef(
        decision.userId,
      ).doc(decision.id).update(decision.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
