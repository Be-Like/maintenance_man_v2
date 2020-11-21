import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';

class Vehicle {
  String id;
  int year;
  String make;
  String model;
  String vehicleTrim;
  int mileage;
  Color color;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Vehicle({
    @required this.id,
    @required this.year,
    @required this.make,
    @required this.model,
    this.vehicleTrim,
    this.mileage,
    this.color,
    String imageUrl,
    DateTime createdAt,
    DateTime updatedAt,
  })  : imageUrl = imageUrl ??
            'https://cdn.shopify.com/s/files/1/1252/4103/files/Banner_Slide_1.jpg?8011495818817229397',
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

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
        imageUrl: $imageUrl,
        createdAt: $createdAt,
        updatedAt: $updatedAt,
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
    var query = await FirebaseFirestore.instance
        .collection('vehicles')
        .orderBy('updatedAt', descending: true)
        .get();
    query.docs.forEach((doc) {
      final createdAtTimestamp = doc['createdAt'] as Timestamp;
      final updatedAtTimestamp = doc['updatedAt'] as Timestamp;
      _vehicles.add(
        Vehicle(
          id: doc.id,
          year: doc['year'],
          make: doc['make'],
          model: doc['model'],
          vehicleTrim: doc['trim'],
          mileage: doc['mileage'],
          color: Color(doc['color']).withOpacity(1),
          imageUrl: doc['imageUrl'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(
              createdAtTimestamp.seconds * 1000,
              isUtc: true),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(
              updatedAtTimestamp.seconds * 1000,
              isUtc: true),
        ),
      );
    });
    _selectedVehicle = _vehicles[0];
    ServiceRecords().initializeRecords(_selectedVehicle.id);
    notifyListeners();
  }

  void selectVehicle(String vehicleId) {
    _selectedVehicle = _vehicles.firstWhere((el) => el.id == vehicleId);
    ServiceRecords().initializeRecords(_selectedVehicle.id);
    notifyListeners();
  }

  Vehicle findById(String id) =>
      _vehicles.firstWhere((vehicle) => vehicle.id == id);

  Future<void> addVehicle(Vehicle vehicle) async {
    var response = await FirebaseFirestore.instance.collection('vehicles').add({
      'year': vehicle.year,
      'make': vehicle.make,
      'model': vehicle.model,
      'trim': vehicle.vehicleTrim,
      'mileage': vehicle.mileage,
      'color': vehicle.color.value,
      'imageUrl': vehicle.imageUrl,
      'createdAt': vehicle.createdAt,
      'updatedAt': vehicle.updatedAt,
    });
    vehicle.id = response.id;

    _vehicles.insert(0, vehicle);
    notifyListeners();
  }

  Future<void> updateVehicle(String vehicleId, Vehicle vehicle) async {
    final vehicleIndex = _vehicles.indexWhere((el) => el.id == vehicleId);
    if (vehicleIndex >= 0) {
      try {
        vehicle.updatedAt = DateTime.now();
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(vehicleId)
            .update({
          'year': vehicle.year,
          'make': vehicle.make,
          'model': vehicle.model,
          'trim': vehicle.vehicleTrim,
          'mileage': vehicle.mileage,
          'color': vehicle.color.value,
          'imageUrl': vehicle.imageUrl,
          'createdAt': vehicle.createdAt,
          'updatedAt': vehicle.updatedAt,
        });
        _vehicles.removeAt(vehicleIndex);
        _vehicles.insert(0, vehicle);
        notifyListeners();
      } catch (err) {
        throw err;
      }
    } else {
      throw Error;
    }
  }

  void deleteVehicle(String vehicleId) {
    if (_selectedVehicle.id == vehicleId) {
      _selectedVehicle = _vehicles.firstWhere((el) => el.id != vehicleId);
    }
    _vehicles.removeWhere((el) => el.id == vehicleId);
    FirebaseFirestore.instance.collection('vehicles').doc(vehicleId).delete();
    notifyListeners();
  }
}
