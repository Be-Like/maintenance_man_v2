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
  String _confirmPassword;

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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print('Credentials: $userCredential');
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
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    onSaved: (value) => _confirmPassword = value,
                    onFieldSubmitted: (_) => _submitAuthForm(),
                  ),
                SizedBox(height: 20),
                TextButton(
                  child: Text(_isSignup
                      ? 'Sign in with email'
                      : 'Don\'t have an account? Sign up'),
                  onPressed: () {
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
