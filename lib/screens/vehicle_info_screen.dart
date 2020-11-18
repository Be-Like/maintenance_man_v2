import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/screens/add_vehicle_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class VehicleInfoScreen extends StatelessWidget {
  static const routeName = '/vehicle-info';
  final String vehicleId;

  VehicleInfoScreen(this.vehicleId);

  @override
  Widget build(BuildContext context) {
    var vehicle = Provider.of<Vehicles>(context).findById(vehicleId);
    final lastUpdated =
        DateFormat('MMM dd, yyyy h:mm aaaa').format(vehicle.updatedAt);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) {
                        return AddVehicleScreen.editVehicle(vehicle.id);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<Vehicles>(context, listen: false)
                        .deleteVehicle(vehicleId);
                    Navigator.of(context).pop({'deleted': true});
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(vehicle.vehicleName()),
                background: Hero(
                  tag: vehicle.id,
                  child: Image.network(
                    vehicle.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
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
                        'Year: ${vehicle.year}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Make: ${vehicle.make}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Model: ${vehicle.model}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Trim: ${vehicle.vehicleTrim}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Color: ${vehicle.color.toString()}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Last Updated: $lastUpdated',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
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
