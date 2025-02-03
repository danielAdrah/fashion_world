// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/auth_view/sign_up.dart';
import 'view/customer_side/customer_profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
      routes: {
        "profile": (context) => CustomerProfileView(),
        
      },
    );
  }
}
