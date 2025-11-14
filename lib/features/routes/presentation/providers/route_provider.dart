import 'package:flutter/material.dart';
import '../../domain/entities/route.dart';
import '../../domain/repositories/route_repository.dart';

class RouteProvider with ChangeNotifier {
  final RouteRepository repository;
  
  List<TransportRoute> _routes = [];
  List<TransportRoute> _filteredRoutes = [];
  bool _isLoading = false;
  String? _error;
  
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedLocality;

  RouteProvider({required this.repository});

  List<TransportRoute> get routes => _filteredRoutes.isEmpty ? _routes : _filteredRoutes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  String? get selectedRegion => _selectedRegion;
  String? get selectedProvince => _selectedProvince;
  String? get selectedDistrict => _selectedDistrict;
  String? get selectedLocality => _selectedLocality;

  Future<void> loadRoutes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _routes = await repository.getAllRoutes();
      _filteredRoutes = _routes;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al cargar las rutas';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterRoutes() async {
    if (_selectedRegion == null && 
        _selectedProvince == null && 
        _selectedDistrict == null && 
        _selectedLocality == null) {
      _filteredRoutes = _routes;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _filteredRoutes = await repository.filterRoutes(
        region: _selectedRegion,
        province: _selectedProvince,
        district: _selectedDistrict,
        locality: _selectedLocality,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al filtrar rutas';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setRegion(String? region) {
    _selectedRegion = region;
    notifyListeners();
  }

  void setProvince(String? province) {
    _selectedProvince = province;
    notifyListeners();
  }

  void setDistrict(String? district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  void setLocality(String? locality) {
    _selectedLocality = locality;
    notifyListeners();
  }

  void clearFilters() {
    _selectedRegion = null;
    _selectedProvince = null;
    _selectedDistrict = null;
    _selectedLocality = null;
    _filteredRoutes = _routes;
    notifyListeners();
  }

  Future<TransportRoute?> getRouteById(String id) async {
    return await repository.getRouteById(id);
  }
}