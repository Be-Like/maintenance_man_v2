// import 'package:uuid/uuid.dart';

// class Vehicle {
//   String id;
//   int year;
//   String make;
//   String model;
//   String vehicleTrim;
//   int mileage;

//   Vehicle(
//       {String id,
//       int year,
//       String make,
//       String model,
//       String vehicleTrim,
//       int mileage})
//       : this.id = id ?? Uuid().v4(),
//         this.year = year,
//         this.make = make,
//         this.model = model,
//         this.vehicleTrim = vehicleTrim,
//         this.mileage = mileage;

//   @override
//   String toString() {
//     return '''Vehicle: { id: $id, year: $year, make: $make,
//       model: $model, trim: $vehicleTrim, mileage: $mileage }''';
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'vehicle_id': id,
//       'year': year,
//       'make': make,
//       'model': model,
//       'vehicle_trim': vehicleTrim,
//       'mileage': mileage
//     };
//   }
// }
