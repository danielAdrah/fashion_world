// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/primary_button.dart';
import '../../theme.dart';
import 'update_personal_info.dart';

class CustomerProfileView extends StatefulWidget {
  const CustomerProfileView({super.key});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
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
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 212, 210, 210),
                      radius: 70,
                      child: Icon(
                        Icons.person_2_outlined,
                        size: 55,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Personal Information :",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Divider(color: TColor.white, endIndent: 110),
                    SizedBox(height: 40),
                    InfoTile(
                      onTap: () {},
                      name: "Full Name:",
                      value: "Daniel Adrah",
                    ),
                    SizedBox(height: 20),
                    InfoTile(
                      onTap: () {},
                      name: "E-mail:",
                      value: "www.dado@gmail.com",
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: PrimaryButton(
                        title: "Change",
                        onTap: () {
                          Get.to(UpdatePersonalInfo());
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Other Options :",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Divider(color: TColor.white, endIndent: 180),
                    SizedBox(height: 30),
                    InfoTile2(
                      onTap: () {},
                      name: "Log Out",
                      value: "",
                      icon: Icons.logout,
                    ),
                    SizedBox(height: 20),
                    InfoTile2(
                      onTap: () {},
                      name: "Delete Account",
                      value: "",
                      icon: Icons.delete,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Divider(color: TColor.white, endIndent: 25, indent: 25),
            ],
          ),
        ),
      ),
    );
  }
}

//=======to display user info
class InfoTile extends StatelessWidget {
  InfoTile({
    super.key,
    required this.name,
    required this.value,
    required this.onTap,
    this.icon,
  });
  final String name;
  final String value;
  void Function()? onTap;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              color: TColor.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//=======
class InfoTile2 extends StatelessWidget {
  InfoTile2({
    super.key,
    required this.name,
    required this.value,
    required this.onTap,
    this.icon,
  });
  final String name;
  final String value;
  void Function()? onTap;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Row(
            children: [
              Icon(icon, color: TColor.white, size: 30),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
