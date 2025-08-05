import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/data/datasources/auth_remote_data_source_impl.dart';
import 'package:teslo_app/data/repositories/auth_repository_impl.dart';
import 'package:teslo_app/domain/entities/user.dart';

enum AuthStatus { authenticated, unauthenticated, checking }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({this.authStatus = AuthStatus.unauthenticated, this.user, this.errorMessage = ''});

  AuthState copyWith({AuthStatus? authStatus, User? user, String? errorMessage}) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dataSource = AuthRemoteDataSourceImpl();
  final authRepository = AuthRepositoryImpl(dataSource);
  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> login(String email, String password) async {
    print('Intentando iniciar sesión con $email y $password');

    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(authStatus: AuthStatus.checking);
    try {
      final user = await authRepository.login(email, password);
      print('Usuario logueado: ${user.email}');
      _setLoggedUser(user);
    } catch (e) {
      logout(e.toString());
    }
  }

  void logout(String errorMessage) async {
    print('Cerrando sesión');
    print('Error: $errorMessage');
    state = state.copyWith(
      authStatus: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  void verifyToken(String token) async {}

  void _setLoggedUser(User user) {
    print(22222222222222);
    state = state.copyWith(authStatus: AuthStatus.authenticated, user: user, errorMessage: '');
  }
}
