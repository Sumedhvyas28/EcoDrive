import 'package:flutter/material.dart';
import 'package:vehicle_eco/firebase_service.dart';
import 'package:vehicle_eco/model/vehicle_list.dart';
import 'package:vehicle_eco/vcard.dart';

class HomePage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Eco Drive'),centerTitle: true,),
      body: Column(
        children: [
          // Top Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity, 
              child: ElevatedButton.icon(
                onPressed: () => _showAddVehicleDialog(context),
                icon: Icon(Icons.add, size: 22),
                label: Text(
                  "Add Vehicle",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  elevation: 5, // Shadow effect
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<VehicleList>>(
              stream: firestoreService.getVehicles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No vehicles available.'));
                }
                final vehicles = snapshot.data!;
                return ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    return VehicleCard(vehicle: vehicles[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController mileageController = TextEditingController();
    TextEditingController ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Vehicle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Vehicle Name"),
              ),
              TextField(
                controller: mileageController,
                decoration: InputDecoration(labelText: "Mileage (km/l)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age (years)"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                double mileage = double.tryParse(mileageController.text) ?? 0;
                int age = int.tryParse(ageController.text) ?? 0;

                if (name.isNotEmpty && mileage > 0 && age >= 0) {
                  firestoreService.addVehicle(VehicleList(
                    id: '',
                    name: name,
                    mileage: mileage,
                    age: age,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
