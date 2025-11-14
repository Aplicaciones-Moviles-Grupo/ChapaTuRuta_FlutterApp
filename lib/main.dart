import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RouteProvider(
            repository: RouteRepositoryImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            repository: UserRepositoryImpl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gestión de Transporte',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RoutesListScreen(),
      ),
    );
  }
}