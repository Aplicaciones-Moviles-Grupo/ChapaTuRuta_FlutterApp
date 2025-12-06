import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/route.dart';
import '../providers/route_provider.dart';

class RouteDetailScreen extends StatefulWidget {
  final String routeId;

  const RouteDetailScreen({super.key, required this.routeId});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  TransportRoute? route;
  bool isLoading = true;
  static const Color accentPurple = Color(0xFFE6E6FA);
  // Color Turquesa
  static const Color brandTeal = const Color.fromRGBO(107, 115, 233, 1);

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final loadedRoute = await context.read<RouteProvider>().getRouteById(widget.routeId);
    setState(() {
      route = loadedRoute;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (route == null) return const Scaffold(body: Center(child: Text('Ruta no encontrada')));

    final isFavorite = context.select<RouteProvider, bool>(
      (provider) => provider.isFavorite(route!.id)
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(route!.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        
        actions: [
          // BOTÓN CORAZÓN
          IconButton(
            onPressed: () {
              context.read<RouteProvider>().toggleFavorite(route!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? 'Eliminado de favoritos' : 'Guardado en favoritos'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : const Color.fromRGBO(107, 115, 233, 1), 
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: accentPurple,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(child: Icon(Icons.map_outlined, size: 64, color: brandTeal.withOpacity(0.3))),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(route!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: route!.state == 'Active' ? const Color(0xFFC8E6C9) : const Color(0xFFFFCDD2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            route!.state == 'Active' ? 'Active' : 'Inactive', 
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.bold, 
                              color: route!.state == 'Active' ? const Color(0xFF2E7D32) : const Color(0xFFC62828)
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('S/ ${route!.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 102, 109, 212))),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildStatItem(Icons.access_time_filled, 'Duración', route!.duration),
                    Container(height: 40, width: 1, color: Colors.grey[400]),
                    _buildStatItem(Icons.straighten, 'Distancia', route!.distance),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: brandTeal, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}