// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageId;
  final String userId;
  final String messageTime;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
    required this.messageTime,
  });

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            decoration: BoxDecoration(
              // color: isCurrentUser ? TColor.primary : TColor.white,
              gradient: LinearGradient(
                  colors: isCurrentUser
                      ? [TColor.background, TColor.background.withOpacity(0.5)]
                      : [
                          TColor.chatbackground,
                          TColor.chatbackground.withOpacity(0.5)
                        ]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(isCurrentUser ? 20 : 5),
                bottomRight: Radius.circular(isCurrentUser ? 5 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isCurrentUser ? 0 : 30,
              right: isCurrentUser ? 30 : 0,
            ),
            child: Text(
              messageTime,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
