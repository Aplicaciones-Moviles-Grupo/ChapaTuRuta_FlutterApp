import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/route.dart';

class RouteCard extends StatelessWidget {
  final TransportRoute route;
  final VoidCallback onTap;

  // COLORES DE TU DISEÑO (IMAGEN 2)
  static const Color cardBackgroundColor = Color(0xFFE6E6FA); // Lavanda
  static const Color priceColor = Color(0xFF26A69A); // Turquesa/Teal
  static const Color activeGreen = Color(0xFFC8E6C9); // Verde claro fondo
  static const Color activeText = Color(0xFF2E7D32); // Verde oscuro texto
  static const Color inactiveRed = Color(0xFFFFCDD2); // Rojo claro fondo
  static const Color inactiveText = Color(0xFFC62828); // Rojo oscuro texto

  const RouteCard({
    super.key,
    required this.route,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Imagen Placeholder
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.05),
                child: Center(
                  child: Icon(Icons.directions_bus, size: 48, color: Colors.grey[400]),
                ),
              ),
            ),
            // Información
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // ETIQUETA DE ESTADO (Verde o Roja)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: route.state == 'Active' ? activeGreen : inactiveRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            route.state == 'Active' ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 10, 
                              fontWeight: FontWeight.bold, 
                              color: route.state == 'Active' ? activeText : inactiveText
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildIconText(Icons.access_time, route.duration),
                              const SizedBox(height: 4),
                              _buildIconText(Icons.straighten, route.distance),
                            ],
                          ),
                          Text(
                            'S/ ${route.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 107, 96, 206), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ],
    );
  }
}