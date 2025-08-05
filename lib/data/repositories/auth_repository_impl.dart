import 'package:teslo_app/data/datasources/auth_remote_data_source_impl.dart';
import 'package:teslo_app/domain/entities/user.dart';
import 'package:teslo_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User> login(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<void> logout() {
    return _dataSource.logout();
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return _dataSource.register(email, password, fullName);
  }

  @override
  Future<bool> verifyToken(String token) {
    return _dataSource.verifyToken(token);
  }
}
