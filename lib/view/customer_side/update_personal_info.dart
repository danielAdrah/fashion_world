// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class UpdatePersonalInfo extends StatefulWidget {
  const UpdatePersonalInfo({super.key});

  @override
  State<UpdatePersonalInfo> createState() => _UpdatePersonalInfoState();
}

class _UpdatePersonalInfoState extends State<UpdatePersonalInfo> {
  final storeController = Get.put(StoreController());

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  clearFields() {
    nameController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  TColor.background.withOpacity(0.9),
                  TColor.primary.withOpacity(0.6),
                ],
              ),
              image: DecorationImage(
                image: const AssetImage("assets/img/bg.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const CustomAppBar(),
                  const SizedBox(height: 30),
                  // Header section
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
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
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: TColor.white,
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: TColor.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Update Profile",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Edit your personal information",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Form section
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
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
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Full Name",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextForm(
                            secure: false,
                            hinttext: "Enter your full name",
                            mycontroller: nameController,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: TColor.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextForm(
                            secure: false,
                            hinttext: "Enter your phone number",
                            mycontroller: phoneController,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: TColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Action buttons
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ProfileBtn(
                              title: "Save Changes",
                              onTap: () {
                                if (nameController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty) {
                                  storeController.updateUserInfo(
                                      context,
                                      nameController.text,
                                      phoneController.text);
                                  clearFields();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("All fields are required"),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ProfileBtn(
                              title: "Cancel",
                              onTap: () {
                                clearFields();
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//============
class ProfileBtn extends StatelessWidget {
  final void Function() onTap;
  final String title;
  const ProfileBtn({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColor.primary.withOpacity(0.9),
              TColor.primary.withOpacity(0.7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: TColor.primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
