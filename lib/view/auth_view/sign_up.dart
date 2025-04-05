// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, unused_local_variable, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../common_widget/primary_button.dart';
import '../../controller/auth_controller.dart';
import '../../theme.dart';

import 'log_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<String> accountType = ["Customer", "Designer"];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
  bool isSecure = false;
  final authController = Get.put(AuthController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/img/bg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    FadeInDown(
                        delay: Duration(milliseconds: 500),
                        child: Image.asset("assets/img/logo.png")),
                    SizedBox(height: 40),
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: Text(
                        "WELCOME TO FASHION WORLD! \n COME AND JOIN WITH US",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Form(
                        key: formState,
                        child: FadeInDown(
                          delay: Duration(milliseconds: 700),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "First Name",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              CustomTextForm(
                                prefixIcon: Icon(Icons.person_2_outlined),
                                secure: false,
                                hinttext: "Enter your first name",
                                mycontroller: fnameController,
                                validator: (val) {
                                  if (val == "") {
                                    return "Can't be empty";
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Last Name",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              CustomTextForm(
                                prefixIcon: Icon(Icons.person_2_outlined),
                                secure: false,
                                hinttext: "Enter your last name",
                                mycontroller: lnameController,
                                validator: (val) {
                                  if (val == "") {
                                    return "Can't be empty";
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              Text(
                                "E-mail",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              CustomTextForm(
                                prefixIcon: Icon(Icons.mail_outlined),
                                secure: false,
                                hinttext: "Enter your e-mail",
                                mycontroller: mailController,
                                validator: (val) {
                                  if (val == "") {
                                    return "Can't be empty";
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              CustomTextForm(
                                prefixIcon: Icon(Icons.phone_iphone_rounded),
                                secure: false,
                                hinttext: "Enter your number",
                                mycontroller: phoneController,
                                validator: (val) {
                                  if (val == "") {
                                    return "Can't be empty";
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Password",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              CustomTextForm(
                                prefixIcon: Icon(Icons.lock_outline),
                                secure: isSecure,
                                hinttext: "Enter your password",
                                mycontroller: passController,
                                onTap: () {
                                  setState(() {
                                    isSecure = !isSecure;
                                  });
                                },
                                suffixIcon: isSecure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                validator: (val) {
                                  if (val == "") {
                                    return "Can't be empty";
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Account Type",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                    color: TColor.white,
                                    borderRadius: BorderRadius.circular(25)),
                                width: width / 0.5,
                                child: DropdownButton<String>(
                                  hint: Obx(() => authController
                                          .accountType.value.isEmpty
                                      ? Text(
                                          " Choose your Account Type",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: TColor.black
                                                  .withOpacity(0.5)),
                                        )
                                      : Text(authController.accountType.value,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: TColor.black))),
                                  items: accountType.map((String service) {
                                    return DropdownMenuItem<String>(
                                      value: service,
                                      child: Row(
                                        children: [
                                          Text(
                                            service,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: TColor.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  iconSize: 30,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  underline: Text(
                                    "",
                                    style: TextStyle(color: TColor.white),
                                  ),
                                  onChanged: (String? val) {
                                    if (val != null) {
                                      authController.accountType.value = val;

                                      print(authController.accountType.value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    authController.signUpLoading.value
                        ? CircularProgressIndicator(color: TColor.primary)
                        : FadeInDown(
                            delay: Duration(milliseconds: 800),
                            child: PrimaryButton(
                              title: "Sign Up",
                              onTap: () async {
                                if (formState.currentState!.validate()) {
                                  print(mailController.text);
                                  print(fnameController.text);
                                  print(phoneController.text);
                                  print(passController.text);
                                  print(authController.accountType.value);
                                  authController.signUp(
                                      mailController.text,
                                      passController.text,
                                      authController.accountType.value,
                                      phoneController.text,
                                      fnameController.text,
                                      context);

                                  // try {
                                  //   print("===========1");
                                  //   final credential = await FirebaseAuth.instance
                                  //       .createUserWithEmailAndPassword(
                                  //     email: mailController.text,
                                  //     password: passController.text,
                                  //   );
                                  //   print("===========2");
                                  //   FirebaseAuth.instance.currentUser!
                                  //       .sendEmailVerification();
                                  //   print("===========3");
                                  //   print(credential.user!.uid);
                                  //   print(
                                  //       "===================================${firebaseMessaging.getToken()}");
                                  //   firestore
                                  //       .collection("users")
                                  //       .doc(credential.user!.uid)
                                  //       .set({
                                  //     'uid': credential.user!.uid,
                                  //     'email': credential.user!.email,
                                  //     'name': fnameController.text,
                                  //     'role': authController.accountType.value,
                                  //     'phoneNumber': phoneController.text,
                                  //     'createdAt': FieldValue.serverTimestamp(),
                                  //     'token': firebaseMessaging.getToken(),
                                  //   });
                                  //   print("done after added");
                                  //   Get.to(LogIn());
                                  // } on FirebaseAuthException catch (e) {
                                  //   if (e.code == 'weak-password') {
                                  //     print('The password provided is too weak.');
                                  //     ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(
                                  //           content: Text(
                                  //               'The password provided is too weak')),
                                  //     );
                                  //   } else if (e.code == 'email-already-in-use') {
                                  //     print(
                                  //         'The account already exists for that email.');
                                  //     ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(
                                  //           content: Text(
                                  //               'The account already exists for that email.')),
                                  //     );
                                  //   }
                                  // } catch (e) {
                                  //   print(e);
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(content: Text(e.toString())),
                                  //   );

                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(content: Text(e.toString())),
                                  //   );
                                  // }
                                } else {
                                  print("noooo");
                                }
                              },
                            ),
                          ),
                    FadeInDown(
                      delay: Duration(milliseconds: 900),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: TColor.white)),
                          TextButton(
                              onPressed: () {
                                //will navigate you to the login page
                                Get.to(LogIn());
                              },
                              child: Text(
                                "Log In",
                                style: TextStyle(color: TColor.white),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
