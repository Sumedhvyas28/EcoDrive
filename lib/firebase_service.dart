import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_eco/model/vehicle_list.dart';

class FirestoreService {
  final CollectionReference vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');

  Stream<List<VehicleList>> getVehicles() {
    return vehiclesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => VehicleList.fromFirestore(doc)).toList());
  }

  Future<void> addVehicle(VehicleList vehicle) {
    return vehiclesCollection.add(vehicle.toFirestore());
  }

  Future<void> updateVehicle(VehicleList vehicle) {
    return vehiclesCollection.doc(vehicle.id).update(vehicle.toFirestore());
  }

  Future<void> deleteVehicle(String id) {
    return vehiclesCollection.doc(id).delete();
  }
}
