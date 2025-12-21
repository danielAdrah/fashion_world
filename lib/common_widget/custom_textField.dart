// ignore_for_file: prefer_const_constructors, must_be_immutables

import 'package:flutter/material.dart';
import '../theme.dart';

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
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.0),
          child: prefixIcon,
        ),
        hintText: hinttext,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onTap,
                icon: Icon(
                  suffixIcon,
                  color: TColor.white.withOpacity(0.7),
                ),
              )
            : null,
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.white.withOpacity(0.7),
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: TColor.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.redAccent.withOpacity(0.7),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
