// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

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

class _LogInState extends State<LogIn> with TickerProviderStateMixin {
  final authController = Get.put(AuthController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isSecure = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      resizeToAvoidBottomInset:
          false, // This prevents the layout from resizing when keyboard appears
      body: SafeArea(
        child: Stack(
          children: [
            // Background image that doesn't resize with keyboard
            Positioned.fill(
              child: Image.asset(
                "assets/img/bg.png",
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.2),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            // Gradient overlay
            // Positioned.fill(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           TColor.background.withOpacity(0.9),
            //           TColor.primary.withOpacity(0.6),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Content that scrolls when keyboard appears
            SingleChildScrollView(
              physics: ClampingScrollPhysics(), // Prevents overscroll glow
              padding: EdgeInsets.only(
                top: height * 0.1,
                bottom: 20, // Add some padding at the bottom
              ),
              child: Center(
                child: Obx(
                  () => FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo with floating animation
                        ElasticIn(
                          duration: Duration(milliseconds: 1200),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              "assets/img/logo.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        // Welcome text with slide animation
                        SlideInUp(
                          delay: Duration(milliseconds: 300),
                          child: Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SlideInUp(
                          delay: Duration(milliseconds: 400),
                          child: Text(
                            "Sign in to continue your journey",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        // Glassmorphism container for form
                        FadeInUp(
                          delay: Duration(milliseconds: 500),
                          child: Container(
                            width: width * 0.85,
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Form(
                              key: formState,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextForm(
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: TColor.primary,
                                    ),
                                    secure: false,
                                    hinttext: "Enter your email",
                                    mycontroller: mailController,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Email can't be empty";
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(val)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextForm(
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: TColor.primary,
                                    ),
                                    secure: isSecure,
                                    hinttext: "Enter your password",
                                    mycontroller: passController,
                                    onTap: () {
                                      setState(() {
                                        isSecure = !isSecure;
                                      });
                                    },
                                    suffixIcon: isSecure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Password can't be empty";
                                      }
                                      if (val.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  // Forgot password aligned to the right
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () async {
                                        try {
                                          if (mailController.text.isEmpty) {
                                            Get.snackbar(
                                              "Error",
                                              "Please enter your email first",
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email: mailController.text);
                                            Get.snackbar(
                                              "Success",
                                              "Password reset link sent to your email",
                                              backgroundColor: TColor.primary,
                                              colorText: Colors.white,
                                            );
                                          }
                                        } catch (e) {
                                          Get.snackbar(
                                            "Error",
                                            e.toString(),
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: TColor.white,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        // Login button with loading indicator
                        authController.logInLoading.value
                            ? FadeIn(
                                duration: Duration(milliseconds: 300),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    TColor.primary,
                                  ),
                                ),
                              )
                            : FadeInUp(
                                delay: Duration(milliseconds: 700),
                                child: PrimaryButton(
                                  title: "Sign In",
                                  onTap: () async {
                                    if (formState.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      authController.logIn(mailController.text,
                                          passController.text, context);
                                    }
                                  },
                                ),
                              ),
                        SizedBox(height: height * 0.03),
                        // Sign up option
                        FadeInUp(
                          delay: Duration(milliseconds: 800),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: TColor.white.withOpacity(0.9),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(SignUp());
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
