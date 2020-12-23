import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_man_v2/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  var _isSignup = false;
  final _form = GlobalKey<FormState>();
  FocusNode _emailFocusNode;
  String _email;
  FocusNode _passwordFocusNode;
  String _password;
  FocusNode _confirmFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitAuthForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    try {
      Provider.of<Auth>(context, listen: false).authenticate(
        _email,
        _password,
        _isSignup,
      );
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (err.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  focusNode: _emailFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'maintenanceMan@example.com',
                  ),
                  onEditingComplete: () => FocusScope.of(context).requestFocus(
                    _passwordFocusNode,
                  ),
                  onSaved: (value) => _email = value,
                ),
                TextFormField(
                  focusNode: _passwordFocusNode,
                  textInputAction:
                      _isSignup ? TextInputAction.next : TextInputAction.go,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: _isSignup
                        ? null
                        : IconButton(
                            icon: Icon(Icons.login),
                            onPressed: _submitAuthForm,
                          ),
                  ),
                  onEditingComplete: () {
                    _isSignup
                        ? FocusScope.of(context).unfocus()
                        : FocusScope.of(context).requestFocus(
                            _confirmFocusNode,
                          );
                  },
                  onChanged: (value) => _password = value,
                  onFieldSubmitted: (_) => _isSignup ? null : _submitAuthForm(),
                ),
                if (_isSignup)
                  TextFormField(
                    focusNode: _confirmFocusNode,
                    textInputAction: TextInputAction.go,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.login),
                        onPressed: _submitAuthForm,
                      ),
                    ),
                    validator: (value) {
                      print('$value == $_password');
                      if (value != _password) return 'Passwords do not match';
                      return null;
                    },
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    onFieldSubmitted: (_) => _submitAuthForm(),
                  ),
                SizedBox(height: 20),
                GestureDetector(
                  child: Text(_isSignup
                      ? 'Have an account? Sign in'
                      : 'Don\'t have an account? Sign up'),
                  onTap: () {
                    setState(() {
                      _isSignup = !_isSignup;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
