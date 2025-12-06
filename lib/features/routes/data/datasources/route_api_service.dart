import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';

class RouteApiService {
  // Para emulador Android usa: 10.0.2.2
  static const String baseUrl = 'https://chapaturutabackend.onrender.com/api/v1';
  
  String? _bearerToken;

  void setBearerToken(String token) {
    _bearerToken = token;
    print('✅ Token configurado en RouteApiService: ${token.substring(0, 20)}...');
  }

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_bearerToken != null && _bearerToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }
    
    return headers;
  }

  Future<List<TransportRouteModel>> getAllRoutes() async {
    try {
      print('🔄 Solicitando rutas desde: $baseUrl/routes');
      print('📋 Headers: ${_getHeaders()}');
      
      final response = await http.get(
        Uri.parse('$baseUrl/routes'),
        headers: _getHeaders(),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout: El servidor no respondió a tiempo');
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('✅ Rutas recibidas: ${jsonList.length}');
        
        return jsonList
            .map((json) => TransportRouteModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado');
      } else if (response.statusCode == 404) {
        print('⚠️ Endpoint no encontrado');
        throw Exception('Endpoint /routes no encontrado en el servidor');
      } else {
        throw Exception('Error al cargar rutas: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getAllRoutes: $e');
      rethrow;
    }
  }

  Future<TransportRouteModel?> getRouteById(int id) async {
    try {
      print('🔄 Solicitando ruta con ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/routes/$id'),
        headers: _getHeaders(),
      );

      print('📡 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TransportRouteModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado');
      } else if (response.statusCode == 404) {
        print('⚠️ Ruta no encontrada');
        return null;
      } else {
        throw Exception('Error al cargar ruta: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getRouteById: $e');
      rethrow;
    }
  }

  /// Método helper para verificar la conectividad
  Future<bool> testConnection() async {
    try {
      print('🔍 Probando conexión con el servidor...');
      final response = await http.get(
        Uri.parse('$baseUrl/routes'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 5));
      
      print('✅ Servidor respondió con status: ${response.statusCode}');
      return response.statusCode < 500;
    } catch (e) {
      print('❌ Error de conexión: $e');
      return false;
    }
  }
}