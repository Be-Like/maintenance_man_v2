import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart'
    show Vehicle, Vehicles;
import 'package:maintenance_man_v2/screens/add_vehicle_screen.dart';
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
      onLongPress: () {
        showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (ctx, scrollController) {
            return AddVehicleScreen.editVehicle(scrollController, vehicle.id);
          },
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: vehicle.color,
            radius: 60,
          ),
          SizedBox(height: 10),
          Text(vehicleTitle),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
