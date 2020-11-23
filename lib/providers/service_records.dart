import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<ServiceRecord> _records = [];

  List<ServiceRecord> get records => [..._records];

  Future<void> initializeRecords(String recordTypeId) async {
    _records = [];
    final query = await FirebaseFirestore.instance
        .collection('service_records')
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

  Future<void> addRecord(ServiceRecord record) async {
    var response =
        await FirebaseFirestore.instance.collection('service_records').add({
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
    record.id = response.id;
    _records.insert(0, record);
    notifyListeners();
  }

  Future<void> updateRecord(ServiceRecord record) async {}
}
