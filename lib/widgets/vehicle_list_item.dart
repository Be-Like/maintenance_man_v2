import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart'
    show Vehicle, Vehicles;
import 'package:maintenance_man_v2/screens/vehicles/add_vehicle_screen.dart';
import 'package:maintenance_man_v2/screens/vehicles/vehicle_info_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class VehicleListItem extends StatelessWidget {
  final Vehicle vehicle;

  VehicleListItem(this.vehicle);

  @override
  Widget build(BuildContext context) {
    final vehicleTitle =
        '${vehicle.year} ${vehicle.make} ${vehicle.model} ${vehicle.vehicleTrim}';
    return GestureDetector(
      onTap: () {
        Provider.of<Vehicles>(context, listen: false).selectVehicle(vehicle.id);
        Navigator.of(context).pop();
      },
      onLongPress: () async {
        final res = await Navigator.of(context).push(
          MaterialWithModalsPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => VehicleInfoScreen(vehicle.id),
          ),
        );
        if (res != null && res['deleted']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vehicle successfully deleted'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: vehicle.color,
            radius: 60,
            child: CircleAvatar(
              backgroundImage: vehicle.imageUrl != null
                  ? NetworkImage(vehicle.imageUrl)
                  : AssetImage('assets/images/DefaultVehicle.jpg'),
              radius: 57,
            ),
          ),
          SizedBox(height: 10),
          Text(vehicleTitle),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
