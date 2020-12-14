import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:provider/provider.dart';

class PropertyInfoScreen extends StatelessWidget {
  static const routeName = '/property-info';
  final String propertyId;

  PropertyInfoScreen(this.propertyId);

  @override
  Widget build(BuildContext context) {
    var property = Provider.of<Properties>(context).findById(propertyId);
    final lastUpdated = DateFormat('');
    return Container();
  }
}
