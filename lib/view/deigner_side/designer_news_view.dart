// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../common_widget/custom_appBar.dart';
import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'package:http/http.dart' as http;

class DesignerNewsView extends StatefulWidget {
  const DesignerNewsView({super.key});

  @override
  State<DesignerNewsView> createState() => _DesignerNewsViewState();
}

class _DesignerNewsViewState extends State<DesignerNewsView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storeController = Get.put(StoreController());
  final postTextController = TextEditingController();
  bool isUploading = false;
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

  //=====
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

//=======
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomAppBar(),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextForm(
                            hinttext: "Enter your post",
                            mycontroller: postTextController,
                            secure: false),
                      ),
                      IconButton(
                          onPressed: () {
                            if (publicId != null) {
                              storeController.addNews(
                                  postTextController.text, publicId, userName);
                              postTextController.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please Upload An Image First"),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.arrow_circle_up_rounded,
                            color: TColor.primary,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        "Selecte Image",
                        style: TextStyle(color: TColor.white),
                      ),
                      onPressed: () {
                        pickImage();
                      },
                    ),
                    isUploading
                        ? CircularProgressIndicator(color: TColor.primary)
                        : TextButton(
                            child: Text(
                              "Upload The Image",
                              style: TextStyle(color: TColor.white),
                            ),
                            onPressed: () {
                              if (imageFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                  ],
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: StreamBuilder(
                      stream: storeController.fetchNews(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: TColor.primary));
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              "There are no news yet",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var news = snapshot.data![index];
                              return PostTile(
                                name: news['user'],
                                content: news['content'],
                                img: news['image'],
                              );
                            });
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

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.name,
    required this.content,
    required this.img,
  });
  final String name;
  final String content;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 212, 210, 210),
                radius: 30,
                child: Icon(
                  Icons.person_2_outlined,
                  size: 30,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      color: TColor.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: TColor.black,
            ),
          ),
          SizedBox(height: 8),
          // SizedBox(
          //   width: double.infinity,
          //   child: Image.asset(img, fit: BoxFit.fill),
          // ),
          CldImageWidget(
            publicId: img,
            width: double.infinity,
            // height: 70,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
