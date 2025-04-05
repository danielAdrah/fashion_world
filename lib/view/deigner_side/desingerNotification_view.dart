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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  CustomAppBar(),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: FadeInDown(
                      delay: Duration(milliseconds: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 30),
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
                                            fontSize: 16),
                                      )),
                                      SizedBox(height: 20),
                                      SvgPicture.asset(
                                        'assets/img/notAvailableYet.svg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: height,
                                  width: double.infinity,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: storeController
                                          .allNotifications.length,
                                      itemBuilder: (context, index) {
                                        var noti = storeController
                                            .allNotifications[index];
                                        return InkWell(
                                          onTap: () {},
                                          child: NotificationTile(
                                            title: noti['title'],
                                            body:
                                                'You Have An order From ${noti['customerName']}',
                                          ),
                                        );
                                      }),
                                ),
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
