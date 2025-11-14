import '../../domain/entities/stop.dart';

class StopModel extends Stop {
  StopModel({
    required super.name,
    required super.address,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }
}