import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ServiceRecord {
  String id;
  String name;
  DateTime dateOfService;
  String description;
  double cost;
  String location;
  String imageUrl;
  String type;
  String typeId;
  DateTime createdAt;
  DateTime updatedAt;

  ServiceRecord({
    @required this.id,
    @required this.name,
    @required this.dateOfService,
    @required this.type,
    @required this.typeId,
    this.cost,
    this.description,
    this.location,
    this.imageUrl,
    DateTime createdAt,
    DateTime updatedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();

  @override
  String toString() => '''
    Service Record: {
      id; $id,
      name: $name,
      dateOfService: $dateOfService,
      typeId: $typeId
      cost: $cost,
      description: $description,
      location: $location,
      imageUrl: $imageUrl,
      type: $type,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
    }
  ''';
}

class ServiceRecords with ChangeNotifier {
  static const _recordsCollection = 'service_records';

  List<ServiceRecord> _records = [];

  List<ServiceRecord> get records => [..._records];

  Future<void> initializeRecords(String recordTypeId) async {
    _records = [];
    final query = await FirebaseFirestore.instance
        .collection(_recordsCollection)
        .orderBy('createdAt', descending: true)
        .where('typeId', isEqualTo: recordTypeId)
        .get();
    query.docs.forEach((doc) {
      final dateOfServiceTimestamp = doc['dateOfService'] as Timestamp;
      final createdAtTimestamp = doc['createdAt'] as Timestamp;
      final updatedAtTimestamp = doc['updatedAt'] as Timestamp;
      _records.add(
        ServiceRecord(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
          cost: doc['cost'],
          location: doc['location'],
          imageUrl: doc['imageUrl'],
          type: doc['type'],
          typeId: doc['typeId'],
          dateOfService: DateTime.fromMillisecondsSinceEpoch(
            dateOfServiceTimestamp.seconds * 1000,
            isUtc: true,
          ),
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
    notifyListeners();
  }

  ServiceRecord findById(String recordId) =>
      _records.firstWhere((record) => record.id == recordId);

  Future<String> storeAndGetImageUrl(String fileName, File imageFile) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('invoice_$fileName.jpg');
    await ref.putFile(File(imageFile.path));
    return ref.getDownloadURL();
  }

  Future<void> addRecord(ServiceRecord record, File image) async {
    final docRef =
        FirebaseFirestore.instance.collection(_recordsCollection).doc().id;
    record.id = docRef;

    if (image != null) {
      record.imageUrl = await storeAndGetImageUrl(docRef, image);
    }

    await FirebaseFirestore.instance
        .collection(_recordsCollection)
        .doc(docRef)
        .set({
      'name': record.name,
      'dateOfService': record.dateOfService,
      'description': record.description,
      'cost': record.cost,
      'location': record.location,
      'imageUrl': record.imageUrl,
      'type': record.type,
      'typeId': record.typeId,
      'createdAt': record.createdAt,
      'updatedAt': record.updatedAt,
    });

    _records.insert(0, record);
    notifyListeners();
  }

  Future<void> updateRecord(ServiceRecord record, File image) async {
    final recordIndex = _records.indexWhere((el) => el.id == record.id);
    if (recordIndex >= 0) {
      try {
        if (image != null) {
          record.imageUrl = await storeAndGetImageUrl(record.id, image);
        }
        record.updatedAt = DateTime.now();
        await FirebaseFirestore.instance
            .collection(_recordsCollection)
            .doc(record.id)
            .update({
          'name': record.name,
          'dateOfService': record.dateOfService,
          'description': record.description,
          'cost': record.cost,
          'location': record.location,
          'imageUrl': record.imageUrl,
          'type': record.type,
          'typeId': record.typeId,
          'createdAt': record.createdAt,
          'updatedAt': record.updatedAt,
        });
        _records[recordIndex] = record;
        notifyListeners();
      } catch (err) {
        throw err;
      }
    } else {
      throw Error;
    }
  }

  void deleteRecord(String recordId) {
    FirebaseFirestore.instance
        .collection(_recordsCollection)
        .doc(recordId)
        .delete();
    _records.removeWhere((el) => el.id == recordId);
    notifyListeners();
  }

  int getIndex(String recordId) =>
      _records.indexWhere((el) => el.id == recordId);

  Future<void> undoDelete(int recordIndex, ServiceRecord record) async {
    _records.insert(recordIndex, record);
    await FirebaseFirestore.instance
        .collection(_recordsCollection)
        .doc(record.id)
        .set({
      'name': record.name,
      'dateOfService': record.dateOfService,
      'description': record.description,
      'cost': record.cost,
      'location': record.location,
      'imageUrl': record.imageUrl,
      'type': record.type,
      'typeId': record.typeId,
      'createdAt': record.createdAt,
      'updatedAt': record.updatedAt,
    });
    notifyListeners();
  }
}
