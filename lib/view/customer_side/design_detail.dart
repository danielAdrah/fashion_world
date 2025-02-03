// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fashion_world/common_widget/custom_textField.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/design_info_tile.dart';
import '../../theme.dart';

class DesginDetail extends StatefulWidget {
  const DesginDetail({super.key});

  @override
  State<DesginDetail> createState() => _DesginDetailState();
}

class _DesginDetailState extends State<DesginDetail> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomAppBar(),
              Text(
                "Details of Design",
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 35),
              CircleAvatar(
                backgroundImage: AssetImage("assets/img/handbage.png"),
                radius: 90,
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DesinInfoTile(
                      name: "Designer ID: ",
                      value: "115463",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Status: ",
                      value: "Available",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Color: ",
                      value: "Red",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Fabric: ",
                      value: "Leather",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Price: ",
                      value: "5000 SR",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Size: ",
                      value: "Big",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Status: ",
                      value: "Available",
                    ),
                    SizedBox(height: 15),
                    DesinInfoTile(
                      name: "Design ID: ",
                      value: "15265",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextForm(
                  hinttext: "Type a comment",
                  mycontroller: commentController,
                  secure: false,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(title: "Order", onTap: () {}),
                  PrimaryButton(
                      title: "Cancel",
                      onTap: () {
                        Get.back();
                      }),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
