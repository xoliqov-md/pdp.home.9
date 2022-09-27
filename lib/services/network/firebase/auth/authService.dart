import 'package:database/services/local/shared/auth/auth_service.dart';
import 'package:database/ui/auth/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(
      BuildContext context, String name, String email, String password) async {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = authResult.user;
      return firebaseUser;
  }

  static Future<User?> signInUser( BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword (email: email, password: password);
      final User? firebaseUser = _auth.currentUser;
      print(firebaseUser.toString());
      return firebaseUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static void signOutUser(BuildContext context){
    _auth.signOut();
    Prefs.removeUserId();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignInUI()));
  }
}