import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/service/auth_service.dart';
import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:firebase_init/view/screens/homeScreen.dart';
import 'package:firebase_init/view/screens/loginScreen.dart';
import 'package:firebase_init/view/widgets/cupertinoTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool loading = false;
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orangeAccent[100],
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "register here".toUpperCase(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              kHeight20,

              //<<<<<Fields>>>>>//
              CustomTextField(
                colors: Colors.orangeAccent.withOpacity(.8),
                name: "Email",
                controller: emailController,
                pIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                colors: Colors.orangeAccent.withOpacity(.8),
                name: "Password",
                controller: passwordController,
                pIcon: Icons.lock,
                sIcon: passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onTap: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                obscureText: !passwordVisible,
                keyboardType: TextInputType.text,
              ),
              CustomTextField(
                colors: Colors.orangeAccent.withOpacity(.8),
                name: "Confirm Password",
                controller: confirmPasswordController,
                pIcon: Icons.lock,
                sIcon: passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onTap: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                keyboardType: TextInputType.text,
                obscureText: !passwordVisible,
              ),
              kHeight10,

              //<<<<<Button>>>>>//
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
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Passwords doesn't match!"),
                        backgroundColor: kRed,
                      ),
                    );
                  } else {
                    User? response = await AuthService().registerUser(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
                    if (response != null) {
                      print("Success");
                      print(response.email);

                      //To_Login to homescreen if it's signed in//
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen(response);
                        },
                      ), (route) => false);
                    }
                  }
                  setState(() {
                    loading = false;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.orange,
                height: 40,
                minWidth: size.width,
                child: loading
                    ? const CupertinoActivityIndicator(color: kGreen)
                    : const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              kHeight20,

              //<<<<<TextButton>>>>>//
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text("Already have an account? Login here..."),
              ),

              kHeight20,
              const Divider(thickness: 2),
              kHeight20,

              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await AuthService().googleSignIn();
                  setState(() {
                    loading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
