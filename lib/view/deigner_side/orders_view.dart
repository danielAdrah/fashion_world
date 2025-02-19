// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:fashion_world/common_widget/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/store_controller.dart';
import '../../theme.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final storeController = Get.put(StoreController());
  @override
  void initState() {
    storeController.fetchOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                SizedBox(height: 20),
                CustomAppBar(),
                SizedBox(height: 20),
                storeController.designerOrders.isEmpty
                    ? Center(
                        child: Text(
                        "You don't have any orders yet",
                        style: TextStyle(
                            color: TColor.white, fontWeight: FontWeight.w700),
                      ))
                    : SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: storeController.designerOrders.length,
                            itemBuilder: (context, index) {
                              var order = storeController.designerOrders[index];
                              return FadeInDown(
                                delay: Duration(milliseconds: 600),
                                child: OrderTile(
                                  orderName: order['customerName'],
                                  acceptOnTap: () {},
                                  rejectOnTap: () {},
                                ),
                              );
                            }),
                      ),
              ],
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
        child: Text(title),
      ),
    );
  }
}
