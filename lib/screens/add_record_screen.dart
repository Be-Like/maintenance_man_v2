import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
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

  static const _required = 'This field is required';
  final _form = GlobalKey<FormState>();
  final _recordNameFocusNode = FocusNode();
  final _dateFormField = TextEditingController();
  final _formattedDate = DateFormat.yMd();
  final _dateOfServiceFocusNode = FocusNode();
  final _costFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();

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
    _costFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _submitServiceRecord() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    if (widget.recordId != null) {
      try {
        await Provider.of<ServiceRecords>(context, listen: false)
            .updateRecord(_record);
        Navigator.of(context).pop('${_record.name} updated');
      } catch (err) {
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
            .addRecord(_record);
        Navigator.of(context).pop('${_record.name} successfully added');
      } catch (err) {
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
                      .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
                ),
                onPressed: () => _submitServiceRecord(),
              ),
            ],
          ),
        ),
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
              TextFormField(
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
                controller: _dateFormField,
                focusNode: _dateOfServiceFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                autocorrect: false,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                decoration: InputDecoration(
                  labelText: 'Date of Service',
                  icon: const Icon(Icons.calendar_today),
                  labelStyle:
                      TextStyle(decorationStyle: TextDecorationStyle.solid),
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
                // validator: (value) => value.isEmpty ? _required : null,
                // onSaved: (value) => _record.dateOfService = DateTime.now(),
              ),
              TextFormField(
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
            ],
          ),
        ),
      ),
    );
  }
}
