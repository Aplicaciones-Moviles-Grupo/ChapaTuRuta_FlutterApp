import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';

// Imports de tus capas
import 'features/auth/data/datasources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

import 'features/routes/data/datasources/route_api_service.dart';
import 'features/routes/data/repositories/route_repository_impl.dart';
import 'features/routes/presentation/providers/route_provider.dart';
import 'features/routes/presentation/screens/routes_list_screen.dart';

import 'features/profile/data/repositories/user_repository_impl.dart';
import 'features/profile/presentation/providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia compartida para RouteApiService
    final routeApiService = RouteApiService();
    
    return MultiProvider(
      providers: [
        // 1. Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: AuthRepositoryImpl(apiService: AuthApiService()),
          ),
        ),
        
        // 2. User Provider (Intentamos cargar usuario guardado aquí)
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            repository: UserRepositoryImpl(),
          )..loadCurrentUser(), // 👇 ESTO ES CLAVE: Carga el usuario al iniciar la app
        ),

        // 3. Route Provider (Depende de Auth para el token)
        ChangeNotifierProxyProvider<AuthProvider, RouteProvider>(
          create: (context) => RouteProvider(
            repository: RouteRepositoryImpl(apiService: routeApiService),
            apiService: routeApiService,
          ),
          update: (context, authProvider, previousRouteProvider) {
            if (authProvider.token != null) {
              routeApiService.setBearerToken(authProvider.token!);
            }
            return previousRouteProvider!;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Gestión de Transporte',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // O AppTheme.theme según tu config
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Verificamos si hay un usuario guardado en el UserProvider
    final userProvider = context.read<UserProvider>();
    await userProvider.loadCurrentUser();
    
    if (mounted) {
      if (userProvider.currentUser != null) {
        // ✅ Si hay usuario guardado, vamos directo a Rutas
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RoutesListScreen()),
        );
      } else {
        // ❌ Si no, nos quedamos en Login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla de carga mientras verificamos sesión
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(107, 115, 233, 1),
        ),
      ),
    );
  }
}