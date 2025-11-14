import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/route_provider.dart';
import '../widgets/route_card.dart';
import 'route_detail_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../profile/presentation/screens/favorites_screen.dart';
import '../../../profile/presentation/providers/user_provider.dart';

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  final List<String> regions = ['', 'Lima', 'Callao', 'Arequipa'];
  final List<String> provinces = ['', 'Lima', 'Callao', 'Arequipa'];
  final List<String> districts = [
    '',
    'San Isidro',
    'Miraflores',
    'Callao',
    'Santiago de Surco',
    'Los Olivos',
    'Chorrillos',
    'Ate',
    'Pueblo Libre',
    'San Juan de Lurigancho',
    'San Borja'
  ];
  final List<String> localities = [
    '',
    'San Isidro Centro',
    'Miraflores',
    'Callao Centro',
    'Surco',
    'Los Olivos',
    'Chorrillos',
    'Ate Vitarte',
    'Pueblo Libre',
    'SJL',
    'San Borja'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteProvider>().loadRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppTheme.primary,
            child: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Inicio',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
              child: Text(
                'Ver mis favoritos',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: AppTheme.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<RouteProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Filtros
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Región',
                            provider.selectedRegion,
                            regions,
                            (value) {
                              provider.setRegion(value?.isEmpty == true ? null : value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDropdown(
                            'Provincia',
                            provider.selectedProvince,
                            provinces,
                            (value) {
                              provider.setProvince(value?.isEmpty == true ? null : value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Distrito',
                            provider.selectedDistrict,
                            districts,
                            (value) {
                              provider.setDistrict(value?.isEmpty == true ? null : value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDropdown(
                            'Localidad/Ciudad',
                            provider.selectedLocality,
                            localities,
                            (value) {
                              provider.setLocality(value?.isEmpty == true ? null : value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.filterRoutes();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.textColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Buscar'),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Lista de rutas
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error != null
                        ? Center(child: Text(provider.error!))
                        : provider.routes.isEmpty
                            ? const Center(child: Text('No se encontraron rutas'))
                            : GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: provider.routes.length,
                                itemBuilder: (context, index) {
                                  final route = provider.routes[index];
                                  return RouteCard(
                                    route: route,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RouteDetailScreen(
                                            routeId: route.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value ?? '',
              isExpanded: true,
              hint: const Text('Select'),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item.isEmpty ? 'Select' : item,
                    style: TextStyle(
                      fontSize: 13,
                      color: item.isEmpty ? Colors.grey : AppTheme.textColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}