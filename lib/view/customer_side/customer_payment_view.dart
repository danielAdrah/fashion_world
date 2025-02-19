// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'update_personal_info.dart';

class CustomerPaymentView extends StatefulWidget {
  const CustomerPaymentView(
      {super.key, required this.designerID, required this.designName});

  final String designerID;
  final String designName;

  @override
  State<CustomerPaymentView> createState() => _CustomerPaymentViewState();
}

class _CustomerPaymentViewState extends State<CustomerPaymentView> {
  final storeController = Get.put(StoreController());
  final customerName = TextEditingController();
  final cardID = TextEditingController();
  final amount = TextEditingController();
  clearField() {
    customerName.clear();
    cardID.clear();
    amount.clear();
  }

  sendOrder() async {
    try {
      storeController.createOrder(customerName.text, widget.designName,
          widget.designerID, cardID.text, amount.text);
      clearField();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your order has been sent !')),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomAppBar(),
              SizedBox(height: 40),
              FadeInDown(
                delay: Duration(milliseconds: 500),
                child: Text(
                  "please enter the payment information\n to complete payment process",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      CustomTextForm(
                        hinttext: "Customer Name",
                        mycontroller: customerName,
                        secure: false,
                      ),
                      SizedBox(height: 40),
                      CustomTextForm(
                        hinttext: "Card ID",
                        mycontroller: cardID,
                        secure: false,
                      ),
                      SizedBox(height: 40),
                      CustomTextForm(
                        hinttext: "Amount",
                        mycontroller: amount,
                        secure: false,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              FadeInDown(
                delay: Duration(milliseconds: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileBtn(
                        title: "Pay",
                        onTap: () {
                          sendOrder();
                        }),
                    ProfileBtn(
                        title: "Cancel",
                        onTap: () {
                          Get.back();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
