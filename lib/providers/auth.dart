import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
    notifyListeners();
  }
}
