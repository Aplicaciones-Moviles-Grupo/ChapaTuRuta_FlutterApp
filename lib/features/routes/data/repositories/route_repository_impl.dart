import '../../domain/entities/route.dart';
import '../../domain/repositories/route_repository.dart';
import '../models/route_model.dart';
import '../models/stop_model.dart';

class RouteRepositoryImpl implements RouteRepository {
  // Datos de ejemplo (simulando una base de datos local)
  final List<TransportRouteModel> _mockRoutes = [
    TransportRouteModel(
      id: '1',
      name: 'Paradero A - Paradero B',
      company: 'Transportes Lima Express',
      duration: '1hr de viaje',
      frequency: 'Suele salir cada 10 min',
      phone: '+51 923423422',
      price: 8.00,
      stopA: StopModel(name: 'Paradero A', address: 'Av. Inca 123'),
      stopB: StopModel(name: 'Paradero B', address: 'Jr. El Paso 321'),
      region: 'Lima',
      province: 'Lima',
      district: 'San Isidro',
      locality: 'San Isidro Centro',
      schedule: {
        'Domingo': '12:00pm - 5:00pm',
        'Lunes': '12:00pm - 5:00pm',
        'Martes': '12:00pm - 5:00pm',
        'Miércoles': '12:00pm - 5:00pm',
        'Jueves': '12:00pm - 5:00pm',
        'Viernes': '12:00pm - 5:00pm',
        'Sábado': '12:00pm - 5:00pm',
      },
    ),
    TransportRouteModel(
      id: '2',
      name: 'Miraflores - Barranco',
      company: 'Buses del Sur',
      duration: '45min de viaje',
      frequency: 'Suele salir cada 15 min',
      phone: '+51 987654321',
      price: 6.50,
      stopA: StopModel(name: 'Miraflores Centro', address: 'Av. Larco 500'),
      stopB: StopModel(name: 'Barranco Plaza', address: 'Jr. Lima 100'),
      region: 'Lima',
      province: 'Lima',
      district: 'Miraflores',
      locality: 'Miraflores',
      schedule: {
        'Domingo': '10:00am - 8:00pm',
        'Lunes': '6:00am - 10:00pm',
        'Martes': '6:00am - 10:00pm',
        'Miércoles': '6:00am - 10:00pm',
        'Jueves': '6:00am - 10:00pm',
        'Viernes': '6:00am - 11:00pm',
        'Sábado': '8:00am - 11:00pm',
      },
    ),
    TransportRouteModel(
      id: '3',
      name: 'Callao - San Miguel',
      company: 'Transportes Rápidos SAC',
      duration: '1hr 20min de viaje',
      frequency: 'Suele salir cada 20 min',
      phone: '+51 912345678',
      price: 7.00,
      stopA: StopModel(name: 'Callao Terminal', address: 'Av. Colonial 2000'),
      stopB: StopModel(name: 'San Miguel Plaza', address: 'Av. La Marina 1500'),
      region: 'Lima',
      province: 'Callao',
      district: 'Callao',
      locality: 'Callao Centro',
      schedule: {
        'Domingo': '8:00am - 6:00pm',
        'Lunes': '5:00am - 10:00pm',
        'Martes': '5:00am - 10:00pm',
        'Miércoles': '5:00am - 10:00pm',
        'Jueves': '5:00am - 10:00pm',
        'Viernes': '5:00am - 11:00pm',
        'Sábado': '6:00am - 10:00pm',
      },
    ),
    TransportRouteModel(
      id: '4',
      name: 'Surco - La Molina',
      company: 'Línea Verde Express',
      duration: '50min de viaje',
      frequency: 'Suele salir cada 12 min',
      phone: '+51 998877665',
      price: 9.50,
      stopA: StopModel(name: 'Surco Centro', address: 'Av. Benavides 3500'),
      stopB: StopModel(name: 'La Molina Este', address: 'Av. Javier Prado 5000'),
      region: 'Lima',
      province: 'Lima',
      district: 'Santiago de Surco',
      locality: 'Surco',
      schedule: {
        'Domingo': '11:00am - 7:00pm',
        'Lunes': '6:00am - 9:00pm',
        'Martes': '6:00am - 9:00pm',
        'Miércoles': '6:00am - 9:00pm',
        'Jueves': '6:00am - 9:00pm',
        'Viernes': '6:00am - 10:00pm',
        'Sábado': '7:00am - 9:00pm',
      },
    ),
    TransportRouteModel(
      id: '5',
      name: 'Los Olivos - Independencia',
      company: 'Transportes Norte',
      duration: '35min de viaje',
      frequency: 'Suele salir cada 8 min',
      phone: '+51 945678123',
      price: 5.50,
      stopA: StopModel(name: 'Los Olivos Plaza', address: 'Av. Alfredo Mendiola 2500'),
      stopB: StopModel(name: 'Independencia Terminal', address: 'Av. Túpac Amaru 3000'),
      region: 'Lima',
      province: 'Lima',
      district: 'Los Olivos',
      locality: 'Los Olivos',
      schedule: {
        'Domingo': '9:00am - 8:00pm',
        'Lunes': '5:30am - 10:30pm',
        'Martes': '5:30am - 10:30pm',
        'Miércoles': '5:30am - 10:30pm',
        'Jueves': '5:30am - 10:30pm',
        'Viernes': '5:30am - 11:00pm',
        'Sábado': '6:00am - 10:00pm',
      },
    ),
    TransportRouteModel(
      id: '6',
      name: 'Chorrillos - Villa El Salvador',
      company: 'Expreso Sur Chico',
      duration: '1hr 10min de viaje',
      frequency: 'Suele salir cada 18 min',
      phone: '+51 956789012',
      price: 6.00,
      stopA: StopModel(name: 'Chorrillos Centro', address: 'Av. Huaylas 500'),
      stopB: StopModel(name: 'Villa El Salvador', address: 'Av. Pachacútec 1000'),
      region: 'Lima',
      province: 'Lima',
      district: 'Chorrillos',
      locality: 'Chorrillos',
      schedule: {
        'Domingo': '10:00am - 6:00pm',
        'Lunes': '6:00am - 9:00pm',
        'Martes': '6:00am - 9:00pm',
        'Miércoles': '6:00am - 9:00pm',
        'Jueves': '6:00am - 9:00pm',
        'Viernes': '6:00am - 10:00pm',
        'Sábado': '7:00am - 9:00pm',
      },
    ),
    TransportRouteModel(
      id: '7',
      name: 'Ate - Santa Anita',
      company: 'Transportes del Este',
      duration: '40min de viaje',
      frequency: 'Suele salir cada 10 min',
      phone: '+51 923456789',
      price: 7.50,
      stopA: StopModel(name: 'Ate Vitarte', address: 'Av. Separadora Industrial 1500'),
      stopB: StopModel(name: 'Santa Anita Plaza', address: 'Av. Ramiro Prialé 2000'),
      region: 'Lima',
      province: 'Lima',
      district: 'Ate',
      locality: 'Ate Vitarte',
      schedule: {
        'Domingo': '8:00am - 7:00pm',
        'Lunes': '5:00am - 10:00pm',
        'Martes': '5:00am - 10:00pm',
        'Miércoles': '5:00am - 10:00pm',
        'Jueves': '5:00am - 10:00pm',
        'Viernes': '5:00am - 11:00pm',
        'Sábado': '6:00am - 10:00pm',
      },
    ),
    TransportRouteModel(
      id: '8',
      name: 'Pueblo Libre - Jesús María',
      company: 'Rutas Centro Express',
      duration: '25min de viaje',
      frequency: 'Suele salir cada 7 min',
      phone: '+51 987123456',
      price: 4.50,
      stopA: StopModel(name: 'Pueblo Libre', address: 'Av. La Marina 1000'),
      stopB: StopModel(name: 'Jesús María', address: 'Av. Salaverry 2500'),
      region: 'Lima',
      province: 'Lima',
      district: 'Pueblo Libre',
      locality: 'Pueblo Libre',
      schedule: {
        'Domingo': '10:00am - 8:00pm',
        'Lunes': '6:00am - 10:00pm',
        'Martes': '6:00am - 10:00pm',
        'Miércoles': '6:00am - 10:00pm',
        'Jueves': '6:00am - 10:00pm',
        'Viernes': '6:00am - 10:30pm',
        'Sábado': '7:00am - 10:00pm',
      },
    ),
    TransportRouteModel(
      id: '9',
      name: 'San Juan de Lurigancho - El Agustino',
      company: 'Transportes Oriente',
      duration: '55min de viaje',
      frequency: 'Suele salir cada 15 min',
      phone: '+51 934567890',
      price: 6.50,
      stopA: StopModel(name: 'SJL Estación', address: 'Av. Próceres 500'),
      stopB: StopModel(name: 'El Agustino Terminal', address: 'Av. Riva Agüero 800'),
      region: 'Lima',
      province: 'Lima',
      district: 'San Juan de Lurigancho',
      locality: 'SJL',
      schedule: {
        'Domingo': '9:00am - 7:00pm',
        'Lunes': '5:30am - 10:00pm',
        'Martes': '5:30am - 10:00pm',
        'Miércoles': '5:30am - 10:00pm',
        'Jueves': '5:30am - 10:00pm',
        'Viernes': '5:30am - 10:30pm',
        'Sábado': '6:00am - 9:30pm',
      },
    ),
    TransportRouteModel(
      id: '10',
      name: 'San Borja - La Victoria',
      company: 'Línea Azul SAC',
      duration: '30min de viaje',
      frequency: 'Suele salir cada 9 min',
      phone: '+51 956123789',
      price: 5.00,
      stopA: StopModel(name: 'San Borja Sur', address: 'Av. Aviación 3000'),
      stopB: StopModel(name: 'La Victoria Centro', address: 'Av. México 1500'),
      region: 'Lima',
      province: 'Lima',
      district: 'San Borja',
      locality: 'San Borja',
      schedule: {
        'Domingo': '10:00am - 8:00pm',
        'Lunes': '6:00am - 10:00pm',
        'Martes': '6:00am - 10:00pm',
        'Miércoles': '6:00am - 10:00pm',
        'Jueves': '6:00am - 10:00pm',
        'Viernes': '6:00am - 11:00pm',
        'Sábado': '7:00am - 10:00pm',
      },
    ),
  ];

  @override
  Future<List<TransportRoute>> getAllRoutes() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRoutes;
  }

  @override
  Future<List<TransportRoute>> filterRoutes({
    String? region,
    String? province,
    String? district,
    String? locality,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockRoutes.where((route) {
      bool matches = true;
      
      if (region != null && region.isNotEmpty) {
        matches = matches && route.region.toLowerCase().contains(region.toLowerCase());
      }
      if (province != null && province.isNotEmpty) {
        matches = matches && route.province.toLowerCase().contains(province.toLowerCase());
      }
      if (district != null && district.isNotEmpty) {
        matches = matches && route.district.toLowerCase().contains(district.toLowerCase());
      }
      if (locality != null && locality.isNotEmpty) {
        matches = matches && route.locality.toLowerCase().contains(locality.toLowerCase());
      }
      
      return matches;
    }).toList();
  }

  @override
  Future<TransportRoute?> getRouteById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _mockRoutes.firstWhere((route) => route.id == id);
    } catch (e) {
      return null;
    }
  }
}