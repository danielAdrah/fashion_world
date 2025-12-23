// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'view/auth_view/auth_gate.dart';
import 'view/customer_side/customer_profile_view.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService();
  await notificationService.initNotifications();
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'dvz3way0c');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: {
        "profile": (context) => CustomerProfileView(),
      },
    );
  }
}
