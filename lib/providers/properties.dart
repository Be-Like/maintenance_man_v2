import 'package:flutter/cupertino.dart';

class Property {
  String id;
  String user;
  String address;
  String name;
  int year;
  String propertyType;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Property({
    @required this.id,
    @required this.user,
    @required this.address,
    this.name,
    this.year,
    this.propertyType,
    this.imageUrl,
    DateTime createdAt,
    DateTime updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  @override
  String toString() {
    return '''\n
      Property: {
        id: $id,
        user: $user,
        address: $address,
        name: $name,
        year: $year,
        propertyType: $propertyType,
        imageUrl: $imageUrl,
        createdAt: $createdAt,
        updatedAt: $updatedAt,
      }
    ''';
  }
}

class Properties extends ChangeNotifier {
  Property _selectedProperty;

  List<Property> _properties = [];

  List<Property> get properties => [..._properties];

  Property get selectedProperty => _selectedProperty;

  Future<void> initializeProperties() async {}
}
