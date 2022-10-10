import 'package:firebase_init/service/auth_service.dart';
import 'package:firebase_init/view/screens/registerScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[100],
          elevation: 0,
          title: Text("Home Page".toUpperCase()),
          centerTitle: true,
          actions: [
            //
            //<<<<<SignOut>>>>>//
            IconButton(
              onPressed: () async {
                await AuthService().firebaseAuth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
