import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
// import 'package:maintenance_man_v2/screens/auth_screen.dart';
import 'package:maintenance_man_v2/screens/vehicle_records_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

// Themes available at: https://coolors.co/404e5c-4f6272-f8f1ff-57755b-7bd389
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Vehicles(),
        ),
      ],
      child: MaterialApp(
        title: 'Maintenance Man',
        theme: ThemeData(
          primarySwatch: CustomColorTheme().customColor(),
          // primaryColorDark: Color.fromRGBO(64, 78, 92, 1),
          // primaryColorLight: Color.fromRGBO(79, 98, 114, 1),
          // accentColor: Color.fromRGBO(123, 211, 137, 1),
          // backgroundColor: Color.fromRGBO(248, 241, 255, 1),
        ),
        home: VehicleRecordsScreen(),
        routes: {},
      ),
    );
  }
}
