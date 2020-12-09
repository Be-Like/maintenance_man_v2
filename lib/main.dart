import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/auth.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/screens/auth_screen.dart';
import 'package:maintenance_man_v2/screens/properties/property_records_screen.dart';
import 'package:maintenance_man_v2/screens/service_records/vehicle_records_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// Themes available at: https://coolors.co/404e5c-4f6272-f8f1ff-57755b-7bd389
class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? CircularProgressIndicator() // TODO: This should display splash screen
          : MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (ctx) => Auth(),
                ),
                ChangeNotifierProvider(
                  create: (ctx) => Vehicles(),
                ),
                ChangeNotifierProvider(
                  create: (ctx) => Properties(),
                ),
                ChangeNotifierProvider(
                  create: (ctx) => ServiceRecords(),
                ),
              ],
              child: Consumer<Auth>(
                builder: (ctx, auth, _) => MaterialApp(
                  title: 'Maintenance Man',
                  theme: ThemeData(
                    primarySwatch: CustomColorTheme().customColor(),
                    // primaryColorDark: Color.fromRGBO(64, 78, 92, 1),
                    // primaryColorLight: Color.fromRGBO(79, 98, 114, 1),
                    accentColor: Color(0xFF7bd389),
                    // backgroundColor: Color.fromRGBO(248, 241, 255, 1),
                  ),
                  home: auth.isAuth ? VehicleRecordsScreen() : AuthScreen(),
                  routes: {
                    PropertyRecordsScreen.routeName: (ctx) =>
                        PropertyRecordsScreen(),
                  },
                ),
              ),
            ),
    );
  }
}
