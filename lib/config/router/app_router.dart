import 'package:go_router/go_router.dart';
import 'package:teslo_app/features/products/screens/products_screen.dart';
import 'package:teslo_app/features/auth/login/screens/login_screen.dart';
import 'package:teslo_app/features/auth/register/screens/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),

    GoRoute(path: '/', builder: (context, state) => const ProductsScreen()),
  ],
);
