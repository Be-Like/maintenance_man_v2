import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/screens/service_records/service_record_info_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

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
    final serviceRecordsData =
        Provider.of<ServiceRecords>(context, listen: false);
    return Dismissible(
      key: Key(serviceRecord.id),
      background: Container(
        color: Colors.red,
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.only(right: 12),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text(serviceRecord.name),
        subtitle: Text(_formattedDate.format(serviceRecord.dateOfService)),
        trailing: Text(_formattedCost.format(serviceRecord.cost)),
        onTap: () {
          Navigator.of(context).push(
            MaterialWithModalsPageRoute(
              builder: (ctx) => ServiceRecordInfoScreen(serviceRecord.id),
            ),
          );
        },
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final deletedRecordIndex =
            serviceRecordsData.getIndex(serviceRecord.id);
        final deletedRecord = serviceRecord;
        serviceRecordsData.deleteRecord(serviceRecord.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 4),
            content: Text('Deleted ${deletedRecord.name}.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                serviceRecordsData.undoDelete(
                  deletedRecordIndex,
                  deletedRecord,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
