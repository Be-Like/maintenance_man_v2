import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/screens/service_records/add_record_screen.dart';
import 'package:maintenance_man_v2/widgets/add_image_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ServiceRecordInfoScreen extends StatelessWidget {
  static const routeName = '/service-record-info';
  final _formattedDate = DateFormat.yMMMd();
  final _formattedCost = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  final _picker = ImagePicker();
  final String recordId;

  ServiceRecordInfoScreen(this.recordId);

  @override
  Widget build(BuildContext context) {
    final _serviceRecord =
        Provider.of<ServiceRecords>(context).findById(recordId);
    final _hasImage =
        _serviceRecord.imageUrl != '' && _serviceRecord.imageUrl != null;
    final _recordParent = _serviceRecord.type == 'Vehicle'
        ? Provider.of<Vehicles>(context, listen: false)
            .findById(_serviceRecord.typeId)
        : Provider.of<Properties>(context, listen: false)
            .findById(_serviceRecord.typeId);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        floatingActionButton: _hasImage
            ? null
            : FloatingActionButton.extended(
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Add Invoice'),
                onPressed: () async {
                  final dialogResponse = await addImageDialog(context);
                  if (dialogResponse == null) return;
                  PickedFile image = await _picker.getImage(
                    source: dialogResponse,
                    imageQuality: 25,
                  );
                  if (image == null) return;
                  Provider.of<ServiceRecords>(context, listen: false)
                      .updateRecord(_serviceRecord, File(image.path));
                },
              ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: _hasImage ? 300 : null,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final res = await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (ctx) => AddRecordScreen.editRecord(
                        recordId: _serviceRecord.id,
                        recordType: _serviceRecord.type,
                        recordTypeId: _serviceRecord.typeId,
                      ),
                    );
                    if (res == null) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final res = await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Delete service record?'),
                        content: Text(
                          'Are you sure you want to delete ${_serviceRecord.name} for ${_recordParent.vehicleName()}?',
                        ),
                        actions: [
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );
                    if (res == null || !res) return;
                    Provider.of<ServiceRecords>(context, listen: false)
                        .deleteRecord(_serviceRecord.id);
                    Navigator.of(context).pop({'deleted': true});
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_serviceRecord.name),
                background: _hasImage
                    ? Hero(
                        tag: _serviceRecord.id,
                        child: Image.network(
                          _serviceRecord.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        _serviceRecord.type == 'Vehicle'
                            ? '${_recordParent.vehicleName()}'
                            : '${_serviceRecord.typeId}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_formattedDate.format(_serviceRecord.dateOfService)}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '${_formattedCost.format(_serviceRecord.cost)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Location: ${_serviceRecord.location}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description:\n${_serviceRecord.description}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
