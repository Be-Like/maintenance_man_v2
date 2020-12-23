import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/auth.dart';
import 'package:maintenance_man_v2/screens/miscellaneous/app_info_screen.dart';
import 'package:maintenance_man_v2/screens/miscellaneous/settings_screen.dart';
import 'package:maintenance_man_v2/screens/properties/property_records_screen.dart';
import 'package:maintenance_man_v2/widgets/user_drawer_info.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: UserDrawerInfo(),
          ),
          Divider(height: 0),
          ListTile(
            leading: ImageIcon(AssetImage('assets/icons/car.png')),
            title: Text('Vehicle Records'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(height: 0),
          ListTile(
            leading: ImageIcon(AssetImage('assets/icons/home.png')),
            title: Text('Property Records'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              PropertyRecordsScreen.routeName,
            ),
          ),
          Divider(height: 0),
          Spacer(),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).signOut();
            },
          ),
          Divider(height: 0),
          SizedBox(height: 7),
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.info),
                splashRadius: 1,
                onPressed: () async => await Navigator.of(context).push(
                  MaterialWithModalsPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => AppInfoScreen(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                splashRadius: 1,
                onPressed: () async => await Navigator.of(context).push(
                  MaterialWithModalsPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => SettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
