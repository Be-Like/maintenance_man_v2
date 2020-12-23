import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/auth.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _isEditing = false;
  var _isUpdatingUserInfo = false;

  User user;
  String displayName;
  String email;
  String password;
  String confirmPassword;

  GlobalKey _form;
  FocusNode _passwordFocusNode;
  FocusNode _confirmFocusNode;
  TextEditingController _passwordController;
  TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    displayName = user.displayName;
    email = user.email;

    _form = GlobalKey<FormState>();
    _passwordFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();

    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  void _setEditingStatus(bool isEditing) {
    if (_isEditing == isEditing) return;
    setState(() {
      _isEditing = isEditing;
    });
  }

  bool get _updatingDisplayName => user.displayName != displayName;

  bool get _updatingEmail => user.email != email;

  bool get _updatingPassword =>
      password != null &&
      confirmPassword != null &&
      password == confirmPassword;

  void _setToEditing() {
    if (_updatingDisplayName || _updatingEmail || _updatingPassword) {
      _setEditingStatus(true);
    } else {
      _setEditingStatus(false);
    }
  }

  Future<bool> _abortChanges() async {
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Abort changes'),
        content: Text(
            'You have begun to make changes to your account. By proceeding, your changes will not be saved. Are you sure you want to proceed?'),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  Future<String> _reauthenticatePrompt() async {
    var response;
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Re-Authenticate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'For security purposes, please re-authenticat using your current password.'),
            TextFormField(
              initialValue: '',
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) => response = value,
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Authenticate'),
            onPressed: () => Navigator.of(context).pop(response),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUser() async {
    String authPassword;
    _setEditingStatus(false);
    try {
      setState(() {
        _isUpdatingUserInfo = true;
      });
      if (_updatingDisplayName) {
        await user.updateProfile(displayName: displayName);
        user = FirebaseAuth.instance.currentUser;
      }
      if (_updatingEmail) {
        authPassword = await _reauthenticatePrompt();
        if (authPassword == null) {
          setState(() {
            _isUpdatingUserInfo = false;
            _setEditingStatus(true);
          });
          return;
        }
        await Provider.of<Auth>(context, listen: false)
            .authenticate(user.email, authPassword);
        await user.updateEmail(email);
        user = FirebaseAuth.instance.currentUser;
      }
      if (_updatingPassword) {
        if (authPassword == null) {
          authPassword = await _reauthenticatePrompt();
        }
        if (authPassword == null) {
          setState(() {
            _isUpdatingUserInfo = false;
            _setEditingStatus(true);
          });
          return;
        }
        await Provider.of<Auth>(context, listen: false)
            .authenticate(user.email, authPassword);
        await user.updatePassword(password);
        user = FirebaseAuth.instance.currentUser;
        password = null;
        confirmPassword = null;
        _passwordController.text = '';
        _confirmController.text = '';
      }
    } catch (err) {
      _setEditingStatus(true);
      print('Error updating user: $err');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Account failed to update'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isUpdatingUserInfo = false;
        _setEditingStatus(true);
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Account successfully updated'),
      backgroundColor: CustomColorTheme.selectionScreenAccent,
    ));
    setState(() {
      _isUpdatingUserInfo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(
              Icons.close,
              color: CustomColorTheme.selectionScreenAccent,
            ),
            onPressed: () async {
              if (!_isEditing) return Navigator.of(context).pop();
              final res = await _abortChanges();
              if (res != null && res) Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: CustomColorTheme.selectionScreenAccent,
          ),
        ),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(
                Icons.check,
                color: CustomColorTheme.selectionScreenAccent,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _updateUser();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Card(
                color: CustomColorTheme.selectionScreenBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: user.displayName ?? '',
                              decoration: InputDecoration(
                                labelText: 'Display Name',
                                labelStyle: TextStyle(
                                  color: CustomColorTheme.selectionScreenAccent,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColorTheme
                                        .selectionScreenAccent
                                        .withOpacity(0.6),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        CustomColorTheme.selectionScreenAccent,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              cursorColor:
                                  CustomColorTheme.selectionScreenAccent,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (value) {
                                if (value == '') value = null;
                                displayName = value;
                                return _setToEditing();
                              },
                            ),
                            TextFormField(
                              initialValue: user.email,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: CustomColorTheme.selectionScreenAccent,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColorTheme
                                        .selectionScreenAccent
                                        .withOpacity(0.6),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        CustomColorTheme.selectionScreenAccent,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              cursorColor:
                                  CustomColorTheme.selectionScreenAccent,
                              onChanged: (value) {
                                email = value;
                                return _setToEditing();
                              },
                            ),
                            TextFormField(
                              focusNode: _passwordFocusNode,
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle: TextStyle(
                                  color: CustomColorTheme.selectionScreenAccent,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColorTheme
                                        .selectionScreenAccent
                                        .withOpacity(0.6),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        CustomColorTheme.selectionScreenAccent,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              cursorColor:
                                  CustomColorTheme.selectionScreenAccent,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_confirmFocusNode),
                              onChanged: (value) {
                                if (value == '') value = null;
                                password = value;
                                return _setToEditing();
                              },
                            ),
                            TextFormField(
                              focusNode: _confirmFocusNode,
                              controller: _confirmController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                labelStyle: TextStyle(
                                  color: CustomColorTheme.selectionScreenAccent,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColorTheme
                                        .selectionScreenAccent
                                        .withOpacity(0.6),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        CustomColorTheme.selectionScreenAccent,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              cursorColor:
                                  CustomColorTheme.selectionScreenAccent,
                              onChanged: (value) {
                                if (value == '') value = null;
                                confirmPassword = value;
                                return _setToEditing();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isUpdatingUserInfo)
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 5,
                        top: 5,
                        end: 5,
                        bottom: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Color(0xFF9E9E9E).withOpacity(0.5),
                          ),
                          padding: EdgeInsets.all(15),
                        ),
                      ),
                    if (_isUpdatingUserInfo)
                      CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
