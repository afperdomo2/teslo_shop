import 'package:dio/dio.dart';
import 'package:teslo_app/config/constants/envs_constants.dart';
import 'package:teslo_app/data/errors/auth_errors.dart';
import 'package:teslo_app/data/mappers/user_mapper.dart';
import 'package:teslo_app/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);

  Future<User> register(String email, String password, String fullName);

  Future<bool> verifyToken(String token);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final apiClient = Dio(
    BaseOptions(
      baseUrl: EnvsConstants.apiUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    ),
  );

  AuthRemoteDataSourceImpl();

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return UserMapper.userJsonToEntity(response.data);
    } catch (e) {
      if (e is DioException) {
        // Error de conexión rechazada (Connection refused)
        if (e.type == DioExceptionType.connectionError ||
            (e.error != null && e.error.toString().contains('Connection refused'))) {
          throw Exception('No se pudo conectar al servidor. Verifica tu conexión.');
        }
      }
      throw WrongCredentials();
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyToken(String token) {
    // TODO: implement verifyToken
    throw UnimplementedError();
  }
}
