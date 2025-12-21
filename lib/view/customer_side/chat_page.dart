// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/chat_bubble.dart';
import '../../common_widget/custom_textField.dart';
import '../../services/chat_service.dart';
import '../../theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiverName, required this.receiverID});
  final String receiverName;
  final String receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatService chat = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode myFocusNode = FocusNode();

  //send a message
  void sendMessage() async {
    //make sure that there is something in the message
    if (messageController.text.isNotEmpty) {
      await chat.sendMessage(widget.receiverID, messageController.text);
    }
    messageController.clear();
    scrollDown();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          Duration(milliseconds: 300),
          () => scrollDown(),
        );
      }
    });

    //this for scrolling down the messages
    Future.delayed(
      Duration(milliseconds: 300),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    messageController.dispose();
  }

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.primary,
      appBar: AppBar(
        toolbarHeight: height * 0.09,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
        ),
        title: FadeInDown(
          delay: Duration(milliseconds: 300),
          child: Text(
            widget.receiverName,
            style: TextStyle(
              color: TColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColor.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          buildUserInput(),
        ],
      ),
    );
  }

  //=========list of the messages=============
  Widget buildMessageList() {
    String senderID = auth.currentUser!.uid;
    return StreamBuilder(
        stream: chat.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // if has errors
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Error loading messages",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          //if it is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: TColor.primary,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Loading messages...",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: TColor.primary.withOpacity(0.5),
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No messages yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TColor.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Start a conversation with ${widget.receiverName}",
                    style: TextStyle(
                      fontSize: 16,
                      color: TColor.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          //return a list of messages
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: 20),
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        });
  }

  //=====
  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == auth.currentUser!.uid;

    //timestamp for the message
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String messageDate = dateTime.toString().substring(11, 16);

    return FadeInUp(
      duration: Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            messageTime: messageDate,
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data['senderID'],
          ),
        ],
      ),
    );
  }

  //========user input============
  Widget buildUserInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
        color: TColor.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CustomTextForm(
                mycontroller: messageController,
                secure: false,
                focusNode: myFocusNode,
                hinttext: "Type a message...",
                suffixIcon: Icons.attach_file,
                onTap: () {
                  // TODO: Implement attachment functionality
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TColor.primary.withOpacity(0.9),
                  TColor.primary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  sendMessage();
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
