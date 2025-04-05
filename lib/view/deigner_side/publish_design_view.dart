// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_world/common_widget/custom_textField.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../common_widget/custom_appBar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'package:http/http.dart' as http;

class PublishDesignView extends StatefulWidget {
  const PublishDesignView({super.key});

  @override
  State<PublishDesignView> createState() => _PublishDesignViewState();
}

class _PublishDesignViewState extends State<PublishDesignView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final storeController = Get.put(StoreController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
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

  File? imageFile;
  String? imageUrl;
  String? publicId;
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

//======
  bool isUploading = false;
  Future<void> uploadImage() async {
    isUploading = true;
    setState(() {});
    print("1");
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dvz3way0c/upload');
    print("2");
    final request = http.MultipartRequest('Post', url)
      ..fields['upload_preset'] = 'fashion'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));
    print("3");
    final response = await request.send();
    if (response.statusCode == 200) {
      print("done");
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      setState(() {
        final url = jsonMap['url'];
        imageUrl = url;
      });
      publicId = jsonMap['public_id'];
      print(publicId);
      isUploading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ImageUploaded Successfully')),
      );
    }
  }
//======

  String? userName;
  fetchUserName() async {
    final docSnap = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (docSnap.exists) {
      userName = docSnap.get('name');
    }
    print(userName);
  }

  @override
  void initState() {
    fetchUserName();
    super.initState();
  }

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
                      child: Form(
                        key: formState,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextForm(
                              hinttext: " Design Title",
                              mycontroller: title,
                              secure: false,
                              validator: (val) {
                                if (val == "") {
                                  return " This Field Can't be empty";
                                }
                              },
                            ),
                            SizedBox(height: 40),
                            CustomTextForm(
                              hinttext: " Design Price",
                              mycontroller: price,
                              secure: false,
                              validator: (val) {
                                if (val == "") {
                                  return " This Field Can't be empty";
                                }
                              },
                            ),
                            SizedBox(height: 40),
                            CustomTextForm(
                              hinttext: "Design Fabric",
                              mycontroller: fabric,
                              secure: false,
                              validator: (val) {
                                if (val == "") {
                                  return " This Field Can't be empty";
                                }
                              },
                            ),
                            SizedBox(height: 40),
                            CustomTextForm(
                              hinttext: "Design Color",
                              mycontroller: color,
                              secure: false,
                              validator: (val) {
                                if (val == "") {
                                  return " This Field Can't be empty";
                                }
                              },
                            ),
                            SizedBox(height: 40),
                            CustomTextForm(
                              hinttext: "Design Size",
                              mycontroller: size,
                              secure: false,
                              validator: (val) {
                                if (val == "") {
                                  return " This Field Can't be empty";
                                }
                              },
                            ),
                            SizedBox(height: 40),
                            Row(
                              children: [
                                TextButton(
                                  child: Text(
                                    "Select Image",
                                    style: TextStyle(
                                        color: TColor.white, fontSize: 16),
                                  ),
                                  onPressed: () {
                                    pickImage();
                                    uploadImage();
                                  },
                                ),
                                imageFile != null
                                    ? SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: Image.file(imageFile!))
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "No image selected",
                                          style: TextStyle(
                                              color: TColor.white,
                                              fontSize: 16),
                                        ),
                                      ),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                  child: Text(
                                    "Upload the Image",
                                    style: TextStyle(
                                        color: TColor.white, fontSize: 16),
                                  ),
                                  onPressed: () {
                                    if (imageFile == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Please select the image before the uploading"),
                                        ),
                                      );
                                    } else {
                                      uploadImage();
                                    }
                                  },
                                ),
                                isUploading
                                    ? Expanded(
                                        child: Text(
                                          'Please Wait until the image is selected and uploaded',
                                          style: TextStyle(color: TColor.white),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  storeController.addDesignLoading.value
                      ? CircularProgressIndicator(color: TColor.primary)
                      : FadeInDown(
                          delay: Duration(milliseconds: 700),
                          child: PrimaryButton(
                              title: "Publish",
                              onTap: () {
                                if (formState.currentState!.validate()) {
                                  if (publicId != null) {
                                    storeController.addDesign(
                                        title.text,
                                        price.text,
                                        fabric.text,
                                        color.text,
                                        size.text,
                                        publicId,
                                        userName,
                                        context);
                                    clearFields();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Please Upload An Image First"),
                                      ),
                                    );
                                  }
                                }
                              }),
                        ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
