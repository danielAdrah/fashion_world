// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../theme.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
  });
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.notifications,
                color: TColor.white,
                size: 40,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  Text(body,
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
        Divider(color: TColor.white, indent: 10, endIndent: 10),
      ],
    );
  }
}
