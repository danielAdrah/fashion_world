// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fashion_world/common_widget/custom_textField.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';

import '../../common_widget/custom_appBar.dart';
import '../../theme.dart';

class PublishNews extends StatefulWidget {
  const PublishNews({super.key});

  @override
  State<PublishNews> createState() => _PublishNewsState();
}

class _PublishNewsState extends State<PublishNews> {
  final price = TextEditingController();
  final fabric = TextEditingController();
  final color = TextEditingController();
  final size = TextEditingController();
  clearFields() {
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              CustomAppBar(),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextForm(
                        hinttext: " Design Price",
                        mycontroller: price,
                        secure: false),
                    SizedBox(height: 40),
                    CustomTextForm(
                        hinttext: "Design Fabric",
                        mycontroller: fabric,
                        secure: false),
                    SizedBox(height: 40),
                    CustomTextForm(
                        hinttext: "Design Color",
                        mycontroller: color,
                        secure: false),
                    SizedBox(height: 40),
                    CustomTextForm(
                        hinttext: "Design Size",
                        mycontroller: size,
                        secure: false),
                    SizedBox(height: 40),
                    TextButton(
                      child: Text(
                        "Select Image",
                        style: TextStyle(color: TColor.white, fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              PrimaryButton(
                  title: "Publish",
                  onTap: () {
                 
                    clearFields();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
