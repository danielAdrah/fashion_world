// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../controller/store_controller.dart';
import '../../services/chat_service.dart';
import '../../theme.dart';
import '../customer_side/chat_page.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final chatService = ChatService();
  final controller = Get.put(StoreController());

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
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * (1 - responsiveWidthFactor) / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  CustomAppBar(),
                  SizedBox(height: 30),
                  FadeInDown(
                    delay: Duration(milliseconds: 300),
                    child: Text(
                      "Chats",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 30 : 24,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: responsiveSectionSpacing),
                  SizedBox(
                    width: double.infinity,
                    // height: height * 0.7,
                    child: StreamBuilder(
                      stream: chatService.getAllUserStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error loading chats",
                              style: TextStyle(color: TColor.white),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                TColor.primary,
                              ),
                            ),
                          );
                        }
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_outlined,
                                  size: width > 600 ? 80 : 60,
                                  color: TColor.white.withOpacity(0.7),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "No conversations yet",
                                  style: TextStyle(
                                    color: TColor.white.withOpacity(0.8),
                                    fontSize: width > 600 ? 20 : 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Start a conversation with a customer",
                                  style: TextStyle(
                                    color: TColor.white.withOpacity(0.6),
                                    fontSize: width > 600 ? 16 : 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Filter out current user and admins
                        var filteredUsers = snapshot.data!
                            .where((user) =>
                                user["email"] != auth.currentUser!.email &&
                                user['role'] != 'Admin')
                            .toList();

                        if (filteredUsers.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group_off_outlined,
                                  size: width > 600 ? 80 : 60,
                                  color: TColor.white.withOpacity(0.7),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "No available contacts",
                                  style: TextStyle(
                                    color: TColor.white.withOpacity(0.8),
                                    fontSize: width > 600 ? 20 : 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Customers will appear here when they sign up",
                                  style: TextStyle(
                                    color: TColor.white.withOpacity(0.6),
                                    fontSize: width > 600 ? 16 : 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            var user = filteredUsers[index];
                            return FadeInUp(
                              delay: Duration(milliseconds: 200 * index),
                              child: ChatTile(
                                name: user["name"],
                                email: user["email"],
                                userId: user["uid"],
                                onTap: () {
                                  Get.to(ChatPage(
                                    receiverName: user["name"],
                                    receiverID: user["uid"],
                                  ));
                                },
                              ),
                            );
                          },
                        );
                      },
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

class ChatTile extends StatelessWidget {
  ChatTile({
    super.key,
    required this.onTap,
    required this.name,
    required this.email,
    required this.userId,
  });
  void Function()? onTap;
  final String name;
  final String email;
  final String userId;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * (width > 600 ? 0.7 : 0.9),
        margin: EdgeInsets.symmetric(
          horizontal: width * (1 - (width > 600 ? 0.7 : 0.9)) / 2,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              // User avatar
              Container(
                width: width > 600 ? 60 : 50,
                height: width > 600 ? 60 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TColor.primary.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: TColor.white,
                  size: width > 600 ? 30 : 25,
                ),
              ),
              SizedBox(width: 15),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 18 : 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      email,
                      style: TextStyle(
                        color: TColor.white.withOpacity(0.8),
                        fontSize: width > 600 ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: TColor.white.withOpacity(0.7),
                size: width > 600 ? 20 : 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
