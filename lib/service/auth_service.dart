import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //<<<<<Register_User>>>>>//
  Future<User?> registerUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully registered!"),
          backgroundColor: kGreen,
        ),
      );
      return userCredential.user;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: kRed,
        ),
      );
    } catch (e) {
      print(e);
    }
    return null;
  }

  //<<<<<Login_User>>>>>//
  Future<User?> loginUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Succesfully Logged in!"),
          backgroundColor: kGreen,
        ),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
        ),
      );
    } catch (e) {
      print(e);
    }
    return null;
  }
}
