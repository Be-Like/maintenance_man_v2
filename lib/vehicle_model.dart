import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/app_database.dart';
import 'package:maintenance_man_v2/vehicle.dart';

class VehicleModel extends ChangeNotifier {
  final List<Vehicle> _vehicles = [];

  UnmodifiableListView<Vehicle> get vehicles => UnmodifiableListView(_vehicles);

  Future<void> add(Vehicle vehicle) async {
    _vehicles.add(vehicle);
    AppDatabase.insertVehicle('vehicle', vehicle);
    notifyListeners();
  }
}
