// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

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

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  List<String> accountType = ["Customer", "Designer"];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
  bool isSecure = true;
  final authController = Get.put(AuthController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

            // Content that scrolls when keyboard appears
            SingleChildScrollView(
              physics:
                  const ClampingScrollPhysics(), // Prevents overscroll glow
              padding: EdgeInsets.only(
                top: height * 0.05,
                bottom: 20, // Add some padding at the bottom
              ),
              child: Center(
                child: Obx(
                  () => FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with floating animation
                        ElasticIn(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            padding: const EdgeInsets.all(20),
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
                        SizedBox(height: height * 0.03),
                        // Welcome text with slide animation
                        SlideInUp(
                          delay: const Duration(milliseconds: 300),
                          child: Text(
                            "Create Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SlideInUp(
                          delay: const Duration(milliseconds: 400),
                          child: Text(
                            "Join our fashion community today",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        // Glassmorphism container for form
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: Container(
                            width: width * 0.85,
                            padding: const EdgeInsets.all(25),
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
                                  offset: const Offset(0, 5),
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
                                    "First Name",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextForm(
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: TColor.primary,
                                    ),
                                    secure: false,
                                    hinttext: "Enter your first name",
                                    mycontroller: fnameController,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "First name can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Last Name",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextForm(
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: TColor.primary,
                                    ),
                                    secure: false,
                                    hinttext: "Enter your last name",
                                    mycontroller: lnameController,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Last name can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                                  const SizedBox(height: 20),
                                  Text(
                                    "Phone Number",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextForm(
                                    prefixIcon: Icon(
                                      Icons.phone_outlined,
                                      color: TColor.primary,
                                    ),
                                    secure: false,
                                    hinttext: "Enter your phone number",
                                    mycontroller: phoneController,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Phone number can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                                  const SizedBox(height: 20),
                                  Text(
                                    "Account Type",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      dropdownColor:
                                          TColor.background.withOpacity(0.9),
                                      hint: Obx(() => authController
                                              .accountType.value.isEmpty
                                          ? Text(
                                              "Select account type",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              ),
                                            )
                                          : Text(
                                              authController.accountType.value,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: TColor.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                      items: accountType.map((String service) {
                                        return DropdownMenuItem<String>(
                                          value: service,
                                          child: Text(
                                            service,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: TColor.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: TColor.white,
                                      ),
                                      iconSize: 30,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      onChanged: (String? val) {
                                        if (val != null) {
                                          authController.accountType.value =
                                              val;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        // Signup button with loading indicator
                        authController.signUpLoading.value
                            ? FadeIn(
                                duration: const Duration(milliseconds: 300),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    TColor.primary,
                                  ),
                                ),
                              )
                            : FadeInUp(
                                delay: const Duration(milliseconds: 700),
                                child: PrimaryButton(
                                  title: "Create Account",
                                  onTap: () async {
                                    if (formState.currentState!.validate()) {
                                      if (authController
                                          .accountType.value.isEmpty) {
                                        Get.snackbar(
                                          "Error",
                                          "Please select an account type",
                                          backgroundColor: Colors.redAccent,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

                                      FocusScope.of(context).unfocus();
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');

                                      authController.signUp(
                                        mailController.text,
                                        passController.text,
                                        authController.accountType.value,
                                        phoneController.text,
                                        "${fnameController.text} ${lnameController.text}",
                                        context,
                                      );
                                    }
                                  },
                                ),
                              ),
                        SizedBox(height: height * 0.02),
                        // Login option
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: TColor.white.withOpacity(0.9),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(const LogIn());
                                },
                                child: Text(
                                  "Sign In",
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
                        SizedBox(height: height * 0.03),
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
