import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:maintenance_man_v2/providers/properties.dart';
import 'package:maintenance_man_v2/providers/service_records.dart';
import 'package:maintenance_man_v2/providers/vehicles.dart';

class Auth with ChangeNotifier {
  UserCredential _userCredential;

  bool get isAuth {
    return FirebaseAuth.instance.currentUser != null;
  }

  UserCredential get userCredential {
    return _userCredential;
  }

  Future<void> authenticate(
    String email,
    String password, [
    isSignup = false,
  ]) async {
    if (isSignup) {
      _userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    notifyListeners();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Properties().clearData();
    Vehicles().clearData();
    ServiceRecords().clearData();
    notifyListeners();
  }
}
