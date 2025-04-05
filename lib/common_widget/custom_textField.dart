// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final void Function()? onTap;
  IconData? suffixIcon;
  Color? color;
  Widget? prefixIcon;
  void Function(String)? onChanged;
  final bool secure;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  FocusNode? focusNode;

  CustomTextForm({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.color,
    required this.secure,
    this.onTap,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: mycontroller,
      obscureText: secure,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hinttext,
        suffixIcon: InkWell(
            onTap: onTap,
            child: Icon(
              suffixIcon,
              color: color,
            )),
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide(
              color: Color.fromARGB(31, 179, 206, 231),
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            color: Color.fromARGB(31, 179, 206, 231),
          ),
        ),
      ),
    );
  }
}
