import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/add_vehicle_form.dart';
import 'package:maintenance_man_v2/vehicle_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AutoRecords extends StatefulWidget {
  @override
  _AutoRecordsState createState() => _AutoRecordsState();
}

class _AutoRecordsState extends State<AutoRecords> {
  VehicleModel vehicleModel = VehicleModel();
  double _displayVehicles = 0;

  @override
  void initState() {
    super.initState();
    vehicleModel.initVehicles();
  }

  Widget _vehicleSelection(BuildContext context) {
    // final vehicleModel = Provider.of<VehicleModel>(context);
    List _backgroundColors = [
      Color.fromRGBO(230, 25, 75, 1),
      Color.fromRGBO(0, 128, 128, 1),
      Color.fromRGBO(145, 30, 180, 1)
    ];

    return Container(
      color: Color.fromRGBO(255, 255, 255, 0.75),
      child: ListView.builder(
        itemCount: vehicleModel.vehicles.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return index >= vehicleModel.vehicles.length
              ? GestureDetector(
                  onTap: () => showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context, scrollController) => AddVehicleForm(
                            scrollController: scrollController,
                          )),
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(
                        '+',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                                fontWeight: FontWeight.w400, fontSize: 30),
                      ),
                      radius: 40,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(left: 15),
                  child: CircleAvatar(
                      backgroundColor: _backgroundColors[Random().nextInt(3)],
                      radius: 40,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          '${vehicleModel.vehicles[index].make}\n${vehicleModel.vehicles[index].model}',
                          textAlign: TextAlign.center,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      )),
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Records'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.directions_car_outlined),
              onPressed: () {
                setState(() {
                  _displayVehicles = _displayVehicles == 100 ? 0 : 100;
                });
              })
        ],
      ),
      body: Stack(
        children: [
          // RecordsListView(),
          Positioned(
            child: AnimatedContainer(
                height: _displayVehicles,
                duration: Duration(milliseconds: 400),
                child: _vehicleSelection(context)),
          ),
        ],
      ),
    );
  }
}
