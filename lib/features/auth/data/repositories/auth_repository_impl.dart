import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<AuthUser?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  AuthUser? get currentUser => remoteDataSource.currentUser;

  @override
  Future<AuthUser> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }
}
