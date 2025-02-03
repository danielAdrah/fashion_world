// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/custom_appBar.dart';
import '../../theme.dart';

class DesignCommentView extends StatefulWidget {
  const DesignCommentView({super.key});

  @override
  State<DesignCommentView> createState() => _DesignCommentViewState();
}

class _DesignCommentViewState extends State<DesignCommentView> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 4),
              CustomAppBar(),
              FadeInDown(
                delay: Duration(milliseconds: 500),
                child: Text(
                  "Comments",
                  style: TextStyle(
                    color: TColor.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInDown(
                delay: Duration(milliseconds: 600),
                child: CircleAvatar(
                  //here we will put a pic for the selected product
                  backgroundImage: AssetImage("assets/img/handbage.png"),
                  radius: 90,
                ),
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: FadeInDown(
                  delay: Duration(milliseconds: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: height,
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return CommentTile(
                                name: "Ali Ahmad",
                                content: "So coool",
                              );
                            }),
                      ),
                      // SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                child: PrimaryButton(
                    title: "Cancel",
                    onTap: () {
                      Get.back();
                    }),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

//===to display comments
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.name,
    required this.content,
  });
  final String name;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 212, 210, 210),
            radius: 30,
            child: Icon(
              Icons.person_2_outlined,
              size: 30,
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
