import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/route.dart';
import '../providers/route_provider.dart';

class RouteDetailScreen extends StatefulWidget {
  final String routeId;

  const RouteDetailScreen({
    super.key,
    required this.routeId,
  });

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  TransportRoute? route;
  bool isLoading = true;

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
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (route == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Ruta no encontrada')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(route!.name),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Agregado a colección')),
              );
            },
            child: const Text(
              'Agregar a colección',
              style: TextStyle(color: AppTheme.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen principal (puedes usar Google Maps Static API si tienes polyline)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.off,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: route!.polylineRoute != null && route!.polylineRoute!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://maps.googleapis.com/maps/api/staticmap?size=600x400&path=enc:${route!.polylineRoute}&key=YOUR_GOOGLE_MAPS_KEY',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.map,
                                size: 60,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.map,
                          size: 60,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              
              // Información principal
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: route!.state == 'Active' 
                          ? Colors.green.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.directions_bus,
                      color: route!.state == 'Active' ? Colors.green[700] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: route!.state == 'Active' 
                                ? Colors.green.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            route!.state,
                            style: TextStyle(
                              fontSize: 12,
                              color: route!.state == 'Active' 
                                  ? Colors.green[700] 
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    's/${route!.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Detalles de la ruta
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.off.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.access_time,
                      'Duración',
                      route!.duration,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.straighten,
                      'Distancia',
                      route!.distance,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Direcciones
              const Text(
                'Ruta:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildAddressCard(
                'Origen',
                route!.origin,
                route!.originAddress ?? 'Dirección no disponible',
                Icons.location_on,
                Colors.green,
              ),
              const SizedBox(height: 12),
              
              _buildAddressCard(
                'Destino',
                route!.destination,
                route!.destinationAddress ?? 'Dirección no disponible',
                Icons.location_on,
                Colors.red,
              ),
              const SizedBox(height: 24),
              
              // Información del conductor
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primary.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conductor',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'ID: ${route!.driverId}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Contactar conductor
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función de contacto')),
                        );
                      },
                      icon: const Icon(Icons.message, color: AppTheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reservar ruta: ${route!.name}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reservar Ruta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 24, color: AppTheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(
    String label,
    String title,
    String address,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (address != 'Dirección no disponible')
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
