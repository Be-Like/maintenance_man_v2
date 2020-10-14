import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/vehicle.dart';

class VehicleModel extends ChangeNotifier {
  final List<Vehicle> _vehicles = [];

  UnmodifiableListView<Vehicle> get vehicles => UnmodifiableListView(_vehicles);

  void add(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }
}
