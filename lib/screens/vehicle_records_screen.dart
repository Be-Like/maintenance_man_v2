import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/screens/add_record_screen.dart';
import 'package:maintenance_man_v2/screens/vehicle_selection_screen.dart';
import 'package:maintenance_man_v2/widgets/app_drawer.dart';
import 'package:maintenance_man_v2/widgets/service_record_list_item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class VehicleRecordsScreen extends StatefulWidget {
  @override
  _VehicleRecordsScreenState createState() => _VehicleRecordsScreenState();
}

class _VehicleRecordsScreenState extends State<VehicleRecordsScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Vehicles>(context, listen: false)
          .initializeVehicles()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: Platform.isIOS
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            const Text('Vehicles'),
            Consumer<Vehicles>(
              builder: (ctx, vehiclesData, _) =>
                  vehiclesData.selectedVehicle == null
                      ? Container()
                      : Text(
                          '${vehiclesData.selectedVehicle.vehicleName()}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icons/vehicle_selection.png'),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialWithModalsPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => VehicleSelectionScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Vehicles>(
              builder: (ctx, vehiclesData, _) => FutureBuilder(
                future: Provider.of<ServiceRecords>(ctx, listen: false)
                    .initializeRecords(vehiclesData?.selectedVehicle?.id),
                builder: (cnx, snapshot) {
                  if (vehiclesData.selectedVehicle == null) {
                    return Center(
                      child: Text(
                        'To get started, add a vehicle.',
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('Status: ${snapshot.connectionState}');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.error != null) {
                      return Center(
                        child: Text('An error occurred'),
                      );
                    } else {
                      return Consumer<ServiceRecords>(
                        builder: (context, serviceRecords, _) =>
                            serviceRecords.records.length == 0
                                ? Center(
                                    child: Text(
                                        'No records exist for this vehicle'),
                                  )
                                : ListView.separated(
                                    separatorBuilder: (ctx, index) => Divider(),
                                    itemCount: serviceRecords.records.length,
                                    itemBuilder: (context, index) =>
                                        ServiceRecordListItem(
                                      serviceRecords.records[index],
                                    ),
                                  ),
                      );
                    }
                  }
                },
              ),
            ),
      floatingActionButton: Consumer<Vehicles>(
        builder: (ctx, vehicleData, _) => FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          splashColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).primaryColorDark,
          onPressed: () async {
            final res = await showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              builder: (ctx) => AddRecordScreen(
                recordType: 'Vehicle',
                recordTypeId: vehicleData.selectedVehicle.id,
              ),
            );
            if (res != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(res),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
