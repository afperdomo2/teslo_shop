import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/config/router/go_router_notifier.dart';
import 'package:teslo_app/presentation/features/auth/login/screens/login_screen.dart';
import 'package:teslo_app/presentation/features/auth/register/screens/register_screen.dart';
import 'package:teslo_app/presentation/features/products/screens/products_screen.dart';
import 'package:teslo_app/presentation/providers/auth_provider.dart';
import 'package:teslo_app/presentation/shared/screens/loading_app_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        name: LoadingAppScreen.routeName,
        builder: (context, state) => const LoadingAppScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RegisterScreen.routeName,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: ProductsScreen.routeName,
        builder: (context, state) => const ProductsScreen(),
      ),
    ],
    redirect: (context, state) {
      final routeDestination = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (routeDestination == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (routeDestination == '/login' || routeDestination == '/register') {
          return null;
        }
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (routeDestination == '/login' ||
            routeDestination == '/register' ||
            routeDestination == '/splash') {
          return '/';
        }
      }
      return null;
    },
  );
});
