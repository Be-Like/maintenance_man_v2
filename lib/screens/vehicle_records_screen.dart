import 'package:flutter/material.dart';

class VehicleRecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.car_repair,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
      ),
      body: Center(
        child: Text('Hello Vehicles screen'),
      ),
    );
  }
}
