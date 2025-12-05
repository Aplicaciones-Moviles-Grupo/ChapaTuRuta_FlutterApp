import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';

class RouteApiService {
  static const String baseUrl = 'http://10.0.2.2:5042/api/v1';
  
  // Token de autenticación (lo configuraremos dinámicamente)
  String? _bearerToken;

  void setBearerToken(String token) {
    _bearerToken = token;
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
      final response = await http.get(
        Uri.parse('$baseUrl/routes'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => TransportRouteModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado');
      } else {
        throw Exception('Failed to load routes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<TransportRouteModel?> getRouteById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/routes/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TransportRouteModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado');
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<TransportRouteModel>> filterRoutes({
    String? origin,
    String? destination,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (origin != null) queryParams['origin'] = origin;
      if (destination != null) queryParams['destination'] = destination;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();

      final uri = Uri.parse('$baseUrl/routes').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http.get(
        uri,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => TransportRouteModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado');
      } else {
        throw Exception('Failed to filter routes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}
