import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/core/utils/validation_extensions.dart';
import 'package:teslo_app/presentation/features/auth/login/widgets/login_header_section.dart';
import 'package:teslo_app/presentation/features/auth/register/screens/register_screen.dart';
import 'package:teslo_app/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = 'auth-login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  // Validaciones
  final emailValidator = ValidationBuilder().email().build();
  final passwordValidator = ValidationBuilder().isSecurePassword().build();

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en los controladores para validar en tiempo real
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    // Verificar si ambos campos tienen texto y no tienen errores
    final email = _emailController.text;
    final password = _passwordController.text;

    final emailError = emailValidator(email);
    final passwordError = passwordValidator(password);

    final isValid =
        email.isNotEmpty && password.isNotEmpty && emailError == null && passwordError == null;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Escuchar cambios en el estado de autenticación
    ref.listen(authProvider, (previous, next) {
      if (next.authStatus == AuthStatus.authenticated) {
        // Login exitoso - navegar a productos
        context.goNamed('products');

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido ${next.user?.fullName ?? 'de vuelta'}!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      } else if (next.authStatus == AuthStatus.unauthenticated && next.errorMessage.isNotEmpty) {
        // Error en el login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height - MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Colors.white,
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                // Header Section
                Expanded(
                  flex: 1,
                  child: LoginHeaderSection(
                    title: '¡Bienvenido!',
                    subtitle: 'Inicia sesión para continuar',
                  ),
                ),

                // Form Section
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Correo Electrónico',
                                hintText: 'Ingresa tu email',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: emailValidator,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),

                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                hintText: 'Ingresa tu contraseña',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: passwordValidator,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),

                            const SizedBox(height: 24),

                            // Login Button
                            SizedBox(
                              height: 50,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final authState = ref.watch(authProvider);
                                  final isLoading = authState.authStatus == AuthStatus.checking;

                                  return ElevatedButton(
                                    onPressed: (_isFormValid && !isLoading)
                                        ? () {
                                            if (_formKey.currentState!.validate()) {
                                              _handleLogin();
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),

                            const Spacer(),

                            // Register Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('¿No tienes cuenta? '),
                                TextButton(
                                  onPressed: () {
                                    context.goNamed(RegisterScreen.routeName);
                                  },
                                  child: const Text(
                                    'Regístrate',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Obtener el notifier del provider
    final authNotifier = ref.read(authProvider.notifier);

    // Iniciar el proceso de login
    authNotifier.login(email, password);
  }
}
