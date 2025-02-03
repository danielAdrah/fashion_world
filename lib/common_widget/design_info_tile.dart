import 'package:flutter/material.dart';

import '../theme.dart';

class DesinInfoTile extends StatelessWidget {
  const DesinInfoTile({
    super.key, required this.name, required this.value,
  });
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 16,
              color: TColor.white,
              fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              color: TColor.white,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
