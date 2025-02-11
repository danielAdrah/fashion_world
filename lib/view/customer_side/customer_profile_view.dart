// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../theme.dart';
import '../auth_view/log_in.dart';
import 'update_personal_info.dart';

class CustomerProfileView extends StatefulWidget {
  const CustomerProfileView({super.key});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;
  String? userEmail;
  String? userPhonenumber;

  Future<void> fetchUserData() async {
    final user = auth.currentUser;
    if (user != null) {
      final docSnap = await firestore.collection('users').doc(user.uid).get();
      if (docSnap.exists) {
        setState(() {
          userName = docSnap.get('name');
          userEmail = docSnap.get('email');
          userPhonenumber = docSnap.get('phoneNumber');
        });
      }
    }
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
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
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 212, 210, 210),
                        radius: 70,
                        child: Icon(
                          Icons.person_2_outlined,
                          size: 55,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Personal Information :",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            child: Text(
                              "Change",
                              style: TextStyle(color: TColor.white),
                            ),
                            onPressed: () {
                              Get.to(UpdatePersonalInfo());
                            },
                          ),
                        ],
                      ),
                    ),
                    FadeInDown(
                        delay: Duration(milliseconds: 700),
                        child: Divider(color: TColor.white, endIndent: 110)),
                    SizedBox(height: 20),
                    FadeInDown(
                      delay: Duration(milliseconds: 800),
                      child: Column(
                        children: [
                          InfoTile(
                            onTap: () {},
                            name: "Full Name:",
                            value: userName ?? "wait ...",
                          ),
                          SizedBox(height: 20),
                          InfoTile(
                            onTap: () {},
                            name: "E-mail:",
                            value: userEmail ?? "wait ...",
                          ),
                          SizedBox(height: 20),
                          InfoTile(
                            onTap: () {},
                            name: "Phine Number:",
                            value: userPhonenumber ?? "wait ...",
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                    FadeInDown(
                      delay: Duration(milliseconds: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.off(LogIn());
                            },
                            name: "Log Out",
                            value: "",
                            icon: Icons.logout,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
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
                fontWeight: FontWeight.w400,
                fontSize: 17,
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
