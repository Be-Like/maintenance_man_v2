import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/widgets/add_image_dialog.dart';
import 'package:provider/provider.dart';

class AddPropertyScreen extends StatefulWidget {
  static const routeName = '/add-propery';
  final String propertyId;

  AddPropertyScreen() : propertyId = null;

  AddPropertyScreen.editProperty(this.propertyId);

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  var _isInit = true;
  final _picker = ImagePicker();
  File _propertyImage;

  static const _required = 'This field is required';
  final _form = GlobalKey<FormState>();
  final _addressFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _yearFocusNode = FocusNode();
  final _propertyTypeFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  var _property = Property(
    id: null,
    user: FirebaseAuth.instance.currentUser.uid,
    address: null,
    name: null,
    description: null,
    year: null,
    propertyType: null,
    imageUrl: null,
  );
  var _initValues = {
    'address': '',
    'name': '',
    'description': '',
    'year': '',
    'propertyType': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit && widget.propertyId != null) {
      _property = Provider.of<Properties>(context, listen: false)
          .findById(widget.propertyId);
      _initValues = {
        'address': _property.address,
        'name': _property.name,
        'description': _property.description,
        'year': _property.year.toString(),
        'propertyType': _property.propertyType,
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addressFocusNode.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _yearFocusNode.dispose();
    _propertyTypeFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitProperty() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    // if (_property.year == null) _property.year = 0;
    _form.currentState.save();

    if (widget.propertyId != null) {
      try {} catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update property information'),
        ));
      }
    } else {
      try {
        await Provider.of<Properties>(context, listen: false).addProperty(
          _property,
          _propertyImage,
        );
        final propName = _property.name == null || _property.name == ''
            ? _property.address
            : _property.name;
        Navigator.of(context).pop('$propName successfully added');
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add property'),
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
                'Property Form',
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
                onPressed: () => _submitProperty(),
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
                    _propertyImage = File(image.path);
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_propertyImage != null)
                      Image.file(
                        _propertyImage,
                        fit: BoxFit.cover,
                      ),
                    if (_propertyImage == null && _property.imageUrl == null)
                      Image.asset(
                        'assets/images/DefaultVehicle.jpg',
                        fit: BoxFit.cover,
                        color: _property.imageUrl == null
                            ? Colors.black.withOpacity(0.3)
                            : null,
                        colorBlendMode: BlendMode.srcOver,
                      ),
                    if (_property.imageUrl != null && _propertyImage == null)
                      Image.network(
                        _property.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    if (_property.imageUrl == null && _propertyImage == null)
                      Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              TextFormField(
                focusNode: _addressFocusNode,
                initialValue: _initValues['address'],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_nameFocusNode),
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: '111 Example St, Charlotte NC, 29828',
                ),
                validator: (value) => value.isEmpty ? _required : null,
                onChanged: (value) {
                  _property.address = value;
                },
              ),
              TextFormField(
                focusNode: _nameFocusNode,
                initialValue: _initValues['name'],
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_propertyTypeFocusNode),
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) => _property.name = value,
              ),
              DropdownButtonFormField(
                focusNode: _propertyTypeFocusNode,
                decoration: InputDecoration(
                  labelText: 'Property Type',
                ),
                items: ['Residential', 'Commercial', 'Other']
                    .map((item) => DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        ))
                    .toList(),
                onChanged: (value) => _property.propertyType = value,
              ),
              TextFormField(
                focusNode: _yearFocusNode,
                initialValue: _initValues['year'],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                decoration: InputDecoration(labelText: 'Build Year'),
                onChanged: (value) {
                  if (value == null || value == '') return;
                  _property.year = int.parse(value);
                },
              ),
              TextFormField(
                focusNode: _descriptionFocusNode,
                initialValue: _initValues['description'],
                maxLines: 3,
                textInputAction: TextInputAction.go,
                textCapitalization: TextCapitalization.sentences,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => _property.description = value,
                onFieldSubmitted: (_) => _submitProperty(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
