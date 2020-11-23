import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:provider/provider.dart';

class ServiceRecordInfoScreen extends StatelessWidget {
  static const routeName = '/service-record-info';
  final _formattedDate = DateFormat.yMMMd();
  final _formattedCost = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  final String recordId;

  ServiceRecordInfoScreen(this.recordId);

  @override
  Widget build(BuildContext context) {
    final _serviceRecord =
        Provider.of<ServiceRecords>(context).findById(recordId);
    final _hasImage =
        _serviceRecord.imageUrl != '' && _serviceRecord.imageUrl != null;
    final _recordVehicle = Provider.of<Vehicles>(context, listen: false)
        .findById(_serviceRecord.typeId);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        floatingActionButton: _hasImage
            ? null
            : FloatingActionButton.extended(
                icon: Icon(Icons.add_a_photo_outlined),
                label: Text('Add Receipt'),
                onPressed: () {},
              ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: _hasImage ? 300 : null,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
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
                            ? '${_recordVehicle.vehicleName()}'
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
