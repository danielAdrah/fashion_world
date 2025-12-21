import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/theme.dart';
import 'package:flutter/material.dart';

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
    var width = MediaQuery.of(context).size.width;

    return FadeInUp(
      delay: Duration(milliseconds: 300),
      child: Container(
        width: width * (width > 600 ? 0.7 : 0.9),
        margin: EdgeInsets.symmetric(
          horizontal: width * (1 - (width > 600 ? 0.7 : 0.9)) / 2,
          vertical: 10,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info section
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TColor.primary.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: TColor.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 18 : 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Post content
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                content,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: width > 600 ? 16 : 14,
                  height: 1.5,
                ),
              ),
            ),
            // Post image
            if (img.isNotEmpty)
              Container(
                // height: width > 600 ? 300 : 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: CldImageWidget(
                    publicId: img,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
