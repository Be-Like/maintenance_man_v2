import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/screens/properties/property_selection_screen.dart';
import 'package:maintenance_man_v2/widgets/app_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PropertyRecordsScreen extends StatefulWidget {
  static const routeName = '/properties';

  @override
  _PropertyRecordsScreenState createState() => _PropertyRecordsScreenState();
}

class _PropertyRecordsScreenState extends State<PropertyRecordsScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    final prov = Provider.of<Properties>(context, listen: false);
    if (_isInit && prov.properties.length == 0) {
      setState(() {
        _isLoading = true;
      });
      prov.initializeProperties().then((_) {
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
          crossAxisAlignment: Platform.isIOS
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            const Text('Properties'),
            Consumer<Properties>(
              builder: (ctx, propertiesData, _) {
                var property = propertiesData?.selectedProperty;
                var subtitle = property?.name == null || property?.name == ''
                    ? property?.address
                    : property.name;
                return property == null
                    ? Container()
                    : Text(
                        '$subtitle',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icons/deal.png'),
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialWithModalsPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => PropertySelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
