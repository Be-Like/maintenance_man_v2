import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/screens/properties/property_info_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PropertyListItem extends StatelessWidget {
  final Property property;

  PropertyListItem(this.property);

  @override
  Widget build(BuildContext context) {
    var title = property.name == null || property.name == ''
        ? property.address
        : property.name;
    return GestureDetector(
      onTap: () {
        Provider.of<Properties>(context, listen: false)
            .selectProperty(property.id);
        Navigator.of(context).pop();
      },
      onLongPress: () async {
        final res =
            await Navigator.of(context).push(MaterialWithModalsPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => PropertyInfoScreen(property.id),
        ));
        if (res != null && res['deleted']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Property successfully deleted'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: 60,
            child: CircleAvatar(
              backgroundImage: property.imageUrl != null
                  ? NetworkImage(property.imageUrl)
                  : AssetImage('assets/images/DefaultProperty.jpg'),
              radius: 57,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
