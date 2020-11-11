import 'package:flutter/material.dart';

class Vehicle {
  final String id;
  final int year;
  final String make;
  final String model;
  final String vehicleTrim;
  int mileage;
  Color color;

  Vehicle({
    @required this.id,
    @required this.year,
    @required this.make,
    @required this.model,
    this.vehicleTrim,
    this.mileage,
    this.color,
  });
}

class Vehicles with ChangeNotifier {
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => [..._vehicles];
}
