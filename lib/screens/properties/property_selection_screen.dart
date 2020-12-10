import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:provider/provider.dart';

class PropertySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<Properties>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: CustomColorTheme.selectionScreenAccent,
        ),
        title: Text(
          'Property Select',
          style: TextStyle(color: CustomColorTheme.selectionScreenAccent),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // showCupertinoModalBottomSheet(
              //   expand: true,
              //   context: context,
              //   backgroundColor: Colors.transparent,
              //   builder: (context) => AddVehicleScreen(),
              // ).then((value) {
              //   if (value == null) return;
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(value),
              //       duration: Duration(seconds: 2),
              // backgroundColor: CustomColorTheme.selectionScreenAccent,
              //     ),
              //   );
              // });
            },
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: CustomColorTheme.selectionScreenBackground,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: CustomColorTheme.selectionScreenBackground,
        ),
      ),
    );
  }
}
