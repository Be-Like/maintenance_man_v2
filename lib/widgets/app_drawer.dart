import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('App Drawer'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: ImageIcon(AssetImage('assets/icons/car.png')),
            title: Text('Vehicle Records'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
        ],
      ),
    );
  }
}
