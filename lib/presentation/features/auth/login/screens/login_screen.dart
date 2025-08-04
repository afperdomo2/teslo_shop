import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/core/utils/validation_extensions.dart';
import 'package:teslo_app/presentation/features/auth/login/widgets/login_header_section.dart';
import 'package:teslo_app/presentation/features/auth/register/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'auth-login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                              child: ElevatedButton(
                                onPressed: _isFormValid
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
                                child: const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
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

  void _handleLogin() {
    // Simular el proceso de login
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Simular delay de autenticación
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Cerrar loading

      // Navegar a la pantalla de productos
      context.goNamed('products');

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Bienvenido de vuelta!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    });
  }
}
