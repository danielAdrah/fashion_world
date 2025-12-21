// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../theme.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TColor.primary.withOpacity(0.9),
                TColor.primary.withOpacity(0.7),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
