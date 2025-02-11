// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/custom_textField.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class PublishDesignView extends StatefulWidget {
  const PublishDesignView({super.key});

  @override
  State<PublishDesignView> createState() => _PublishDesignViewState();
}

class _PublishDesignViewState extends State<PublishDesignView> {
  final storeController = Get.put(StoreController());
  final title = TextEditingController();
  final price = TextEditingController();
  final fabric = TextEditingController();
  final color = TextEditingController();
  final size = TextEditingController();
  clearFields() {
    title.clear();
    price.clear();
    fabric.clear();
    color.clear();
    size.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                SizedBox(height: 30),
                CustomAppBar(),
                SizedBox(height: 40),
                FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextForm(
                            hinttext: " Design Title",
                            mycontroller: title,
                            secure: false),
                        SizedBox(height: 40),
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
                ),
                SizedBox(height: 40),
                storeController.addDesignLoading.value
                    ? CircularProgressIndicator(color: TColor.primary)
                    : FadeInDown(
                        delay: Duration(milliseconds: 700),
                        child: PrimaryButton(
                            title: "Publish",
                            onTap: () {
                              storeController.addDesign(title.text, price.text,
                                  fabric.text, color.text, size.text, context);
                              clearFields();
                            }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
