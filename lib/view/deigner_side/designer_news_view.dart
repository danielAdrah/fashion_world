// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/common_widget/post_tile.dart';
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

  // Image upload status
  bool isUploading = false;
  bool isUploadSuccess = false;
  String uploadStatus = '';
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
        // Reset upload status when new image is selected
        isUploadSuccess = false;
        uploadStatus = 'Image selected. Ready to upload.';
      } else {
        uploadStatus = 'No image selected';
      }
    });
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      setState(() {
        uploadStatus = 'Please select an image first';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() {
      isUploading = true;
      uploadStatus = 'Uploading image...';
    });

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dvz3way0c/upload');
      final request = http.MultipartRequest('Post', url)
        ..fields['upload_preset'] = 'fashion'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        setState(() {
          imageUrl = jsonMap['url'];
          publicId = jsonMap['public_id'];
          isUploading = false;
          isUploadSuccess = true;
          uploadStatus = 'Image uploaded successfully!';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          isUploading = false;
          isUploadSuccess = false;
          uploadStatus = 'Upload failed. Please try again.';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image upload failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
        isUploadSuccess = false;
        uploadStatus = 'Upload error. Check connection.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
    var width = MediaQuery.of(context).size.width;

    // Responsive sizing
    double responsiveWidthFactor = width > 600 ? 0.7 : 0.9;
    double responsiveSectionSpacing = width > 600 ? 40.0 : 30.0;

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                TColor.background.withOpacity(0.95),
                TColor.primary.withOpacity(0.7),
              ],
            ),
            image: DecorationImage(
              image: AssetImage("assets/img/bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomAppBar(),
                SizedBox(height: 30),
                FadeInDown(
                  delay: Duration(milliseconds: 300),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: Text(
                      "Share Your News",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 30 : 24,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Enhanced post creation section
                FadeInUp(
                  delay: Duration(milliseconds: 400),
                  child: Container(
                    width: width * responsiveWidthFactor,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    padding: EdgeInsets.all(width > 600 ? 30 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(width > 600 ? 25 : 20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: width > 600 ? 25 : 20,
                          offset: Offset(0, width > 600 ? 10 : 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Post",
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width > 600 ? 24 : 20,
                          ),
                        ),
                        SizedBox(height: width > 600 ? 25 : 20),
                        // Text input area
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: postTextController,
                            maxLines: 4,
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: width > 600 ? 18 : 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              hintStyle: TextStyle(
                                color: TColor.white.withOpacity(0.7),
                                fontSize: width > 600 ? 18 : 16,
                              ),
                              contentPadding:
                                  EdgeInsets.all(width > 600 ? 20 : 15),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: width > 600 ? 25 : 20),
                        // Image section
                        Text(
                          "Add Image",
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width > 600 ? 22 : 18,
                          ),
                        ),
                        SizedBox(height: width > 600 ? 20 : 15),
                        Container(
                          padding: EdgeInsets.all(width > 600 ? 20 : 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Image preview area
                              Container(
                                height: width > 600 ? 250 : 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: imageFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              size: width > 600 ? 60 : 50,
                                              color:
                                                  TColor.white.withOpacity(0.7),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "No image selected",
                                              style: TextStyle(
                                                color: TColor.white
                                                    .withOpacity(0.7),
                                                fontSize: width > 600 ? 18 : 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              SizedBox(height: 20),
                              // Upload status indicator
                              if (uploadStatus.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isUploadSuccess
                                        ? Colors.green.withOpacity(0.2)
                                        : (isUploading
                                            ? Colors.blue.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isUploadSuccess
                                          ? Colors.green.withOpacity(0.5)
                                          : (isUploading
                                              ? Colors.blue.withOpacity(0.5)
                                              : Colors.red.withOpacity(0.5)),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isUploadSuccess
                                            ? Icons.check_circle
                                            : (isUploading
                                                ? Icons.upload
                                                : Icons.error),
                                        color: isUploadSuccess
                                            ? Colors.green
                                            : (isUploading
                                                ? Colors.blue
                                                : Colors.red),
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          uploadStatus,
                                          style: TextStyle(
                                            color: TColor.white,
                                            fontSize: width > 600 ? 16 : 14,
                                          ),
                                        ),
                                      ),
                                      if (isUploading)
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              TColor.primary,
                                            ),
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 20),
                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: pickImage,
                                      icon: Icon(
                                        Icons.image,
                                        color: TColor.white,
                                      ),
                                      label: Text(
                                        "Select Image",
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: width > 600 ? 16 : 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            TColor.primary.withOpacity(0.8),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: width > 600 ? 15 : 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          isUploading ? null : uploadImage,
                                      icon: Icon(
                                        isUploadSuccess
                                            ? Icons.check
                                            : Icons.upload,
                                        color: TColor.white,
                                      ),
                                      label: Text(
                                        isUploadSuccess ? "Uploaded" : "Upload",
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: width > 600 ? 16 : 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isUploadSuccess
                                            ? Colors.green.withOpacity(0.7)
                                            : TColor.primary.withOpacity(0.8),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: width > 600 ? 15 : 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: width > 600 ? 30 : 25),
                        // Post button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (postTextController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please enter some content for your post'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (isUploadSuccess && publicId != null) {
                                storeController.addNews(postTextController.text,
                                    publicId!, userName ?? '');
                                postTextController.clear();
                                // Reset image state after successful post
                                setState(() {
                                  imageFile = null;
                                  publicId = null;
                                  isUploadSuccess = false;
                                  uploadStatus = '';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Post published successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isUploading
                                          ? "Please wait for image upload to complete"
                                          : "Please upload an image first",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: TColor.white,
                            ),
                            label: Text(
                              "Publish Post",
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: width > 600 ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColor.primary.withOpacity(0.9),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: width > 600 ? 18 : 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor: TColor.primary.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Posts feed header
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: Text(
                      "Latest News",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 26 : 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width > 600 ? 25 : 20),
                // Posts feed
                SizedBox(
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: storeController.fetchNews(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error loading posts",
                            style: TextStyle(color: TColor.white),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              TColor.primary,
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "No posts yet. Be the first to share!",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                              fontSize: width > 600 ? 18 : 16,
                            ),
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
                            name: news['user'] ?? 'Anonymous',
                            content: news['content'] ?? '',
                            img: news['image'] ?? '',
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
