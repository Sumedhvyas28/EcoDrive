import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleList {
  final String id;
  final String name;
  final double mileage;
  final int age;

  VehicleList({required this.id, required this.name, required this.mileage, required this.age});

  factory VehicleList.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return VehicleList(
      id: doc.id,
      name: data['name'] ?? '',
      mileage: (data['mileage'] ?? 0).toDouble(),
      age: (data['age'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'mileage': mileage,
      'age': age,
    };
  }
}
