import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';

class AppInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColorTheme.selectionScreenBackground,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
        child: Column(
          children: [
            Text('Info Screen'),
          ],
        ),
      ),
    );
  }
}
