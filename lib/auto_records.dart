import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/add_vehicle_form.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AutoRecords extends StatefulWidget {
  @override
  _AutoRecordsState createState() => _AutoRecordsState();
}

class _AutoRecordsState extends State<AutoRecords> {
  double _displayVehicles = 0;

  Widget _vehicleSelection(BuildContext context) {
    List _backgroundColors = [
      Color.fromRGBO(230, 25, 75, 1),
      Color.fromRGBO(0, 128, 128, 1),
      Color.fromRGBO(145, 30, 180, 1)
    ];

    return Container(
      color: Color.fromRGBO(255, 255, 255, 0.75),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CircleAvatar(
                backgroundColor: _backgroundColors[Random().nextInt(3)],
                radius: 40,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'DC',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 30),
                  ),
                )),
          ),
          GestureDetector(
            onTap: () => showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context, scrollController) => AddVehicleForm(
                      scrollController: scrollController,
                    )),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                '+',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 30),
              ),
              radius: 40,
            ),
          ),
        ],
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
