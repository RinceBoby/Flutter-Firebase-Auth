import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  //<<<<<Google_Sign_In>>>>>//
  Future<User?> googleSignIn() async {
    try {
      //Trigger the auth dialog//
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        //
        //Obtain the auth details from the request//
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        //Create a new credentials//
        final googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        //Once signed in return the user data from firebase//
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(googleCredential);
        return userCredential.user;
      }
    } catch (e) {
      print(e);
    }
  }

  //<<<<<Sign_Out>>>>>//
  Future signOut() async {
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
