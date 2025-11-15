import '../../domain/entities/route.dart';
import 'stop_model.dart';

class TransportRouteModel extends TransportRoute {
  TransportRouteModel({
    required super.id,
    required super.name,
    required super.company,
    required super.duration,
    required super.frequency,
    required super.phone,
    required super.price,
    required super.stopA,
    required super.stopB,
    required super.region,
    required super.province,
    required super.district,
    required super.locality,
    required super.schedule,
    required super.image,
  });

  factory TransportRouteModel.fromJson(Map<String, dynamic> json) {
    return TransportRouteModel(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      duration: json['duration'],
      frequency: json['frequency'],
      phone: json['phone'],
      price: json['price'].toDouble(),
      stopA: StopModel.fromJson(json['stopA']),
      stopB: StopModel.fromJson(json['stopB']),
      region: json['region'],
      province: json['province'],
      district: json['district'],
      locality: json['locality'],
      schedule: Map<String, String>.from(json['schedule']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'duration': duration,
      'frequency': frequency,
      'phone': phone,
      'price': price,
      'stopA': (stopA as StopModel).toJson(),
      'stopB': (stopB as StopModel).toJson(),
      'region': region,
      'province': province,
      'district': district,
      'locality': locality,
      'schedule': schedule,
      'image': image,
    };
  }
}