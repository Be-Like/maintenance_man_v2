import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Property {
  String id;
  String user;
  String address;
  String name;
  String description;
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
    this.description,
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
        description: $description, 
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
  static const propertyCollection = 'properties';

  Property _selectedProperty;

  List<Property> _properties = [];

  List<Property> get properties => [..._properties];

  Property get selectedProperty => _selectedProperty;

  Property findById(String id) =>
      _properties.firstWhere((property) => property.id == id);

  List<Property> clearData() => _properties = [];

  Future<void> initializeProperties() async {
    clearData();
    var query = await FirebaseFirestore.instance
        .collection(propertyCollection)
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .orderBy('updatedAt', descending: true)
        .get();
    if (query.docs.length == 0) return;
    query.docs.forEach((doc) {
      final createdAtTimestamp = doc['createdAt'] as Timestamp;
      final updatedAtTimestamp = doc['updatedAt'] as Timestamp;

      _properties.add(
        Property(
          id: doc.id,
          user: doc['user'],
          address: doc['address'],
          name: doc['name'],
          description: doc['description'],
          year: doc['year'],
          propertyType: doc['propertyType'],
          imageUrl: doc['imageUrl'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            createdAtTimestamp.seconds * 1000,
            isUtc: true,
          ),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(
            updatedAtTimestamp.seconds * 1000,
            isUtc: true,
          ),
        ),
      );
    });

    _selectedProperty = _properties[0];
    // TODO: Initialize service records
    notifyListeners();
  }

  void selectProperty(String propertyId) {
    _selectedProperty = _properties.firstWhere((el) => el.id == propertyId);
    // TODO: Initialize service records
    notifyListeners();
  }

  Future<String> storeAndGetImageUrl(String fileName, File imageFile) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('vehicle_$fileName.jpg');
    await ref.putFile(File(imageFile.path));
    return ref.getDownloadURL();
  }

  Future<void> addProperty(Property property, File image) async {
    final docRef =
        FirebaseFirestore.instance.collection(propertyCollection).doc().id;
    property.id = docRef;
    if (image != null) {
      property.imageUrl = await storeAndGetImageUrl(docRef, image);
    }

    await FirebaseFirestore.instance
        .collection(propertyCollection)
        .doc(docRef)
        .set({
      'user': FirebaseAuth.instance.currentUser.uid,
      'address': property.address,
      'name': property.name,
      'description': property.description,
      'year': property.year,
      'propertyType': property.propertyType,
      'imageUrl': property.imageUrl,
      'createdAt': property.createdAt,
      'updatedAt': property.updatedAt,
    });

    _properties.insert(0, property);
    notifyListeners();
  }
}
