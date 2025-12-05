import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear instancia única del API Service
    final routeApiService = RouteApiService();
    
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: AuthRepositoryImpl(
              apiService: AuthApiService(),
            ),
          ),
        ),
        
        // Route Provider
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = context.read<AuthProvider>();
            if (authProvider.token != null) {
              routeApiService.setBearerToken(authProvider.token!);
            }
            return RouteProvider(
              repository: RouteRepositoryImpl(apiService: routeApiService),
              apiService: routeApiService,
            );
          },
        ),
        
        // User Provider
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            repository: UserRepositoryImpl(),
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Actualizar el token cuando cambie
          if (authProvider.token != null) {
            routeApiService.setBearerToken(authProvider.token!);
          }
          
          return MaterialApp(
            title: 'Gestión de Transporte',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const RoutesListScreen();
        }
        return const LoginScreen();
      },
    );
  }
}