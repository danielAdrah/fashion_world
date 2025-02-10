// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/notification_tile.dart';
import '../../theme.dart';

class DesingernotificationView extends StatefulWidget {
  const DesingernotificationView({super.key});

  @override
  State<DesingernotificationView> createState() =>
      _DesingernotificationViewState();
}

class _DesingernotificationViewState extends State<DesingernotificationView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                      SizedBox(
                        height: height,
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: NotificationTile(
                                  title: "Some content",
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
    );
  }
}
