import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/routes/presentation/providers/route_provider.dart';
import '../../../../features/routes/presentation/widgets/route_card.dart';
import '../../../../features/routes/presentation/screens/route_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mis Favoritos', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<RouteProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favoriteRoutes;

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aún no tienes rutas favoritas', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final route = favorites[index];
              return SizedBox(
                height: 260,
                child: RouteCard(
                  route: route,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RouteDetailScreen(routeId: route.id.toString()),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}