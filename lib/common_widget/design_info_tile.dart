import 'package:flutter/material.dart';

import '../theme.dart';

class DesinInfoTile extends StatelessWidget {
  const DesinInfoTile({
    super.key,
    required this.name,
    required this.value,
  });
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: TColor.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: TColor.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
