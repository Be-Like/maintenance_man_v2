import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/screens/service_record_info_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ServiceRecordListItem extends StatelessWidget {
  final ServiceRecord serviceRecord;
  final _formattedDate = DateFormat.yMMMd();
  final _formattedCost = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  ServiceRecordListItem(this.serviceRecord);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(serviceRecord.name),
      subtitle: Text(_formattedDate.format(serviceRecord.dateOfService)),
      trailing: Text(_formattedCost.format(serviceRecord.cost)),
      onTap: () {
        print(serviceRecord.toString());
        Navigator.of(context).push(
          MaterialWithModalsPageRoute(
            builder: (ctx) => ServiceRecordInfoScreen(serviceRecord.id),
          ),
        );
      },
    );
  }
}
