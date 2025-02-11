// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import, must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import '../customer_side/customer_profile_view.dart';
import 'designer_news_view.dart';
import 'desingerNotification_view.dart';
import 'display_design_comments_view.dart';
import 'orders_view.dart';
import 'publish_design_view.dart';
import 'publish_news.dart';

class DesignerHomePage extends StatefulWidget {
  const DesignerHomePage({super.key});

  @override
  State<DesignerHomePage> createState() => _DesignerHomePageState();
}

class _DesignerHomePageState extends State<DesignerHomePage> {
  List<String> designTitles = [
    "Classic Dress",
    "Hoody",
    "Blouse",
    "Skirt",
    "Trousers",
    "Shirt",
    "T-shirt",
    "Suit",
    "Handbag",
    "Pyjamas",
  ];
  List<String> designImage = [
    "assets/img/dress.png",
    "assets/img/hoody.png",
    "assets/img/blouse.png",
    "assets/img/skirt.png",
    "assets/img/trousers.png",
    "assets/img/shirt.png",
    "assets/img/shirt.png",
    "assets/img/suit.png",
    "assets/img/handbage.png",
    "assets/img/pyjama.png",
  ];
  final searchCont = TextEditingController();
  final storeController = Get.put(StoreController());
  @override
  void initState() {
    storeController.fetchDesinges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore New Designs!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),
                          storeController.allDesignes.isEmpty
                              ? Center(
                                  child: Text("There are no designes yet!",
                                      style: TextStyle(
                                          color: TColor.white,
                                          fontWeight: FontWeight.bold)))
                              : SizedBox(
                                  height: height,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        storeController.allDesignes.length,
                                    itemBuilder: (context, index) {
                                      var design =
                                          storeController.allDesignes[index];
                                      return InkWell(
                                        onTap: () {
                                          Get.to(DisplayDesignCommentsView());
                                        },
                                        child: DesignTile(
                                          img: "assets/img/hoody.png",
                                          title: design['title'],
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
    return Column(
      children: [
        InkWell(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(img),
                radius: 40,
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
        Divider(color: TColor.white),
      ],
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
  });

  final TextEditingController searchCont;
  void Function()? profileonTap;
  void Function()? newsonPressed;
  void Function()? notionPressed;

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
