// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CustomAppBar(),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 212, 210, 210),
                        radius: 60,
                        child: Icon(
                          Icons.person_2_outlined,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Personal Porfile",
                        style: TextStyle(
                          color: TColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Full Name",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      CustomTextForm(
                        secure: false,
                        hinttext: "Name",
                        mycontroller: nameController,
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
                        secure: false,
                        hinttext: "Phone",
                        mycontroller: phoneController,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              FadeInDown(
                delay: Duration(milliseconds: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileBtn(
                        title: "Apply Changes",
                        onTap: () {
                          if (nameController.text.isNotEmpty &&
                              phoneController.text.isNotEmpty) {
                            storeController.updateUserInfo(context,
                                nameController.text, phoneController.text);
                            clearFields();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Fields can't be empty")),
                            );
                          }
                        }),
                    ProfileBtn(
                        title: "Cancel",
                        onTap: () {
                          Get.back();
                        }),
                  ],
                ),
              ),
            ],
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
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: TColor.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
