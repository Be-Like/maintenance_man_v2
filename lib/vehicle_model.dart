// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:maintenance_man_v2/app_database.dart';
// import 'package:maintenance_man_v2/vehicle.dart';

// class VehicleModel extends ChangeNotifier {
//   static const String _table = 'vehicle';
//   final List<Vehicle> _vehicles = [];

//   UnmodifiableListView<Vehicle> get vehicles => UnmodifiableListView(_vehicles);

//   Future<void> initVehicles() async {
//     var db = await AppDatabase.query(_table);
//     db.forEach((record) {
//       Vehicle vehicle = new Vehicle(
//           id: record['vehicle_id'],
//           year: record['year'],
//           make: record['make'],
//           model: record['model'],
//           vehicleTrim: record['vehicle_trim'],
//           mileage: record['mileage']);
//       _vehicles.add(vehicle);
//     });
//   }

//   Future<void> add(Vehicle vehicle) async {
//     _vehicles.add(vehicle);
//     AppDatabase.insertVehicle(_table, vehicle);
//     notifyListeners();
//   }
// }
