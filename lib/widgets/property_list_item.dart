import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/properties.dart';

class PropertyListItem extends StatelessWidget {
  final Property property;

  PropertyListItem(this.property);

  @override
  Widget build(BuildContext context) {
    var title = property.name == null || property.name == ''
        ? property.address
        : property.name;
    return GestureDetector(
      onTap: () {},
      onLongPress: () {},
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
          Text(title),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
