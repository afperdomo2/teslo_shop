import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/core/storage/adapters/shared_prefs_adapter.dart';
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
  final keyValueService = SharedPrefsAdapter();

  return AuthNotifier(authRepository: authRepository, keyValueService: keyValueService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl authRepository;
  final SharedPrefsAdapter keyValueService;

  AuthNotifier({required this.authRepository, required this.keyValueService}) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    // NOTE: Simular retardo de red
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } catch (e) {
      logout(e.toString());
    }
  }

  void logout(String errorMessage) async {
    await keyValueService.remove('token');
    state = state.copyWith(
      authStatus: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  void verifyToken(String token) async {}

  void _setLoggedUser(User user) async {
    await keyValueService.save('token', user.token);
    state = state.copyWith(authStatus: AuthStatus.authenticated, user: user, errorMessage: '');
  }

  void checkAuthStatus() async {
    final token = await keyValueService.read<String>('token');
    if (token == null) {
      return logout('');
    }
    try {
      final user = await authRepository.verifyToken(token);
      _setLoggedUser(user);
    } catch (e) {
      logout('');
    }
  }
}
