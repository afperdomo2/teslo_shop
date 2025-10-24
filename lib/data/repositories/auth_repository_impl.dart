import 'package:teslo_app/domain/datasources/auth_data_source.dart';
import 'package:teslo_app/domain/entities/user.dart';
import 'package:teslo_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User> login(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return _dataSource.register(email, password, fullName);
  }

  @override
  Future<User> verifyToken(String token) {
    return _dataSource.verifyToken(token);
  }
}
