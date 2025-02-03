// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(
            delay: Duration(milliseconds: 400),
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: TColor.white,
                  size: 40,
                )),
          ),
          FadeInRight(
              delay: Duration(milliseconds: 400),
              child: Image.asset("assets/img/logo.png")),
        ],
      ),
    );
  }
}
