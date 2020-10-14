import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/app_database.dart';
import 'package:maintenance_man_v2/auto_records.dart';
import 'package:maintenance_man_v2/vehicle_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VehicleModel(),
        ),
      ],
      child: MaterialApp(
        // onGenerateRoute: (RouteSettings settings) {
        //   switch (settings.name) {
        //     case '/':
        //       return MaterialWithModalsPageRoute(
        //           builder: (_) => AutoRecords(), settings: settings);
        //   }
        // },
        routes: {'/': (context) => AutoRecords()},
      ),
    );
  }
}
