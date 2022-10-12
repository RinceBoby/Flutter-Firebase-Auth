import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_init/service/auth_service.dart';
import 'package:firebase_init/view/screens/homeScreen.dart';
import 'package:firebase_init/view/screens/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData(
        // brightness: Brightness.dark,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),

      //<<<<<Wrap with stream builder to get into homescreen while you are logged in>>>>>//
      home: StreamBuilder(
        stream: AuthService().firebaseAuth.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(snapshot.data);
          }
          return RegisterScreen();
        },
      ),
    );
  }
}
