// import 'package:maintenance_man_v2/vehicle.dart';
// import 'package:sqflite/sqflite.dart';

// abstract class AppDatabase {
//   static Database _db;
//   static int get _version => 1;
//   static Future<void> init() async {
//     if (_db != null) {
//       return;
//     }

//     try {
//       String _path = await getDatabasesPath() + '/maintenance_man';
//       _db = await openDatabase(_path, version: _version, onCreate: onCreate);
//     } catch (error) {
//       print(error);
//     }
//   }

//   static void onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS vehicle (
//         vehicle_id TEXT PRIMARY KEY NOT NULL,
//         year INTEGER,
//         make TEXT,
//         model TEXT,
//         vehicle_trim TEXT,
//         mileage INTEGER
//       )
//     ''');
//   }

//   static Future<List<Map<String, dynamic>>> query(String table) async {
//     return await _db.query(table).then((value) {
//       return List.from(value);
//     });
//   }

//   static Future<int> insertVehicle(String table, Vehicle vehicle) async =>
//       await _db.insert(table, vehicle.toMap());
// }
