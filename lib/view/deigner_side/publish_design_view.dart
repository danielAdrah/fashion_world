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

  // Dropdown values
  String? selectedFabric;
  String? selectedSize;

  // Color picker values
  String selectedColorTitle = 'White'; // Store color title instead of hex
  bool showColorPicker = false;

  // Predefined options
  final List<String> fabricOptions = [
    'Cotton',
    'Silk',
    'Linen',
    'Wool',
    'Polyester',
    'Velvet',
    'Chiffon',
    'Denim',
    'Leather',
    'Other'
  ];

  final List<String> sizeOptions = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'One Size',
    'Custom'
  ];

  // Color options with titles
  final Map<String, Color> colorOptions = {
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
    'Purple': Colors.purple,
    'Pink': Colors.pink,
    'Orange': Colors.orange,
    'Brown': Colors.brown,
    'Black': Colors.black,
    'White': Colors.white,
    'Grey': Colors.grey,
    'Teal': Colors.teal,
  };

  clearFields() {
    title.clear();
    price.clear();
    fabric.clear();
    color.clear();
    size.clear();
    setState(() {
      selectedFabric = null;
      selectedSize = null;
      selectedColorTitle = 'White';
    });
  }

  File? imageFile;
  String? imageUrl;
  String? publicId;

  // Image upload status
  bool isUploading = false;
  bool isUploadSuccess = false;
  String uploadStatus = '';

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
            child: Obx(
              () => Column(
                children: [
                  SizedBox(height: 20),
                  CustomAppBar(),
                  SizedBox(height: 30),
                  FadeInDown(
                    delay: Duration(milliseconds: 300),
                    child: Text(
                      "Publish New Design",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 30 : 24,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: responsiveSectionSpacing),
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
                      child: Form(
                        key: formState,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Design Details",
                              style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width > 600 ? 24 : 20,
                              ),
                            ),
                            SizedBox(height: width > 600 ? 25 : 20),
                            // Title field
                            CustomTextForm(
                              hinttext: "Design Title",
                              mycontroller: title,
                              secure: false,
                              validator: (val) {
                                if (val == "") {
                                  return "This field can't be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: width > 600 ? 30 : 25),
                            // Price field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: price,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: width > 600 ? 16 : 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Design Price (SR)",
                                  hintStyle: TextStyle(
                                    fontSize: width > 600 ? 16 : 14,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: width > 600 ? 20 : 18,
                                      horizontal: 20),
                                  border: InputBorder.none,
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  if (double.tryParse(val) == null) {
                                    return "Please enter a valid number";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: width > 600 ? 30 : 25),
                            // Fabric dropdown
                            Text(
                              "Fabric Type",
                              style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.w600,
                                fontSize: width > 600 ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedFabric,
                                  hint: Text(
                                    "Select fabric type",
                                    style: TextStyle(
                                      color: TColor.white.withOpacity(0.7),
                                      fontSize: width > 600 ? 16 : 14,
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: TColor.white,
                                  ),
                                  dropdownColor:
                                      TColor.background.withOpacity(0.9),
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: width > 600 ? 16 : 14,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFabric = newValue;
                                      if (newValue != null &&
                                          newValue != 'Other') {
                                        fabric.text = newValue;
                                      }
                                    });
                                  },
                                  items: fabricOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            // Custom fabric input if "Other" is selected
                            if (selectedFabric == 'Other')
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: CustomTextForm(
                                  hinttext: "Specify fabric type",
                                  mycontroller: fabric,
                                  secure: false,
                                  validator: (val) {
                                    if (val == "") {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            SizedBox(height: width > 600 ? 30 : 25),
                            // Color picker
                            Text(
                              "Design Color",
                              style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.w600,
                                fontSize: width > 600 ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showColorPicker = !showColorPicker;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            colorOptions[selectedColorTitle] ??
                                                Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      selectedColorTitle,
                                      style: TextStyle(
                                        color: TColor.white.withOpacity(0.8),
                                        fontSize: width > 600 ? 16 : 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      showColorPicker
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: TColor.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Color picker palette
                            if (showColorPicker)
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Select a color:",
                                      style: TextStyle(
                                        color: TColor.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width > 600 ? 16 : 14,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children:
                                          colorOptions.entries.map((entry) {
                                        return _buildColorOption(
                                            entry.value, entry.key);
                                      }).toList(),
                                    ),
                                    SizedBox(height: 15),
                                    // Custom color input
                                    CustomTextForm(
                                      hinttext: "Or enter color name",
                                      mycontroller: color,
                                      secure: false,
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: width > 600 ? 30 : 25),
                            // Size dropdown
                            Text(
                              "Design Size",
                              style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.w600,
                                fontSize: width > 600 ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSize,
                                  hint: Text(
                                    "Select design size",
                                    style: TextStyle(
                                      color: TColor.white.withOpacity(0.7),
                                      fontSize: width > 600 ? 16 : 14,
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: TColor.white,
                                  ),
                                  dropdownColor:
                                      TColor.background.withOpacity(0.9),
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: width > 600 ? 16 : 14,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSize = newValue;
                                      if (newValue != null &&
                                          newValue != 'Custom') {
                                        size.text = newValue;
                                      }
                                    });
                                  },
                                  items: sizeOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            // Custom size input if "Custom" is selected
                            if (selectedSize == 'Custom')
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: CustomTextForm(
                                  hinttext: "Specify custom size",
                                  mycontroller: size,
                                  secure: false,
                                  validator: (val) {
                                    if (val == "") {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            SizedBox(height: width > 600 ? 35 : 30),
                            Text(
                              "Design Image",
                              style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width > 600 ? 22 : 18,
                              ),
                            ),
                            SizedBox(height: width > 600 ? 20 : 15),
                            // Enhanced image selection section
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
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                  color: TColor.white
                                                      .withOpacity(0.7),
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  "No image selected",
                                                  style: TextStyle(
                                                    color: TColor.white
                                                        .withOpacity(0.7),
                                                    fontSize:
                                                        width > 600 ? 18 : 16,
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
                                                  : Colors.red
                                                      .withOpacity(0.5)),
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
                                                    AlwaysStoppedAnimation<
                                                        Color>(
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
                                            isUploadSuccess
                                                ? "Uploaded"
                                                : "Upload",
                                            style: TextStyle(
                                              color: TColor.white,
                                              fontSize: width > 600 ? 16 : 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isUploadSuccess
                                                ? Colors.green.withOpacity(0.7)
                                                : TColor.primary
                                                    .withOpacity(0.8),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsiveSectionSpacing),
                  storeController.addDesignLoading.value
                      ? Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  TColor.primary,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Publishing your design...",
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : FadeInUp(
                          delay: Duration(milliseconds: 500),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    width * (1 - responsiveWidthFactor) / 2),
                            child: PrimaryButton(
                              title: "Publish Design",
                              onTap: () {
                                // Set the text controllers to the selected values if they exist
                                if (selectedFabric != null &&
                                    selectedFabric != 'Other') {
                                  fabric.text = selectedFabric!;
                                }
                                if (selectedSize != null &&
                                    selectedSize != 'Custom') {
                                  size.text = selectedSize!;
                                }
                                // Set color controller to the selected color title
                                color.text = selectedColorTitle;

                                if (formState.currentState!.validate()) {
                                  if (isUploadSuccess && publicId != null) {
                                    storeController.addDesign(
                                      title.text,
                                      price.text,
                                      fabric.text,
                                      color.text, // Now stores color title
                                      size.text,
                                      publicId!,
                                      userName ?? '',
                                      context,
                                    );
                                    clearFields();
                                    // Reset image state after successful publish
                                    setState(() {
                                      imageFile = null;
                                      publicId = null;
                                      isUploadSuccess = false;
                                      uploadStatus = '';
                                    });
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
                                }
                              },
                            ),
                          ),
                        ),
                  SizedBox(height: width > 600 ? 50 : 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build color option widgets
  Widget _buildColorOption(Color colorValue, String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorTitle = name;
          color.text = name; // Store the color title in the text controller
          showColorPicker = false;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: colorValue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedColorTitle == name
                ? TColor.primary
                : Colors.white.withOpacity(0.5),
            width: selectedColorTitle == name ? 3 : 1,
          ),
        ),
        child: selectedColorTitle == name
            ? Icon(
                Icons.check,
                color: colorValue.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                size: 30,
              )
            : null,
      ),
    );
  }
}
