// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:maintenance_man_v2/vehicle.dart';
// import 'package:maintenance_man_v2/vehicle_model.dart';
// import 'package:provider/provider.dart';

// class AddVehicleForm extends StatefulWidget {
//   final ScrollController scrollController;

//   const AddVehicleForm({Key key, this.scrollController}) : super(key: key);

//   @override
//   _AddVehicleFormState createState() => _AddVehicleFormState();
// }

// class _AddVehicleFormState extends State<AddVehicleForm> {
//   final FocusNode _yearFocusNode = FocusNode();
//   final FocusNode _makeFocusNode = FocusNode();
//   final FocusNode _modelFocusNode = FocusNode();
//   final FocusNode _trimFocusNode = FocusNode();
//   final FocusNode _mileageFocusNode = FocusNode();

//   final _year = TextEditingController();
//   final _make = TextEditingController();
//   final _model = TextEditingController();
//   final _trim = TextEditingController();
//   final _mileage = TextEditingController();

//   void _submitVehicle(BuildContext context) {
//     Vehicle vehicle = new Vehicle(
//         year: int.parse(_year.text),
//         make: _make.text,
//         model: _model.text,
//         vehicleTrim: _trim.text,
//         mileage: int.parse(_mileage.text));

//     VehicleModel vehicleModel =
//         Provider.of<VehicleModel>(context, listen: false);
//     vehicleModel.add(vehicle);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//       child: Material(
//         color: Colors.transparent,
//         child: Scaffold(
//             backgroundColor: CupertinoTheme.of(context)
//                 .scaffoldBackgroundColor
//                 .withOpacity(0.95),
//             extendBodyBehindAppBar: true,
//             appBar: appBar(context),
//             body: CustomScrollView(
//               physics: ClampingScrollPhysics(),
//               controller: widget.scrollController,
//               slivers: <Widget>[
//                 SliverSafeArea(
//                   bottom: false,
//                   sliver: SliverToBoxAdapter(
//                     child: Container(
//                       height: 0,
//                     ),
//                   ),
//                 ),
//                 _sliverVehicleForm(context),
//                 SliverSafeArea(
//                   top: false,
//                   sliver: SliverPadding(
//                       padding: EdgeInsets.only(
//                     bottom: 20,
//                   )),
//                 )
//               ],
//             )),
//       ),
//     );
//   }

//   PreferredSizeWidget appBar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size(double.infinity, 74),
//       child: ClipRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               CupertinoButton(
//                 child: Text(
//                   'Cancel',
//                   style: CupertinoTheme.of(context)
//                       .textTheme
//                       .textStyle
//                       .copyWith(color: Colors.red),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               Text(
//                 'Vehicle Form',
//                 style: CupertinoTheme.of(context)
//                     .textTheme
//                     .textStyle
//                     .copyWith(fontWeight: FontWeight.w600),
//               ),
//               CupertinoButton(
//                 child: Text(
//                   'Add',
//                   style: CupertinoTheme.of(context)
//                       .textTheme
//                       .textStyle
//                       .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
//                 ),
//                 onPressed: () => _submitVehicle(context),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _sliverVehicleForm(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Container(
//         padding: EdgeInsets.only(top: 0, left: 20, right: 20),
//         child: Form(
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 focusNode: _makeFocusNode,
//                 controller: _make,
//                 // initialValue: _make?.text,
//                 // onChanged: (make) {
//                 //   setState(() {
//                 //     _make.text = make;
//                 //   });
//                 // },
//                 onEditingComplete: () =>
//                     FocusScope.of(context).requestFocus(_modelFocusNode),
//                 decoration: InputDecoration(
//                     labelText: 'Vehicle Make',
//                     hintText: 'ie. Toyota, Dodge, etc'),
//                 textInputAction: TextInputAction.next,
//                 textCapitalization: TextCapitalization.words,
//               ),
//               TextFormField(
//                 focusNode: _modelFocusNode,
//                 controller: _model,
//                 // initialValue: _make?.text,
//                 // onChanged: (make) {
//                 //   setState(() {
//                 //     _make.text = make;
//                 //   });
//                 // },
//                 onEditingComplete: () =>
//                     FocusScope.of(context).requestFocus(_trimFocusNode),
//                 decoration: InputDecoration(
//                     labelText: 'Vehicle Model',
//                     hintText: 'ie. Camry, Chellenger, etc'),
//                 textInputAction: TextInputAction.next,
//                 textCapitalization: TextCapitalization.words,
//               ),
//               TextFormField(
//                 focusNode: _trimFocusNode,
//                 controller: _trim,
//                 // initialValue: _make?.text,
//                 // onChanged: (make) {
//                 //   setState(() {
//                 //     _make.text = make;
//                 //   });
//                 // },
//                 onEditingComplete: () =>
//                     FocusScope.of(context).requestFocus(_yearFocusNode),
//                 decoration: InputDecoration(
//                     labelText: 'Vehicle Trim', hintText: 'ie. LE, SXT, etc'),
//                 textInputAction: TextInputAction.next,
//                 textCapitalization: TextCapitalization.words,
//               ),
//               TextFormField(
//                 focusNode: _yearFocusNode,
//                 controller: _year,
//                 // initialValue: _make?.text,
//                 // onChanged: (make) {
//                 //   setState(() {
//                 //     _make.text = make;
//                 //   });
//                 // },
//                 onEditingComplete: () =>
//                     FocusScope.of(context).requestFocus(_mileageFocusNode),
//                 decoration: InputDecoration(labelText: 'Vehicle Year'),
//                 textInputAction: TextInputAction.next,
//                 textCapitalization: TextCapitalization.words,
//               ),
//               TextFormField(
//                 focusNode: _mileageFocusNode,
//                 controller: _mileage,
//                 // initialValue: _make?.text,
//                 // onChanged: (make) {
//                 //   setState(() {
//                 //     _make.text = make;
//                 //   });
//                 // },
//                 // onEditingComplete: () =>
//                 //     FocusScope.of(context).requestFocus(_mileageFocusNode),
//                 decoration: InputDecoration(labelText: 'Vehicle Mileage'),
//                 textInputAction: TextInputAction.go,
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
