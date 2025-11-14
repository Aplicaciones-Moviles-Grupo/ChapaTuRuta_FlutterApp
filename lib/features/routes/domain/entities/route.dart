import 'stop.dart';

class TransportRoute {
  final String id;
  final String name;
  final String company;
  final String duration;
  final String frequency;
  final String phone;
  final double price;
  final Stop stopA;
  final Stop stopB;
  final String region;
  final String province;
  final String district;
  final String locality;
  final Map<String, String> schedule;

  TransportRoute({
    required this.id,
    required this.name,
    required this.company,
    required this.duration,
    required this.frequency,
    required this.phone,
    required this.price,
    required this.stopA,
    required this.stopB,
    required this.region,
    required this.province,
    required this.district,
    required this.locality,
    required this.schedule,
  });
}