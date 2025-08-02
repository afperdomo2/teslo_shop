import 'package:go_router/go_router.dart';
import 'package:teslo_app/features/auth/login/screens/login_screen.dart';
import 'package:teslo_app/features/auth/register/screens/register_screen.dart';
import 'package:teslo_app/features/products/screens/products_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
);
