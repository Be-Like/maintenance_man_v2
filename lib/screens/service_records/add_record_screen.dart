import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/widgets/add_image_dialog.dart';
import 'package:provider/provider.dart';

class AddRecordScreen extends StatefulWidget {
  static const routeName = '/add-service-record';
  final String recordId;
  final String recordType;
  final String recordTypeId;

  AddRecordScreen({this.recordType, this.recordTypeId}) : recordId = null;

  AddRecordScreen.editRecord(
      {this.recordId, this.recordType, this.recordTypeId});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  var _isInit = true;
  var _isEnabled = true;

  static const _required = 'This field is required';
  final _form = GlobalKey<FormState>();
  FocusNode _recordNameFocusNode;
  final _dateFormField = TextEditingController();
  final _formattedDate = DateFormat.yMMMd();
  FocusNode _dateOfServiceFocusNode;
  FocusNode _costFocusNode;
  FocusNode _descriptionFocusNode;
  FocusNode _locationFocusNode;
  final _picker = ImagePicker();
  File _recordImage;

  var _record = ServiceRecord(
    id: null,
    name: '',
    dateOfService: DateTime.now(),
    typeId: null,
    cost: 0.0,
    description: '',
    location: '',
    imageUrl: '',
    type: null,
  );
  var _initValues = {
    'name': '',
    'dateOfService': '',
    'cost': '',
    'description': '',
    'location': '',
  };

  @override
  void initState() {
    super.initState();
    _recordNameFocusNode = FocusNode();
    _dateOfServiceFocusNode = FocusNode();
    _costFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _locationFocusNode = FocusNode();

    _record.type = widget.recordType;
    _record.typeId = widget.recordTypeId;
    _dateFormField.text = _formattedDate.format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.recordId != null) {
        _record =
            Provider.of<ServiceRecords>(context).findById(widget.recordId);
        _initValues = {
          'name': _record.name,
          'dateOfService': _record.dateOfService.toString(),
          'cost': _record.cost.toString(),
          'description': _record.description,
          'location': _record.location,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _recordNameFocusNode.dispose();
    _dateOfServiceFocusNode.dispose();
    _dateFormField.dispose();
    _costFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isEnabled = !isLoading;
    });
  }

  Future<void> _submitServiceRecord() async {
    if (!_isEnabled) return;
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _setLoading(true);

    _form.currentState.save();
    if (widget.recordId != null) {
      try {
        await Provider.of<ServiceRecords>(context, listen: false)
            .updateRecord(_record, _recordImage);
        Navigator.of(context).pop('${_record.name} updated');
      } catch (err) {
        _setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update service record'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      try {
        await Provider.of<ServiceRecords>(context, listen: false)
            .addRecord(_record, _recordImage);
        Navigator.of(context).pop('${_record.name} successfully added');
      } catch (err) {
        _setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add service record'),
            backgroundColor: Colors.red,
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
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.add_a_photo_outlined),
              label: _record.imageUrl == '' && _recordImage == null
                  ? const Text('Add Invoice')
                  : const Text('Edit Invoice'),
              onPressed: () async {
                if (!_isEnabled) return;
                final dialogResponse = await addImageDialog(context);
                if (dialogResponse == null) return;
                PickedFile image = await _picker.getImage(
                  source: dialogResponse,
                  imageQuality: 25,
                );
                if (image == null) return;
                setState(() {
                  _recordImage = File(image.path);
                });
              },
            ),
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
                _sliverServiceRecordForm(context),
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
      child: Stack(
        // mainAxisSize: MainAxisSize.min,
        alignment: Alignment.bottomCenter,
        children: [
          ClipRect(
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
                    'Service Record Form',
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
                          .copyWith(
                              fontWeight: FontWeight.w500, color: Colors.red),
                    ),
                    onPressed: () => _submitServiceRecord(),
                  ),
                ],
              ),
            ),
          ),
          if (!_isEnabled)
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                  CustomColorTheme.selectionScreenBackground),
            ),
        ],
      ),
    );
  }

  Widget _sliverServiceRecordForm(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              if (_recordImage != null)
                Image.file(
                  _recordImage,
                  fit: BoxFit.cover,
                ),
              if (_record.imageUrl != '' && _recordImage == null)
                Image.network(
                  _record.imageUrl,
                  fit: BoxFit.cover,
                ),
              TextFormField(
                enabled: _isEnabled,
                focusNode: _recordNameFocusNode,
                initialValue: _initValues['name'],
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_locationFocusNode),
                decoration: InputDecoration(labelText: 'Record Name'),
                validator: (value) => value.isEmpty ? _required : null,
                onSaved: (value) => _record.name = value,
              ),
              TextFormField(
                enabled: _isEnabled,
                focusNode: _locationFocusNode,
                initialValue: _initValues['location'],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_costFocusNode),
                decoration: InputDecoration(labelText: 'Service Location'),
                onSaved: (value) => _record.location = value,
              ),
              TextFormField(
                enabled: _isEnabled,
                focusNode: _costFocusNode,
                initialValue: _initValues['cost'],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onEditingComplete: () => FocusScope.of(context)
                    .requestFocus(_dateOfServiceFocusNode),
                decoration: InputDecoration(labelText: 'Cost'),
                onSaved: (value) {
                  if (value == null || value == '') return;
                  _record.cost = double.parse(value);
                },
              ),
              TextField(
                enabled: _isEnabled,
                controller: _dateFormField,
                focusNode: _dateOfServiceFocusNode,
                readOnly: true,
                maxLines: 1,
                autocorrect: false,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                decoration: InputDecoration(
                  labelText: 'Date of Service',
                  icon: const Icon(Icons.calendar_today),
                  labelStyle: TextStyle(
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                  errorText: _record.dateOfService == null ? _required : null,
                ),
                onTap: () async {
                  final currentDate = DateTime.now();
                  DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: DateTime(1900),
                    lastDate: currentDate,
                  );
                  if (picked != null) {
                    _record.dateOfService = picked;
                    _dateFormField.text = _formattedDate.format(picked);
                  }
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
              ),
              TextFormField(
                enabled: _isEnabled,
                focusNode: _descriptionFocusNode,
                maxLines: 3,
                initialValue: _initValues['description'],
                textInputAction: TextInputAction.go,
                textCapitalization: TextCapitalization.sentences,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _record.description = value,
                onFieldSubmitted: (_) => _submitServiceRecord(),
              ),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
