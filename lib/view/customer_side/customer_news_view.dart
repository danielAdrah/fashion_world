// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/custom_appBar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class CustomerNewsView extends StatefulWidget {
  const CustomerNewsView({super.key});

  @override
  State<CustomerNewsView> createState() => _CustomerNewsViewState();
}

class _CustomerNewsViewState extends State<CustomerNewsView> {
  final storeController = Get.put(StoreController());
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
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  "News",
                  style: TextStyle(
                    color: TColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: StreamBuilder(
                    stream: storeController.fetchNews(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: TColor.primary));
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "There are no news yet",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var news = snapshot.data![index];
                            return PostTile(
                              name: news['user'],
                              content: news['content'],
                              img: "assets/img/hoody.png",
                            );
                          });
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
