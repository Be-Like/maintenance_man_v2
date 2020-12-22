import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/auth.dart';
import 'package:maintenance_man_v2/screens/properties/property_records_screen.dart';
import 'package:provider/provider.dart';

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
          ListTile(
            leading: ImageIcon(AssetImage('assets/icons/home.png')),
            title: Text('Property Records'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              PropertyRecordsScreen.routeName,
            ),
          ),
          Divider(),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).signOut();
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
