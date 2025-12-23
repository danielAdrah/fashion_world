// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/common_widget/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/custom_appBar.dart';
import '../../common_widget/design_info_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'chat_page.dart';
import 'customer_payment_view.dart';
import 'design_comment_view.dart';
import 'update_personal_info.dart';

class DesginDetail extends StatefulWidget {
  const DesginDetail({
    super.key,
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
    required this.designerName,
  });
  final String designID;
  final String designerName;
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
  State<DesginDetail> createState() => _DesginDetailState();
}

class _DesginDetailState extends State<DesginDetail>
    with SingleTickerProviderStateMixin {
  final commentController = TextEditingController();
  final storeController = Get.put(StoreController());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    commentController.dispose();
    super.dispose();
  }

  postComment() async {
    if (commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    try {
      await storeController.sendComment(
          widget.designID, commentController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your comment has been posted')),
      );
      commentController.clear();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment')),
      );
    }
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
                          SizedBox(height: width > 600 ? 15 : 10),
                          Text(
                            "by ${widget.designerName}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.9),
                              fontSize: width > 600 ? 20 : 18,
                              fontWeight: FontWeight.w500,
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
                        // Modern info tiles in a grid layout
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
                // Enhanced contact designer button with ripple effect
                FadeInUp(
                  delay: Duration(milliseconds: 550),
                  child: Container(
                    width: width * responsiveWidthFactor,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(ChatPage(
                          receiverID: widget.designerID,
                          receiverName: widget.designerName,
                        ));
                      },
                      icon: Icon(
                        Icons.chat_outlined,
                        color: TColor.white,
                        size: width > 600 ? 26 : 22,
                      ),
                      label: Text(
                        "Contact Designer",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: width > 600 ? 20 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(
                            vertical: width > 600 ? 22 : 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: TColor.primary.withOpacity(0.4),
                        animationDuration: Duration(milliseconds: 300),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return TColor.primary.withOpacity(0.5);
                            return Colors.transparent;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Comment section with modern input and display
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
                              // Modern comment input with character counter
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction:
                                            TextInputAction.newline,
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: width > 600 ? 18 : 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Add your comment...",
                                          hintStyle: TextStyle(
                                            color:
                                                TColor.white.withOpacity(0.7),
                                            fontSize: width > 600 ? 18 : 16,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: width > 600 ? 25 : 20,
                                            vertical: width > 600 ? 20 : 15,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    // Character counter
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width > 600 ? 15 : 10,
                                        vertical: width > 600 ? 10 : 5,
                                      ),
                                      child: Text(
                                        "${commentController.text.length}/280",
                                        style: TextStyle(
                                          color: TColor.white.withOpacity(0.7),
                                          fontSize: width > 600 ? 14 : 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width > 600 ? 15 : 10),
                                    // Enhanced send button with loading indicator
                                    GestureDetector(
                                      onTap: postComment,
                                      child: Container(
                                        width: width > 600 ? 60 : 50,
                                        height: width > 600 ? 60 : 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: TColor.primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: TColor.primary
                                                  .withOpacity(0.4),
                                              blurRadius: 10,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.send,
                                          color: TColor.white,
                                          size: width > 600 ? 28 : 24,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width > 600 ? 15 : 10),
                                  ],
                                ),
                              ),
                              SizedBox(height: width > 600 ? 20 : 15),
                              // Recent comments preview
                              Container(
                                height: width > 600 ? 150 : 120,
                                child: FutureBuilder(
                                  future: _getRecentComments(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            TColor.primary,
                                          ),
                                        ),
                                      );
                                    }

                                    if (snapshot.hasData &&
                                        snapshot.data!.isNotEmpty) {
                                      var comments = snapshot.data!;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: comments.length > 3
                                            ? 3
                                            : comments.length,
                                        itemBuilder: (context, index) {
                                          var comment = comments[index];
                                          return Container(
                                            width: width > 600 ? 250 : 200,
                                            margin: EdgeInsets.only(
                                                right: width > 600 ? 20 : 15),
                                            padding: EdgeInsets.all(
                                                width > 600 ? 20 : 15),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  comment['user'] ??
                                                      'Anonymous',
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        width > 600 ? 16 : 14,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        width > 600 ? 10 : 5),
                                                Expanded(
                                                  child: Text(
                                                    comment['content'] ?? '',
                                                    style: TextStyle(
                                                      color: TColor.white
                                                          .withOpacity(0.9),
                                                      fontSize:
                                                          width > 600 ? 15 : 13,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }

                                    return Center(
                                      child: Text(
                                        "No comments yet. Be the first to comment!",
                                        style: TextStyle(
                                          color: TColor.white.withOpacity(0.7),
                                          fontStyle: FontStyle.italic,
                                          fontSize: width > 600 ? 16 : 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: width > 600 ? 20 : 15),
                              // View all comments button with modern styling
                              GestureDetector(
                                onTap: () {
                                  Get.to(DesignCommentView(
                                    designId: widget.designID,
                                    designImage: widget.designImage,
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width > 600 ? 20 : 15),
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: responsiveSectionSpacing),
                // Action buttons with enhanced styling and press effects
                FadeInUp(
                  delay: Duration(milliseconds: 650),
                  child: Container(
                    width: width * responsiveWidthFactor,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * (1 - responsiveWidthFactor) / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            title: "Order Now",
                            onTap: () {
                              if (widget.designStatus == "available") {
                                print(
                                    "Navigating to payment view with design image: '${widget.designImage}'");
                                Get.to(CustomerPaymentView(
                                  designerID: widget.designerID,
                                  designName: widget.designName,
                                  designStatus: widget.designStatus,
                                  designId: widget.designID,
                                  designImage: widget.designImage,
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'This design is not available anymore!'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            isPrimary: true,
                            width: width,
                          ),
                        ),
                        SizedBox(width: width > 600 ? 30 : 20),
                        Expanded(
                          child: _buildActionButton(
                            title: "Cancel",
                            onTap: () {
                              Get.back();
                            },
                            isPrimary: false,
                            width: width,
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

  // Helper method to build info rows with modern styling
  Widget _buildInfoRow(String label, String value, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth > 600 ? 140 : 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: TColor.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: TColor.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
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

  // Helper method to build action buttons with enhanced styling and press effects
  Widget _buildActionButton({
    required String title,
    required VoidCallback onTap,
    required bool isPrimary,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: width > 600 ? 22 : 18),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    TColor.primary.withOpacity(0.9),
                    TColor.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? TColor.primary.withOpacity(0.4)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isPrimary ? Colors.white : TColor.white.withOpacity(0.9),
              fontSize: width > 600 ? 20 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get recent comments
  Future<List<Map<String, dynamic>>> _getRecentComments() async {
    try {
      var snapshot = await storeController.firestore
          .collection('designes')
          .doc(widget.designID)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching recent comments: $e');
      return [];
    }
  }
}
