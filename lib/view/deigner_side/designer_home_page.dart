// ignore_for_file: deprecated_member_use

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
              image: const AssetImage("assets/img/bg.png"),
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
                    const SizedBox(height: 30),
                    FadeInDown(
                      delay: const Duration(milliseconds: 500),
                      child: SearchAndProfile(
                        searchCont: searchCont,
                        profileonTap: () {
                          Get.to(const CustomerProfileView());
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
                    const SizedBox(height: 20),
                    // Modern action buttons section
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: Container(
                        width: width * 0.9,
                        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                        padding: const EdgeInsets.all(20),
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
                              offset: const Offset(0, 5),
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
                            const SizedBox(height: 15),
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
                                        // icon: Icons.add_box_outlined,
                                        img: "assets/img/puplish1.png",
                                        label: "Publish Design",
                                        onTap: () {
                                          Get.to(const PublishDesignView());
                                        },
                                        color: TColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: buttonWidth,
                                      child: _buildActionButton(
                                        img: "assets/img/orders1.png",
                                        label: "My Orders",
                                        onTap: () {
                                          Get.to(const OrdersView());
                                        },
                                        color: TColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: buttonWidth,
                                      child: _buildActionButton(
                                        img: "assets/img/chat1.png",
                                        label: "My Chat",
                                        onTap: () {
                                          Get.to(const ChatView());
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
                                          Get.to(
                                              const DesingernotificationView());
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
                                          Get.to(const DesignerNewsView());
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
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Latest Designs",
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                if (isDesignSearched)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isDesignSearched = false;
                                        searchCont.clear();
                                      });
                                    },
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(color: TColor.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            storeController.allDesignes.isEmpty
                                ? Center(
                                    child: Text(
                                      'No designs available yet!',
                                      style: TextStyle(
                                        color: TColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
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
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: snap.length,
                                            itemBuilder: (context, index) {
                                              var design = snap[index];
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(DesignerDesignDetail(
                                                    designID: design.id,
                                                    designerName:
                                                        design['desingerName'],
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
                            const SizedBox(height: 20),
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
    // required IconData icon,
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Image.asset(
                  img,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10),
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
            const SizedBox(width: 20),
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
              padding: const EdgeInsets.all(8),
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
