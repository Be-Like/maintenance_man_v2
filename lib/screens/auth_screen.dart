import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  var _isSignup = false;
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  String _email;
  final _passwordFocusNode = FocusNode();
  String _password;
  final _confirmFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitAuthForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    try {
      if (_isSignup) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print('Logging in: $userCredential');
      }
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
                  onEditingComplete: () => FocusScope.of(context).requestFocus(
                    _confirmFocusNode,
                  ),
                  onSaved: (value) => _password = value,
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
