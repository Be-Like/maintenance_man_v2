import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';

class Auth with ChangeNotifier {
  User _userCredential;

  bool get isAuth {
    return FirebaseAuth.instance.currentUser != null;
  }

  User get userCredential {
    return _userCredential;
  }

  Future<void> authenticate(
    String email,
    String password, [
    isSignup = false,
  ]) async {
    if (isSignup) {
      final _signup =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userCredential = _signup.user;
    } else {
      final _signIn = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userCredential = _signIn.user;
    }
    print('Signing in user: $_userCredential');
    notifyListeners();
  }

  void signOut() {
    print('Signing out user: $_userCredential');
    FirebaseAuth.instance.signOut();
    Properties().clearData();
    Vehicles().clearData();
    ServiceRecords().clearData();
    notifyListeners();
  }
}
