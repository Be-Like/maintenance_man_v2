import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/screens/vehicle_selection_screen.dart';
import 'package:maintenance_man_v2/widgets/app_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class VehicleRecordsScreen extends StatelessWidget {
  Future<void> _initVehiclesAndRecords(BuildContext context) async {
    await Provider.of<Vehicles>(context).initializeVehicles();
    // await Provider.of<Vehicles>(context).initializeVehicleRecords();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Vehicles>(context).selectedVehicle;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vehicles'),
            Text(
              '${data.vehicleName()}',
              style: const TextStyle(
                fontSize: 14,
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
      body: FutureBuilder(
        future: _initVehiclesAndRecords(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Text('Hello records list'),
                  ),
      ),
    );
  }
}
