// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import, must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';
import '../customer_side/customer_profile_view.dart';
import '../customer_side/design_detail.dart';
import 'chat_view.dart';
import 'designer_design_detail.dart';
import 'designer_news_view.dart';
import 'desingerNotification_view.dart';
import 'orders_view.dart';
import 'publish_design_view.dart';

class DesignerHomePage extends StatefulWidget {
  const DesignerHomePage({super.key});

  @override
  State<DesignerHomePage> createState() => _DesignerHomePageState();
}

class _DesignerHomePageState extends State<DesignerHomePage> {
  bool isDesignSearched = false;
  final searchCont = TextEditingController();
  final storeController = Get.put(StoreController());
  final notiService = NotificationService();
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
                        newsonPressed: () {
                          Get.to(DesignerNewsView());
                        },
                        notionPressed: () {
                          Get.to(DesingernotificationView());
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              isDesignSearched = true; // Reset search state
                            });
                          } else {
                            setState(() {
                              isDesignSearched = false; // Reset search state
                            });
                          }
                        },
                      ),
                    ),
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: Row(
                        children: [
                          TextButton(
                            child: Text(
                              "Publish a new design",
                              style: TextStyle(color: TColor.white),
                            ),
                            onPressed: () {
                              Get.to(PublishDesignView());
                            },
                          ),
                          TextButton(
                            child: Text(
                              "My Orders",
                              style: TextStyle(color: TColor.white),
                            ),
                            onPressed: () {
                              Get.to(OrdersView());
                            },
                          ),
                        ],
                      ),
                    ),
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: Row(
                        children: [
                          TextButton(
                            child: Text(
                              "My Chat",
                              style: TextStyle(color: TColor.white),
                            ),
                            onPressed: () {
                              Get.to(ChatView());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FadeInDown(
                        delay: Duration(milliseconds: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "Explore New Designs!",
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     color: TColor.white,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            SizedBox(height: 5),
                            storeController.allDesignes.isEmpty
                                ? Center(
                                    child: Text(
                                      'There are no designes yet!',
                                      style: TextStyle(
                                          color: TColor.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : SizedBox(
                                    height: height,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("designes")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: CircularProgressIndicator(
                                                  color: TColor.primary));
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
                                                  .startsWith(searchCont.text);
                                            });
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snap.length,
                                              itemBuilder: (context, index) {
                                                var design = snap[index];
                                                return InkWell(
                                                  onTap: () {
                                                    Get.to(DesignerDesignDetail(
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
                                                      designSize:
                                                          design['size'],
                                                      designName:
                                                          design['title'],
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
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snap.length,
                                              itemBuilder: (context, index) {
                                                var design = snap[index];
                                                return InkWell(
                                                  onTap: () {
                                                    // Get.to(DisplayDesignCommentsView());
                                                    Get.to(DesignerDesignDetail(
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
                                                      designSize:
                                                          design['size'],
                                                      designName:
                                                          design['title'],
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
                                        }

                                        return Text(
                                            "There are no designes yet!",
                                            style:
                                                TextStyle(color: TColor.white));
                                      },
                                    )),
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
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1.5),
              blurRadius: 0.2,
              blurStyle: BlurStyle.outer,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 160, 109, 137),
        ),
        child: Row(
          children: [
            CldImageWidget(
              publicId: img,
              width: 70,
              height: 70,
            ),
            SizedBox(width: 70),
            Text(
              title,
              style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
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
    required this.newsonPressed,
    required this.notionPressed,
    this.onChanged,
  });

  final TextEditingController searchCont;
  void Function()? profileonTap;
  void Function()? newsonPressed;
  void Function()? notionPressed;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: profileonTap,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 212, 210, 210),
            radius: 25,
            child: Icon(Icons.person_2_outlined),
          ),
        ),
        Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: CustomTextForm(
            hinttext: "",
            mycontroller: searchCont,
            onChanged: onChanged,
            secure: false,
            suffixIcon: Icons.search,
            color: TColor.primary,
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: notionPressed,
                icon: Icon(Icons.notifications_none_rounded,
                    color: TColor.white)),
            IconButton(
                onPressed: newsonPressed,
                icon: Icon(Icons.newspaper_outlined, color: TColor.white)),
            Image.asset("assets/img/logo.png"),
          ],
        ),
      ],
    );
  }
}
