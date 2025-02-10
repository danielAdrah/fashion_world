// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../common_widget/custom_appBar.dart';
import '../../common_widget/custom_textField.dart';
import '../../theme.dart';

class DesignerNewsView extends StatefulWidget {
  const DesignerNewsView({super.key});

  @override
  State<DesignerNewsView> createState() => _DesignerNewsViewState();
}

class _DesignerNewsViewState extends State<DesignerNewsView> {
  final postTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CustomAppBar(),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                          hinttext: "Enter your post",
                          mycontroller: postTextController,
                          secure: false),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_circle_up_rounded,
                          color: TColor.primary,
                          size: 40,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return PostTile(
                        name: "Daniel Adrah",
                        content:
                            "hello my friends how are you hope yoy are doing good, how is life with you? what about the weather is it cold , hot or very hot in the golf",
                        img: "assets/img/hoody.png",
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.name,
    required this.content,
    required this.img,
  });
  final String name;
  final String content;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 212, 210, 210),
                radius: 35,
                child: Icon(
                  Icons.person_2_outlined,
                  size: 30,
                ),
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: TColor.black,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Image.asset(img, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
