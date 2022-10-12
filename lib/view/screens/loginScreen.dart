import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/service/auth_service.dart';
import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:firebase_init/view/screens/homeScreen.dart';
import 'package:firebase_init/view/widgets/cupertinoTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Log in".toUpperCase(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              kHeight20,
              CustomTextField(
                colors: Colors.teal.withOpacity(.5),
                name: "Email",
                controller: emailController,
                pIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                colors: Colors.teal.withOpacity(.5),
                name: "Password",
                controller: passwordController,
                pIcon: Icons.lock,
                sIcon: passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onTap: () {
                  setState(
                    () {
                      passwordVisible = !passwordVisible;
                    },
                  );
                },
                obscureText: !passwordVisible,
                keyboardType: TextInputType.text,
              ),
              kHeight10,
              MaterialButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("All fields are required"),
                        backgroundColor: kRed,
                      ),
                    );
                  } else {
                    User? response = await AuthService().loginUser(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
                    if (response != null) {
                      print("Sucess");
                      print(response.email);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(response),
                        ),
                        (route) => false,
                      );
                    }
                  }
                  setState(() {
                    loading = false;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.teal,
                height: 40,
                minWidth: size.width,
                child: loading
                    ? const CupertinoActivityIndicator(color: kWhite)
                    : const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
