// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import, must_be_immutables

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'customer_news_view.dart';
import 'customer_notification_view.dart';
import 'design_detail.dart';
import 'customer_profile_view.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  bool isDesignSearched = false;

  final searchCont = TextEditingController();
  final storeController = Get.put(StoreController());

  @override
  void initState() {
    storeController.fetchDesinges();
    super.initState();
  }

  @override
  void dispose() {
    searchCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
                TColor.background.withOpacity(0.9),
                TColor.primary.withOpacity(0.6),
              ],
            ),
            image: DecorationImage(
              image: AssetImage("assets/img/bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    FadeInDown(
                      delay: Duration(milliseconds: 500),
                      child: SearchAndProfile(
                        searchCont: searchCont,
                        profileonTap: () {
                          Get.to(CustomerProfileView());
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              isDesignSearched = true;
                            });
                          } else {
                            setState(() {
                              isDesignSearched = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Quick action buttons section
                    FadeInUp(
                      delay: Duration(milliseconds: 600),
                      child: Container(
                        width: width * 0.9,
                        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quick Actions",
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
                            // Grid layout for action buttons
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double buttonWidth =
                                    (constraints.maxWidth - 40) / 3;
                                return Wrap(
                                  spacing: 20,
                                  runSpacing: 15,
                                  children: [
                                    SizedBox(
                                      width: buttonWidth,
                                      child: _buildActionButton(
                                        img: "assets/img/noti1.png",
                                        label: "My Cart",
                                        onTap: () {
                                          // TODO: Implement cart functionality
                                        },
                                        color: TColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: buttonWidth,
                                      child: _buildActionButton(
                                        img: "assets/img/noti1.png",
                                        label: "Wishlist",
                                        onTap: () {
                                          // TODO: Implement wishlist functionality
                                        },
                                        color: TColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: buttonWidth,
                                      child: _buildActionButton(
                                        img: "assets/img/noti1.png",
                                        label: "Notifications",
                                        onTap: () {
                                          Get.to(CustomerNotificationView());
                                        },
                                        color: TColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: buttonWidth,
                                      child: _buildActionButton(
                                        img: "assets/img/post2.png",
                                        label: "News",
                                        onTap: () {
                                          Get.to(CustomerNewsView());
                                        },
                                        color: TColor.primary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FadeInUp(
                        delay: Duration(milliseconds: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explore New Designs",
                              style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Discover the latest fashion creations",
                              style: TextStyle(
                                color: TColor.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 25),
                            storeController.allDesignes.isEmpty
                                ? FadeInDown(
                                    delay: Duration(milliseconds: 400),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 60),
                                          Text(
                                            'No designs available yet!',
                                            style: TextStyle(
                                              color: TColor.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          SvgPicture.asset(
                                            'assets/img/notAvailableYet.svg',
                                            width: 200,
                                            height: 200,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("designes")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              snapshot.error.toString(),
                                              style: TextStyle(
                                                  color: TColor.white),
                                            ),
                                          );
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: TColor.primary,
                                            ),
                                          );
                                        }
                                        if (snapshot.hasData ||
                                            snapshot.data != null) {
                                          List snap = snapshot.data!.docs;
                                          if (isDesignSearched) {
                                            snap.removeWhere((e) {
                                              return !e
                                                  .data()["title"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCont.text
                                                      .toLowerCase());
                                            });
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: snap.length,
                                            itemBuilder: (context, index) {
                                              var design = snap[index];
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(DesginDetail(
                                                    designerName:
                                                        design['desingerName'],
                                                    designID: design.id,
                                                    designTitle:
                                                        design['title'],
                                                    designerID:
                                                        design['desingerID'],
                                                    designColor:
                                                        design['color'],
                                                    designFabric:
                                                        design['fabric'],
                                                    designPrice:
                                                        design['price'],
                                                    designSize: design['size'],
                                                    designName: design['title'],
                                                    designStatus:
                                                        design['status'],
                                                    designImage:
                                                        design['imageUrl'],
                                                  ));
                                                },
                                                child: DesignTile(
                                                  img: design['imageUrl'],
                                                  title: design['title'],
                                                ),
                                              );
                                            },
                                          );
                                        }

                                        return Center(
                                          child: Text(
                                            "No designs available yet!",
                                            style: TextStyle(
                                              color: TColor.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Action button widget for consistent styling
  Widget _buildActionButton({
    required String img,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ElasticIn(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Image.asset(
                img,
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DesignTile extends StatelessWidget {
  const DesignTile({
    super.key,
    required this.img,
    required this.title,
  });
  final String img;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CldImageWidget(
                  publicId: img,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: TColor.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

//====================
class SearchAndProfile extends StatelessWidget {
  SearchAndProfile({
    super.key,
    required this.searchCont,
    required this.profileonTap,
    this.onChanged,
  });

  final TextEditingController searchCont;
  void Function()? profileonTap;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: profileonTap,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.person_2_outlined,
                color: TColor.white,
                size: 28,
              ),
            ),
          ),
          Container(
            width: width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomTextForm(
              hinttext: "Search designs...",
              mycontroller: searchCont,
              onChanged: onChanged,
              secure: false,
              prefixIcon: Icon(
                Icons.search,
                color: TColor.primary,
              ),
              color: TColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
