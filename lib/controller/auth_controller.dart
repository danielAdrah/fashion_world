// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../view/auth_view/log_in.dart';
import '../view/customer_side/customer_home_page.dart';
import '../view/deigner_side/designer_home_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
  RxString accountType = "".obs;
  RxBool logInLoading = false.obs;
  RxBool signUpLoading = false.obs;

  //=======

//======THIS METHOD FOR SIGNING UP
  Future signUp(String mail, passWord, accountType, phoneNumber, name,
      BuildContext context) async {
    try {
      print("=====1");
      String? deviceToken = await firebaseMessaging.getToken();
      print("================$deviceToken");
      signUpLoading.value = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: passWord,
      );
      print("=====2");

      //after the user creates an account a link is send to it
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      print("=====3");
      print("===================before add");
      // await addUserToFirestore(credential.user!, accountType, name);
      firestore.collection("users").doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': credential.user!.email,
        'name': name,
        'role': accountType,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'token': deviceToken,
      });
      print("done after added");
      Get.to(LogIn());
      signUpLoading.value = false;
    } on FirebaseAuthException catch (e) {
      signUpLoading.value = false;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

//=======THIS METHOD IS FOR LOGIN
  Future logIn(String mail, passWord, BuildContext context) async {
    try {
      print("=====1");
      logInLoading.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail,
        password: passWord,
      );
      print("=====2");
      logInLoading.value = false;

      if (credential.user!.emailVerified) {
        //here we check if the user has verified his account
        //if he so we will take hin to the home page
        //if he is not we will tell him to do it
        print("=====3");
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();
        print("=====4");
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String? role = userData['role'];
          print("=================$role");
          if (role == "Customer") {
            Get.off(CustomerHomePage());
          } else if (role == "Designer") {
            Get.off(DesignerHomePage());
          } else {
            print("=======================no role");
          }
        }
      } else {
        logInLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Verify your account first!')),
        );
        print("please verfiy first");
      }
    } on FirebaseAuthException catch (e) {
      logInLoading.value = false;
      print("not done");
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('user-not-found')),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided for that user.')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect User credentials")),
      );
    }
  }
}
