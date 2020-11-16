import 'package:flutter/material.dart';

class Vehicle {
  final String id;
  int year;
  String make;
  String model;
  String vehicleTrim;
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

  String vehicleName() => '$make $model $vehicleTrim';

  @override
  String toString() {
    return '''\n
      Vehicle: {
        id: $id,
        year: $year,
        make: $make,
        model: $model,
        trim: $vehicleTrim,
        mileage: $mileage,
        color: $color,
      }
    ''';
  }
}

class Vehicles with ChangeNotifier {
  Vehicle _selectedVehicle;

  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => [..._vehicles];

  Vehicle get selectedVehicle => _selectedVehicle;

  Future<void> initializeVehicles() async {
    _vehicles = [
      Vehicle(
        id: '2',
        year: 2017,
        make: 'Dodge',
        model: 'Challenger',
        vehicleTrim: 'SXT',
        mileage: 46000,
        color: Colors.red,
      ),
      Vehicle(
        id: '1',
        year: 2011,
        make: 'Toyota',
        model: 'Camry',
        vehicleTrim: 'LE',
        mileage: 196000,
        color: Colors.blue,
      ),
      Vehicle(
        id: '3',
        year: 2019,
        make: 'Harley Davidson',
        model: 'Iron',
        vehicleTrim: 'XL1200',
        mileage: 0,
        color: Colors.black45,
      ),
    ];
    _selectedVehicle = _vehicles[0];
  }

  void selectVehicle(String vehicleId) {
    _selectedVehicle = _vehicles.firstWhere((el) => el.id == vehicleId);
    notifyListeners();
  }

  void addVehicle(Vehicle vehicle) {
    _vehicles.insert(0, vehicle);
    notifyListeners();
  }
}
