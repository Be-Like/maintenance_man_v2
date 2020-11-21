import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';

class ServiceRecordListItem extends StatelessWidget {
  final ServiceRecord serviceRecord;

  ServiceRecordListItem(this.serviceRecord);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(serviceRecord.name),
    );
  }
}
