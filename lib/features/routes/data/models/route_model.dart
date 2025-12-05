import '../../domain/entities/route.dart';

class TransportRouteModel extends TransportRoute {
  TransportRouteModel({
    required super.id,
    required super.name,
    required super.price,
    required super.duration,
    required super.distance,
    required super.state,
    super.polylineRoute,
    required super.driverId,
    super.originAddress,
    super.destinationAddress,
  });

  factory TransportRouteModel.fromJson(Map<String, dynamic> json) {
    return TransportRouteModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      state: json['state'] as String? ?? 'Active',
      polylineRoute: json['polylineRoute'] as String?,
      driverId: json['driverId'] as int? ?? 0,
      originAddress: json['originAddress'] as String?,
      destinationAddress: json['destinationAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'distance': distance,
      'state': state,
      'polylineRoute': polylineRoute,
      'driverId': driverId,
      'originAddress': originAddress,
      'destinationAddress': destinationAddress,
    };
  }
}