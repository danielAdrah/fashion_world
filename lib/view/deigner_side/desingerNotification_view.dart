// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/notification_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class DesingernotificationView extends StatefulWidget {
  const DesingernotificationView({super.key});

  @override
  State<DesingernotificationView> createState() =>
      _DesingernotificationViewState();
}

class _DesingernotificationViewState extends State<DesingernotificationView> {
  final storeController = Get.put(StoreController());
  @override
  void initState() {
    storeController.fetchNotification();
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
                        "Notifications",
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: FadeInUp(
                      delay: Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          storeController.allNotifications.isEmpty
                              ? FadeInDown(
                                  delay: Duration(milliseconds: 400),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 60),
                                      Center(
                                        child: Text(
                                          "You don't have any notifications yet",
                                          style: TextStyle(
                                            color: TColor.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width > 600 ? 20 : 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        width: width * 0.6,
                                        height: width * 0.6,
                                        child: SvgPicture.asset(
                                          'assets/img/notAvailableYet.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        "New notifications will appear here when customers interact with your designs",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: TColor.white.withOpacity(0.8),
                                          fontSize: width > 600 ? 18 : 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        storeController.allNotifications.length,
                                    itemBuilder: (context, index) {
                                      var noti = storeController
                                          .allNotifications[index];
                                      return FadeInUp(
                                        delay:
                                            Duration(milliseconds: 200 * index),
                                        child: InkWell(
                                          onTap: () {},
                                          child: NotificationTile(
                                            title: noti['title'],
                                            body:
                                                'You Have An order From ${noti['customerName']}',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
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
