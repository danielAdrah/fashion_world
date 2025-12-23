// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:fashion_world/common_widget/custom_appBar.dart';
import 'package:fashion_world/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final StoreController storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
                SizedBox(height: 20),
                CustomAppBar(),
                SizedBox(height: 30),
                FadeInDown(
                  delay: Duration(milliseconds: 300),
                  child: Text(
                    "My Shopping Cart",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width > 600 ? 30 : 24,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                StreamBuilder<List<CartItem>>(
                  stream: storeController.getCartItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(TColor.primary),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      print("Error loading cart items: ${snapshot.error}");
                      return Center(
                        child: Text(
                          'Error loading cart items: ${snapshot.error}',
                          style: TextStyle(color: TColor.white),
                        ),
                      );
                    }

                    final cartItems = snapshot.data ?? [];

                    if (cartItems.isEmpty) {
                      return FadeInDown(
                        delay: Duration(milliseconds: 400),
                        child: Column(
                          children: [
                            SizedBox(height: 60),
                            Center(
                              child: Text(
                                "Your cart is empty",
                                style: TextStyle(
                                  color: TColor.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width > 600 ? 20 : 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: width * 0.6,
                              height: width * 0.6,
                              child: SvgPicture.asset(
                                'assets/img/notAvailableYet.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Start shopping for amazing designs!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TColor.white.withOpacity(0.8),
                                fontSize: width > 600 ? 18 : 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 200 * index),
                            child: CartItemTile(cartItem: item),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with design image and name
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImageWidget(),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.designName,
                        style: TextStyle(
                          color: TColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 600 ? 18 : 16,
                        ),
                      ),
                      Text(
                        "by ${cartItem.designerName}",
                        style: TextStyle(
                          color: TColor.white.withOpacity(0.8),
                          fontSize: width > 600 ? 14 : 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${cartItem.price.toStringAsFixed(2)} SR",
                        style: TextStyle(
                          color: TColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 600 ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Status badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: cartItem.status == 'pending'
                    ? Colors.orange.withOpacity(0.2)
                    : cartItem.status == 'confirmed'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: cartItem.status == 'pending'
                      ? Colors.orange.withOpacity(0.5)
                      : cartItem.status == 'confirmed'
                          ? Colors.green.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cartItem.status == 'pending'
                        ? Icons.access_time
                        : cartItem.status == 'confirmed'
                            ? Icons.check_circle
                            : Icons.cancel,
                    color: cartItem.status == 'pending'
                        ? Colors.orange
                        : cartItem.status == 'confirmed'
                            ? Colors.green
                            : Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    cartItem.status.toUpperCase(),
                    style: TextStyle(
                      color: cartItem.status == 'pending'
                          ? Colors.orange
                          : cartItem.status == 'confirmed'
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: width > 600 ? 12 : 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Order date
            Text(
              "Ordered on: ${_formatDate(cartItem.timestamp)}",
              style: TextStyle(
                color: TColor.white.withOpacity(0.7),
                fontSize: width > 600 ? 12 : 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    print("Building image widget for cart item: ${cartItem.id}");
    print("Image URL: '${cartItem.imageUrl}'");
    print("Image URL length: ${cartItem.imageUrl.length}");
    print("Image URL is empty: ${cartItem.imageUrl.isEmpty}");

    // Check if imageUrl is valid
    if (cartItem.imageUrl.isEmpty) {
      print("Image URL is empty, showing placeholder");
      return _buildPlaceholderImage();
    }

    // Check if it's a Cloudinary URL
    if (cartItem.imageUrl.contains('cloudinary.com')) {
      print("Detected Cloudinary URL");
      // If it's already a full URL, try to extract the public ID
      if (cartItem.imageUrl.startsWith('http')) {
        try {
          final uri = Uri.parse(cartItem.imageUrl);
          print("Parsed URI: $uri");
          print("Path segments: ${uri.pathSegments}");

          if (uri.pathSegments.length >= 2) {
            // Extract public ID (last segment without extension)
            final fileName = uri.pathSegments.last;
            final publicId = fileName.split('.').first;
            print("Extracted public ID: '$publicId'");

            if (publicId.isNotEmpty) {
              print("Creating CldImageWidget with public ID: '$publicId'");
              return CldImageWidget(
                publicId: publicId,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              );
            } else {
              print("Public ID is empty after extraction");
            }
          } else {
            print("Not enough path segments in URL");
          }
        } catch (e) {
          print("Error parsing Cloudinary URL: $e");
          return _buildPlaceholderImage();
        }
      }
    }

    // If it looks like a public ID, use it directly
    if (!cartItem.imageUrl.contains('http') &&
        !cartItem.imageUrl.contains('?_a=') &&
        cartItem.imageUrl.isNotEmpty) {
      print("Using image URL as public ID directly: '${cartItem.imageUrl}'");
      return CldImageWidget(
        publicId: cartItem.imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }

    // Try to load as a regular network image as fallback
    try {
      if (cartItem.imageUrl.startsWith('http')) {
        print("Trying to load as network image: '${cartItem.imageUrl}'");
        return Image.network(
          cartItem.imageUrl,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading network image: $error");
            return _buildPlaceholderImage();
          },
        );
      }
    } catch (e) {
      print("Error loading network image: $e");
    }

    // Fallback to placeholder
    print("Showing placeholder image as fallback");
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    print("Building placeholder image");
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: Icon(
        Icons.image_not_supported,
        color: TColor.white.withOpacity(0.5),
        size: 30,
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}
