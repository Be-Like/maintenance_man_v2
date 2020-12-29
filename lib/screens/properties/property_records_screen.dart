import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/screens/properties/property_selection_screen.dart';
import 'package:maintenance_man_v2/screens/service_records/add_record_screen.dart';
import 'package:maintenance_man_v2/widgets/app_drawer.dart';
import 'package:maintenance_man_v2/widgets/service_record_list_item.dart';
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
    if (_isInit && prov.properties.length <= 0) {
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Properties>(
              builder: (ctx, propertiesData, _) => FutureBuilder(
                future: Provider.of<ServiceRecords>(context, listen: false)
                    .initializeRecords(propertiesData?.selectedProperty?.id),
                builder: (cnx, snapshot) {
                  if (propertiesData.selectedProperty == null) {
                    return Center(
                      child: Text('To get started, add a property.'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.error != null) {
                    return Center(
                      child: Text('An error occurred'),
                    );
                  }
                  return Consumer<ServiceRecords>(
                    builder: (context, serviceRecords, _) =>
                        serviceRecords.records.length == 0
                            ? Center(
                                child: Text(
                                  'No records exist for this property.',
                                ),
                              )
                            : ListView.separated(
                                separatorBuilder: (ctx, index) => Divider(
                                  height: 0,
                                ),
                                itemCount: serviceRecords.records.length,
                                itemBuilder: (context, index) =>
                                    ServiceRecordListItem(
                                  serviceRecords.records[index],
                                ),
                              ),
                  );
                },
              ),
            ),
      floatingActionButton: Consumer<Properties>(
        builder: (ctx, propertyData, _) => FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          splashColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).primaryColorDark,
          onPressed: () async {
            final res = await showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              builder: (ctx) => AddRecordScreen(
                recordType: 'Property',
                recordTypeId: propertyData.selectedProperty.id,
              ),
            );
            if (res == null) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res),
              backgroundColor: Theme.of(context).accentColor,
            ));
          },
        ),
      ),
    );
  }
}
