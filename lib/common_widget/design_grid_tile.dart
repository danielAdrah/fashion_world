// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/theme.dart';
import 'package:flutter/material.dart';

class DesignGridTile extends StatelessWidget {
  const DesignGridTile({
    super.key,
    required this.img,
    required this.title,
  });
  final String img;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              width: double.infinity,
              height: 150, // Larger image for better visual impact
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                color: Colors.white.withOpacity(0.2),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: CldImageWidget(
                  publicId: img,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Title with padding
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
