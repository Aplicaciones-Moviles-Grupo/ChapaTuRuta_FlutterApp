import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/route_provider.dart';
import '../widgets/route_card.dart';
import 'route_detail_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../profile/presentation/screens/favorites_screen.dart';

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  final List<String> regions = ['', 'Lima', 'Callao', 'Arequipa'];
  final List<String> provinces = ['', 'Lima', 'Callao', 'Arequipa'];
  final List<String> districts = ['', 'San Isidro', 'Miraflores', 'Callao', 'Santiago de Surco', 'Los Olivos', 'Chorrillos', 'Ate', 'Pueblo Libre', 'San Juan de Lurigancho', 'San Borja'];
  final List<String> localities = ['', 'San Isidro Centro', 'Miraflores', 'Callao Centro', 'Surco', 'Los Olivos', 'Chorrillos', 'Ate Vitarte', 'Pueblo Libre', 'SJL', 'San Borja'];

  // Color Turquesa Principal
  static const Color brandTeal =  const Color.fromRGBO(107, 115, 233, 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteProvider>().loadRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<RouteProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          backgroundColor:  const Color.fromRGBO(107, 115, 233, 1),
                          child: Icon(Icons.location_on, color: Colors.white),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('Inicio', style: TextStyle(color: brandTeal, fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                              child: Text('Ver mis favoritos', style: TextStyle(color: Colors.grey[600])),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: brandTeal, width: 2), 
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.person, color: brandTeal, size: 20),
                          ),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: _buildFilters(provider)),

                if (provider.isLoading)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: brandTeal)))
                else if (provider.error != null)
                  SliverFillRemaining(child: Center(child: Text(provider.error!)))
                else if (provider.routes.isEmpty)
                  const SliverFillRemaining(child: Center(child: Text('No se encontraron rutas')))
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final route = provider.routes[index];
                          return RouteCard(
                            route: route,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => RouteDetailScreen(routeId: route.id.toString())));
                            },
                          );
                        },
                        childCount: provider.routes.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilters(RouteProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDropdown('Región', provider.selectedRegion, regions, (v) => provider.setRegion(v?.isEmpty == true ? null : v))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('Provincia', provider.selectedProvince, provinces, (v) => provider.setProvince(v?.isEmpty == true ? null : v))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDropdown('Distrito', provider.selectedDistrict, districts, (v) => provider.setDistrict(v?.isEmpty == true ? null : v))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('Localidad/Ciudad', provider.selectedLocality, localities, (v) => provider.setLocality(v?.isEmpty == true ? null : v))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => provider.filterRoutes(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(107, 115, 233, 1), 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Buscar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value ?? '',
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item.isEmpty ? 'Select' : item, style: TextStyle(fontSize: 13, color: item.isEmpty ? Colors.grey : AppTheme.textColor), overflow: TextOverflow.ellipsis))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}