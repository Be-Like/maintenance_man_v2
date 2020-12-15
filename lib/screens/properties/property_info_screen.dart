import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/screens/properties/add_property_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PropertyInfoScreen extends StatelessWidget {
  static const routeName = '/property-info';
  final String propertyId;

  PropertyInfoScreen(this.propertyId);

  @override
  Widget build(BuildContext context) {
    var property = Provider.of<Properties>(context).findById(propertyId);
    final propertyName = property.name == null || property.name == ''
        ? property.address
        : property.name;
    final lastUpdated =
        DateFormat('MMM dd, yyyy h:mm aaaa').format(property.updatedAt);
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
                        return AddPropertyScreen.editProperty(property.id);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final res = await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Delete vehicle?'),
                        content: Text(
                          'Are you sure you want to delete $propertyName? This action is permanent.',
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                    if (res != null && res) {
                      Provider.of<Properties>(context, listen: false)
                          .deleteProperty(propertyId);
                      Navigator.of(context).pop({'deleted': true});
                    }
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(propertyName),
                background: Hero(
                  tag: property.id,
                  child: property.imageUrl == null
                      ? Image.asset(
                          'assets/images/DefaultVehicle.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          property.imageUrl,
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
                        'Address: ${property.address}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Name: ${property.name ?? ''}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Type: ${property.propertyType ?? ''}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Year: ${property.year ?? ''}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description: ${property.description ?? ''}',
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
