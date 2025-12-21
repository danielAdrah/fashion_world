// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/custom_appBar.dart';
import '../../common_widget/design_info_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import '../customer_side/design_comment_view.dart';

class DesignerDesignDetail extends StatefulWidget {
  const DesignerDesignDetail({
    super.key,
    required this.designerName,
    required this.designID,
    required this.designerID,
    required this.designColor,
    required this.designFabric,
    required this.designPrice,
    required this.designSize,
    required this.designName,
    required this.designStatus,
    required this.designImage,
    required this.designTitle,
  });
  final String designerName;
  final String designID;
  final String designerID;
  final String designColor;
  final String designFabric;
  final String designPrice;
  final String designSize;
  final String designName;
  final String designStatus;
  final String designImage;
  final String designTitle;

  @override
  State<DesignerDesignDetail> createState() => _DesignerDesignDetailState();
}

class _DesignerDesignDetailState extends State<DesignerDesignDetail>
    with SingleTickerProviderStateMixin {
  final storeController = Get.put(StoreController());
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Responsive sizing
    double responsiveWidthFactor = width > 600 ? 0.7 : 0.9;
    double responsiveImageSize = width > 600 ? 250.0 : 200.0;
    double responsiveTextSize = width > 600 ? 30.0 : 24.0;
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
            child: Column(
              children: [
                SizedBox(height: 10),
                CustomAppBar(),
                FadeInDown(
                  delay: Duration(milliseconds: 300),
                  child: Text(
                    "Design Details",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveTextSize,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Design image section with enhanced glassmorphism
                FadeInUp(
                  delay: Duration(milliseconds: 400),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: width * responsiveWidthFactor,
                      margin: EdgeInsets.symmetric(
                          horizontal: width * (1 - responsiveWidthFactor) / 2),
                      padding: EdgeInsets.all(width > 600 ? 35 : 25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(width > 600 ? 30 : 25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: width > 600 ? 2.0 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: width > 600 ? 25 : 20,
                            offset: Offset(0, width > 600 ? 10 : 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Enhanced circular image container with shimmer effect
                          Container(
                            width: responsiveImageSize,
                            height: responsiveImageSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: width > 600 ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.3),
                                  blurRadius: width > 600 ? 20 : 15,
                                  offset: Offset(0, width > 600 ? 8 : 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CldImageWidget(
                                publicId: widget.designImage,
                                width: responsiveImageSize,
                                height: responsiveImageSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: width > 600 ? 30 : 25),
                          Text(
                            widget.designTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width > 600 ? 28 : 24,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: width > 600 ? 20 : 15),
                          // Status badge with hover effect
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                // Could add hover effect if needed
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width > 600 ? 20 : 15,
                                  vertical: width > 600 ? 10 : 8),
                              decoration: BoxDecoration(
                                color: widget.designStatus.toLowerCase() ==
                                        'available'
                                    ? TColor.primary.withOpacity(0.3)
                                    : Colors.redAccent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.designStatus.toLowerCase() ==
                                          'available'
                                      ? TColor.primary.withOpacity(0.7)
                                      : Colors.redAccent.withOpacity(0.7),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.designStatus.toUpperCase(),
                                style: TextStyle(
                                  color: widget.designStatus.toLowerCase() ==
                                          'available'
                                      ? TColor.white
                                      : Colors.redAccent.shade100,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width > 600 ? 16 : 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Design information section with modern cards
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                    width: width * responsiveWidthFactor,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Design Information",
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width > 600 ? 26 : 22,
                          ),
                        ),
                        SizedBox(height: width > 600 ? 25 : 20),
                        // Modern info tiles in a creative layout
                        Container(
                          padding: EdgeInsets.all(width > 600 ? 25 : 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(width > 600 ? 25 : 20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: width > 600 ? 20 : 15,
                                offset: Offset(0, width > 600 ? 10 : 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildCreativeInfoCard("Designer Name",
                                  widget.designerName, Icons.person, width),
                              SizedBox(height: width > 600 ? 20 : 15),
                              _buildCreativeInfoCard(
                                  "Status",
                                  widget.designStatus,
                                  widget.designStatus.toLowerCase() ==
                                          'available'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  width),
                              SizedBox(height: width > 600 ? 20 : 15),
                              _buildCreativeInfoCard("Color",
                                  widget.designColor, Icons.color_lens, width),
                              SizedBox(height: width > 600 ? 20 : 15),
                              _buildCreativeInfoCard("Fabric",
                                  widget.designFabric, Icons.texture, width),
                              SizedBox(height: width > 600 ? 20 : 15),
                              _buildCreativeInfoCard(
                                  "Price",
                                  "${widget.designPrice} SR",
                                  Icons.attach_money,
                                  width),
                              SizedBox(height: width > 600 ? 20 : 15),
                              _buildCreativeInfoCard("Size", widget.designSize,
                                  Icons.straighten, width),
                              SizedBox(height: width > 600 ? 20 : 15),
                              _buildCreativeInfoCard(
                                  "Design ID",
                                  widget.designID,
                                  Icons.confirmation_number,
                                  width),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Comments section with enhanced styling
                FadeInUp(
                  delay: Duration(milliseconds: 600),
                  child: Container(
                    width: width * responsiveWidthFactor,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Comments",
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width > 600 ? 26 : 22,
                          ),
                        ),
                        SizedBox(height: width > 600 ? 25 : 20),
                        GestureDetector(
                          onTap: () {
                            Get.to(DesignCommentView(
                              designId: widget.designID,
                              designImage: widget.designImage,
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: width > 600 ? 20 : 18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  TColor.primary.withOpacity(0.7),
                                  TColor.primary.withOpacity(0.4),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  color: TColor.white,
                                  size: width > 600 ? 26 : 22,
                                ),
                                SizedBox(width: width > 600 ? 15 : 12),
                                Text(
                                  "View All Comments",
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontSize: width > 600 ? 20 : 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: width > 600 ? 12 : 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: TColor.white,
                                  size: width > 600 ? 22 : 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: width > 600 ? 70 : 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Creative info card with icon and interactive elements
  Widget _buildCreativeInfoCard(
      String label, String value, IconData icon, double screenWidth) {
    return GestureDetector(
      onTap: () {
        // Copy to clipboard feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label copied to clipboard!'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth > 600 ? 20 : 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColor.primary.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: TColor.white,
                size: screenWidth > 600 ? 24 : 20,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 16 : 14,
                      color: TColor.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 18 : 16,
                      color: TColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.copy,
              color: TColor.white.withOpacity(0.5),
              size: screenWidth > 600 ? 20 : 18,
            ),
          ],
        ),
      ),
    );
  }
}
