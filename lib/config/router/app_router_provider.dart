import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/config/router/go_router_notifier.dart';
import 'package:teslo_app/presentation/features/auth/login/screens/login_screen.dart';
import 'package:teslo_app/presentation/features/auth/register/screens/register_screen.dart';
import 'package:teslo_app/presentation/features/products/screens/create_update_product_screen.dart';
import 'package:teslo_app/presentation/features/products/screens/product_detail_screen.dart';
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
      GoRoute(
        path: '/product/new',
        name: CreateUpdateProductScreen.routeName,
        builder: (context, state) => const CreateUpdateProductScreen(),
      ),
      GoRoute(
        path: '/product/:id/edit',
        name: 'product-edit',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return CreateUpdateProductScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/product/:id',
        name: ProductDetailScreen.routeName,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],
    redirect: (context, state) {
      final publicRoutes = ['/login', '/register'];
      final routeDestination = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (routeDestination == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (publicRoutes.contains(routeDestination)) {
          return null;
        }
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (publicRoutes.contains(routeDestination) || routeDestination == '/splash') {
          return '/';
        }
      }
      return null;
    },
  );
});
