import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.name,
    required this.controller,
    required this.pIcon,
    required this.colors,
    this.sIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
  }) : super(key: key);

  final String name;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData pIcon;
  final Color colors;
  final IconData? sIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CupertinoTextField(
        controller: controller,
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(5),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        obscureText: obscureText,
        obscuringCharacter: "*",
        placeholder: name,
        placeholderStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        prefix: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(pIcon, color: Colors.black.withOpacity(.5)),
        ),
        suffix: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: onTap,
            child: Icon(sIcon, color: Colors.black.withOpacity(.5))),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
