import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/screens/vehicle_selection_screen.dart';
import 'package:maintenance_man_v2/widgets/app_drawer.dart';
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
      Provider.of<Vehicles>(context).initializeVehicles().then((_) {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Vehicles'),
            Consumer<Vehicles>(
              builder: (ctx, vehiclesData, _) => Text(
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
          : Center(
              child: Text('Hello records list'),
            ),
    );
  }
}
