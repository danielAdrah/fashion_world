// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, unused_local_variable, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../common_widget/primary_button.dart';
import '../../theme.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isSecure = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
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
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  child: PrimaryButton(
                    title: "Sign Up",
                    onTap: () {
                      Get.to(LogIn());
                      if (formState.currentState!.validate()) {
                        print("yess");
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
    );
  }
}
