// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../controller/auth_controller.dart';
import '../../theme.dart';
import '../customer_side/customer_home_page.dart';
import '../deigner_side/designer_home_page.dart';
import 'sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final authController = Get.put(AuthController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isSecure = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
                  children: [
                    SizedBox(height: 40),
                    FadeInDown(
                        delay: Duration(milliseconds: 600),
                        child: Image.asset("assets/img/logo.png",
                            width: 100, height: 100)),
                    SizedBox(height: 50),
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: Text(
                        "WELCOME AGAIN!",
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
                                "Email",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              CustomTextForm(
                                prefixIcon: Icon(Icons.mail),
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
                    FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 220),
                        child: TextButton(
                          //this method to change the password
                          onPressed: () async {
                            try {
                              if (mailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Please enter your email first")));
                              } else {
                                //this for sending an link to the email that the user forget its password
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: mailController.text);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "A link has been send to your email")));
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Text(
                            "Forget password?",
                            style: TextStyle(fontSize: 12, color: TColor.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    authController.logInLoading.value
                        ? CircularProgressIndicator(color: TColor.primary)
                        : FadeInDown(
                            delay: Duration(milliseconds: 800),
                            child: PrimaryButton(
                              title: "Log In",
                              //this method to perform the login operation
                              onTap: () async {
                                if (formState.currentState!.validate()) {
                                  //here we checked if the textfields have a value
                                  //if it does it will excute this block
                                  //here we will add the login method
                                  authController.logIn(mailController.text,
                                      passController.text, context);
                                } else {
                                  //if it don't have a value it will perform this block
                                  print("error");
                                }
                              },
                            ),
                          ),
                    FadeInDown(
                      delay: Duration(milliseconds: 900),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: TColor.white)),
                          TextButton(
                              onPressed: () {
                                //will navigate you to the login page
                                Get.to(SignUp());
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(color: TColor.white),
                              ))
                        ],
                      ),
                    ),
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
