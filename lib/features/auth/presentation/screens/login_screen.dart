import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../profile/data/models/user_model.dart'; // Importa tu modelo de usuario
import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/user_provider.dart';
import '../../../routes/presentation/providers/route_provider.dart';
import '../../../routes/presentation/screens/routes_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  static const Color brandBlue = Color.fromRGBO(107, 115, 233, 1);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final userProvider = context.read<UserProvider>();
      final routeProvider = context.read<RouteProvider>();

      // 1. Llamada al Backend
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        
        // 2. GUARDAR DATOS DEL USUARIO (Esto hace que aparezca en el perfil)
        final newUser = UserModel(
          id: authProvider.currentUser?.id.toString() ?? '1',
          name: authProvider.currentUser?.name ?? 'Usuario',
          lastName: '',
          username: _emailController.text.split('@')[0], // Usamos parte del correo como username
          email: _emailController.text.trim(),
          phone: '',
          gender: '',
          favoriteRoutes: [],
        );
        
        await userProvider.updateUser(newUser); // Guardar en SharedPreferences

        // 3. Configurar token y cargar rutas
        if (authProvider.token != null) {
          routeProvider.setToken(authProvider.token!);
          await routeProvider.loadRoutes();
        }

        // 4. Ir al Home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RoutesListScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Error al iniciar sesión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/images/chapaturuta.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Gestión de Transporte',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text('Inicia sesión para continuar', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 48),
                  
                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                    ),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Email inválido' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 24),
                  
                  // Botón Login
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue, // COLOR AZUL
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Iniciar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () {},
                    child: const Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: brandBlue)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}