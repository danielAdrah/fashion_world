// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_world/common_widget/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/store_controller.dart';
import '../../models/cart_item.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storeController =
      Get.find<StoreController>(); // Use existing controller
  String? customerToken;

  // Add a method to update cart item status
  Future<void> updateCartItemStatus(
      String customerId, String designId, String status) async {
    try {
      print(
          "Updating cart item status for customer: $customerId, design: $designId, status: $status");

      final cartItemsSnapshot = await firestore
          .collection('cart')
          .doc(customerId)
          .collection('items')
          .where('designId', isEqualTo: designId)
          .get();

      print("Found ${cartItemsSnapshot.docs.length} cart items to update");

      for (var doc in cartItemsSnapshot.docs) {
        await firestore
            .collection('cart')
            .doc(customerId)
            .collection('items')
            .doc(doc.id)
            .update({'status': status});
        print("Updated cart item ${doc.id} status to $status");
      }
    } catch (e) {
      print("Error updating cart item status: $e");
    }
  }

  // Add a method to update design status
  Future<void> updateDesignStatus(String designId, String status) async {
    try {
      print("Updating design status for design: $designId, status: $status");
      await firestore
          .collection('designes')
          .doc(designId)
          .update({'status': status});
      print("Updated design status successfully");
    } catch (e) {
      print("Error updating design status: $e");
    }
  }

  sendAndStoreNotifications(
      String body, title, customerId, customerName, token) async {
    try {
      // Use the notification service from StoreController
      await storeController.notificationService
          .sendNotifications(body, title, token);

      //store the notification
      await firestore
          .collection('users')
          .doc(customerId)
          .collection('notifications')
          .add({
        'title': title,
        'body': body,
        'customerName': customerName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("after adding to the notification collection");
    } catch (e) {
      print("Error in sendAndStoreNotifications: $e");
    }
  }

  @override
  void initState() {
    storeController.fetchOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Responsive sizing
    double responsiveWidthFactor = width > 600 ? 0.7 : 0.9;
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
            child: Obx(
              () => Column(
                children: [
                  SizedBox(height: 20),
                  CustomAppBar(),
                  SizedBox(height: 30),
                  FadeInDown(
                    delay: Duration(milliseconds: 300),
                    child: Text(
                      "Order Requests",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 600 ? 30 : 24,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: responsiveSectionSpacing),
                  storeController.designerOrders.isEmpty
                      ? FadeInDown(
                          delay: Duration(milliseconds: 400),
                          child: Column(
                            children: [
                              SizedBox(height: 60),
                              Center(
                                child: Text(
                                  "You don't have any orders yet",
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
                                "New orders will appear here when customers place them",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.8),
                                  fontSize: width > 600 ? 18 : 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: storeController.designerOrders.length,
                            itemBuilder: (context, index) {
                              var order = storeController.designerOrders[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: 200 * index),
                                child: OrderTile(
                                  orderName: order['customerName'],
                                  designName: order['designName'],
                                  orderId: order.id,
                                  acceptOnTap: () async {
                                    final docSnap = await firestore
                                        .collection('users')
                                        .doc(order['customerId'])
                                        .get();
                                    if (docSnap.exists) {
                                      customerToken = docSnap.get('token');
                                    }
                                    print("Customer token: $customerToken");

                                    // Update cart item status to confirmed
                                    await updateCartItemStatus(
                                        order['customerId'],
                                        order['designId'] ?? '',
                                        'confirmed');

                                    // Update design status to unavailable
                                    await updateDesignStatus(
                                        order['designId'] ?? '', 'unavailable');

                                    sendAndStoreNotifications(
                                      'Your ${order['designName']} Order Is Accepted',
                                      'Order Accepted',
                                      order['customerId'],
                                      order['customerName'],
                                      customerToken ?? '',
                                    );
                                    storeController.deleteOrder(order.id);

                                    // Show success snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Order accepted and customer notified'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  rejectOnTap: () async {
                                    final docSnap = await firestore
                                        .collection('users')
                                        .doc(order['customerId'])
                                        .get();
                                    if (docSnap.exists) {
                                      customerToken = docSnap.get('token');
                                    }
                                    print("Customer token: $customerToken");

                                    // Update cart item status to rejected
                                    await updateCartItemStatus(
                                        order['customerId'],
                                        order['designId'] ?? '',
                                        'rejected');

                                    sendAndStoreNotifications(
                                      'Your ${order['designName']} Order Is Rejected',
                                      'Order Rejected',
                                      order['customerId'],
                                      order['customerName'],
                                      customerToken ?? '',
                                    );
                                    storeController.deleteOrder(order.id);

                                    // Show success snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Order rejected and customer notified'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//==========
class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.orderName,
    required this.designName,
    required this.orderId,
    this.acceptOnTap,
    this.rejectOnTap,
  });
  final String orderName;
  final String designName;
  final String orderId;
  final void Function()? acceptOnTap;
  final void Function()? rejectOnTap;

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
            // Header with customer avatar and name
            Row(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderName,
                        style: TextStyle(
                          color: TColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 600 ? 18 : 16,
                        ),
                      ),
                      Text(
                        "New Order Request",
                        style: TextStyle(
                          color: TColor.white.withOpacity(0.8),
                          fontSize: width > 600 ? 14 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "NEW",
                    style: TextStyle(
                      color: TColor.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: width > 600 ? 12 : 10,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Order details
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Design Requested",
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.8),
                      fontSize: width > 600 ? 14 : 12,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    designName,
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.w600,
                      fontSize: width > 600 ? 16 : 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Order ID: ${orderId.substring(0, orderId.length < 8 ? orderId.length : 8)}...",
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.7),
                      fontSize: width > 600 ? 12 : 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: acceptOnTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.7),
                            Colors.green.withOpacity(0.5),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: TColor.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Accept",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width > 600 ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: rejectOnTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.7),
                            Colors.red.withOpacity(0.5),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            color: TColor.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Reject",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width > 600 ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
