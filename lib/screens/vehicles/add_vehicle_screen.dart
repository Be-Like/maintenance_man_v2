import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';
import 'package:maintenance_man_v2/widgets/add_image_dialog.dart';
import 'package:provider/provider.dart';

class AddVehicleScreen extends StatefulWidget {
  static const routeName = '/add-vehicle';
  final String vehicleId;

  AddVehicleScreen() : vehicleId = null;

  AddVehicleScreen.editVehicle(this.vehicleId);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  var _isInit = true;
  final _picker = ImagePicker();
  File _vehicleImage;

  static const _required = 'This field is required';
  final _form = GlobalKey<FormState>();
  final _yearFocusNode = FocusNode();
  final _makeFocusNode = FocusNode();
  final _modelFocusNode = FocusNode();
  final _trimFocusNode = FocusNode();
  final _mileageFocusNode = FocusNode();

  final _colorController = TextEditingController();

  var _vehicle = Vehicle(
    id: DateTime.now().toString(),
    user: FirebaseAuth.instance.currentUser.uid,
    year: null,
    make: '',
    model: '',
    vehicleTrim: '',
    mileage: null,
    color: CustomColorTheme.selectionScreenAccent,
    imageUrl: null,
  );
  var _initValues = {
    'year': '',
    'make': '',
    'model': '',
    'trim': '',
    'mileage': '',
  };

  @override
  void initState() {
    super.initState();
    _colorController.text = _vehicle.color.toString();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.vehicleId != null) {
        _vehicle = Provider.of<Vehicles>(context).findById(widget.vehicleId);
        _initValues = {
          'year': _vehicle.year.toString(),
          'make': _vehicle.make,
          'model': _vehicle.model,
          'trim': _vehicle.vehicleTrim,
          'mileage': _vehicle.mileage.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _yearFocusNode.dispose();
    _makeFocusNode.dispose();
    _modelFocusNode.dispose();
    _trimFocusNode.dispose();
    _mileageFocusNode.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _submitVehicle() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    if (_vehicle.mileage == null) _vehicle.mileage = 0;
    if (_vehicle.color == null)
      _vehicle.color = CustomColorTheme.selectionScreenAccent;
    _form.currentState.save();
    if (widget.vehicleId != null) {
      try {
        await Provider.of<Vehicles>(context, listen: false)
            .updateVehicle(widget.vehicleId, _vehicle, _vehicleImage);
        Navigator.of(context).pop('${_vehicle.vehicleName()} updated');
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update vehicle information'),
          ),
        );
      }
    } else {
      try {
        await Provider.of<Vehicles>(context, listen: false)
            .addVehicle(_vehicle, _vehicleImage);
        Navigator.of(context)
            .pop('${_vehicle.vehicleName()} successfully added');
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add vehicle'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Material(
        color: Colors.transparent,
        child: Scaffold(
            backgroundColor: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.95),
            extendBodyBehindAppBar: true,
            appBar: appBar(context),
            body: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverSafeArea(
                  bottom: false,
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      height: 0,
                    ),
                  ),
                ),
                _sliverVehicleForm(context),
                SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                      padding: EdgeInsets.only(
                    bottom: 20,
                  )),
                )
              ],
            )),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 74),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CupertinoButton(
                child: Text(
                  'Cancel',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Vehicle Form',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              CupertinoButton(
                child: Text(
                  'Save',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
                ),
                onPressed: () => _submitVehicle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sliverVehicleForm(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final dialogResponse = await addImageDialog(context);
                  if (dialogResponse == null) return;
                  PickedFile image =
                      await _picker.getImage(source: dialogResponse);
                  if (image == null) return;
                  setState(() {
                    _vehicleImage = File(image.path);
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_vehicleImage != null)
                      Image.file(
                        _vehicleImage,
                        fit: BoxFit.cover,
                      ),
                    if (_vehicleImage == null && _vehicle.imageUrl == null)
                      Image.asset(
                        'assets/images/DefaultVehicle.jpg',
                        fit: BoxFit.cover,
                        color: _vehicle.imageUrl == null
                            ? Colors.black.withOpacity(0.3)
                            : null,
                        colorBlendMode: BlendMode.srcOver,
                      ),
                    if (_vehicle.imageUrl != null && _vehicleImage == null)
                      Image.network(
                        _vehicle.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    if (_vehicle.imageUrl == null && _vehicleImage == null)
                      Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              TextFormField(
                focusNode: _yearFocusNode,
                initialValue: _initValues['year'],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_makeFocusNode),
                decoration: InputDecoration(labelText: 'Vehicle Year'),
                validator: (value) => value.isEmpty ? _required : null,
                onSaved: (value) => _vehicle.year = int.parse(value),
              ),
              TextFormField(
                focusNode: _makeFocusNode,
                initialValue: _initValues['make'],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_modelFocusNode),
                decoration: InputDecoration(
                  labelText: 'Vehicle Make',
                  hintText: 'ie. Toyota, Dodge, etc',
                ),
                validator: (value) => value.isEmpty ? _required : null,
                onSaved: (value) {
                  _vehicle.make = value;
                },
              ),
              TextFormField(
                focusNode: _modelFocusNode,
                initialValue: _initValues['model'],
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_trimFocusNode),
                decoration: InputDecoration(
                    labelText: 'Vehicle Model',
                    hintText: 'ie. Camry, Chellenger, etc'),
                validator: (value) => value.isEmpty ? _required : null,
                onSaved: (value) => _vehicle.model = value,
              ),
              TextFormField(
                focusNode: _trimFocusNode,
                initialValue: _initValues['trim'],
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_mileageFocusNode),
                decoration: InputDecoration(
                    labelText: 'Vehicle Trim', hintText: 'ie. LE, SXT, etc'),
                onSaved: (value) => _vehicle.vehicleTrim = value,
              ),
              TextFormField(
                focusNode: _mileageFocusNode,
                initialValue: _initValues['mileage'],
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.number,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(labelText: 'Vehicle Mileage'),
                onSaved: (value) {
                  if (value.isEmpty) return;
                  _vehicle.mileage = int.parse(value);
                },
                // onFieldSubmitted: (_) => _submitVehicle(),
              ),
              TextField(
                readOnly: true,
                controller: _colorController,
                maxLines: 1,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Color',
                  icon: CircleAvatar(
                    backgroundColor: _vehicle.color,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      actions: [
                        FlatButton(
                          child: const Text('That\'s Me'),
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      content: SingleChildScrollView(
                        child: SlidePicker(
                          pickerColor: Theme.of(context).accentColor,
                          onColorChanged: (color) {
                            _vehicle.color = color;
                          },
                          showLabel: false,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
