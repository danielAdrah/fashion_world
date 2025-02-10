// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_world/view/auth_view/log_in.dart';
import 'package:fashion_world/view/customer_side/customer_home_page.dart';
import 'package:fashion_world/view/deigner_side/designer_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LogIn();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LogIn();
              }

              String? role = snapshot.data!['role'];

              if (role == null) {
                print('User not found or does not have a role');
                return const LogIn();
              }

              switch (role) {
                case 'Customer':
                  return const CustomerHomePage();
                case 'Designer':
                  return const DesignerHomePage();
                default:
                  print('Unknown role: $role');
                  return const LogIn();
              }
            },
          );
        },
      ),
    );
  }
}