// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_world/common_widget/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/store_controller.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final notiService = NotificationService();
  final storeController = Get.put(StoreController());
  String? customerToken;

  sendAndStoreNotifications(
      String body, title, customerId, customerName, token) async {
    try {
      notiService.sendNotifications(body, title, token);

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
      print("after adding to thr noti collection");
    } catch (e) {
      print("errorrrrrrrrrrrrrrr $e");
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
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/img/bg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [
                  SizedBox(height: 20),
                  CustomAppBar(),
                  SizedBox(height: 20),
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
                                    fontSize: 16),
                              )),
                              SizedBox(height: 20),
                              SvgPicture.asset(
                                'assets/img/notAvailableYet.svg',
                                width: 200,
                                height: 200,
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
                                var order =
                                    storeController.designerOrders[index];
                                return FadeInDown(
                                  delay: Duration(milliseconds: 600),
                                  child: OrderTile(
                                    orderName: order['customerName'],
                                    acceptOnTap: () async {
                                      final docSnap = await firestore
                                          .collection('users')
                                          .doc(order['customerId'])
                                          .get();
                                      if (docSnap.exists) {
                                        customerToken = docSnap.get('token');
                                      }
                                      print("==============$customerToken");

                                      sendAndStoreNotifications(
                                        'Your ${order['designName']} Order Is Accepted',
                                        'Order',
                                        order['customerId'],
                                        order['customerName'],
                                        customerToken,
                                      );
                                      storeController.deleteOrder(order.id);
                                    },
                                    rejectOnTap: () async {
                                      final docSnap = await firestore
                                          .collection('users')
                                          .doc(order['customerId'])
                                          .get();
                                      if (docSnap.exists) {
                                        customerToken = docSnap.get('token');
                                      }
                                      print("==============$customerToken");
                                      sendAndStoreNotifications(
                                        'Your ${order['designName']} Order Is Rejected',
                                        'Order',
                                        order['customerId'],
                                        order['customerName'],
                                        customerToken,
                                      );
                                      storeController.deleteOrder(order.id);
                                    },
                                  ),
                                );
                              }),
                        ),
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
    this.acceptOnTap,
    this.rejectOnTap,
  });
  final String orderName;
  final void Function()? acceptOnTap;
  final void Function()? rejectOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35, left: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 212, 210, 210),
            radius: 30,
            child: Icon(
              Icons.person_2_outlined,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You have an order from $orderName",
                style:
                    TextStyle(color: TColor.white, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  OrderButton(
                    title: "Accept",
                    onTap: acceptOnTap,
                  ),
                  SizedBox(width: 10),
                  OrderButton(
                    title: "Reject",
                    onTap: rejectOnTap,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//=========
class OrderButton extends StatelessWidget {
  const OrderButton({
    super.key,
    required this.title,
    this.onTap,
  });
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: TColor.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(color: TColor.white),
        ),
      ),
    );
  }
}
