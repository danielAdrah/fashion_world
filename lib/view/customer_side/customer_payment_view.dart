// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, body_might_complete_normally_nullable

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/custom_textField.dart';
import '../../controller/store_controller.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';
import 'update_personal_info.dart';

class CustomerPaymentView extends StatefulWidget {
  const CustomerPaymentView({
    super.key,
    required this.designerID,
    required this.designName,
    required this.designStatus,
    required this.designId,
  });

  final String designerID;
  final String designName;
  final String designStatus;
  final String designId;

  @override
  State<CustomerPaymentView> createState() => _CustomerPaymentViewState();
}

class _CustomerPaymentViewState extends State<CustomerPaymentView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final notiService = NotificationService();
  final storeController = Get.put(StoreController());
  final customerName = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final cardID = TextEditingController();
  final amount = TextEditingController();

  clearField() {
    customerName.clear();
    cardID.clear();
    amount.clear();
  }

  //====
  changeDesignStatus() async {
    FirebaseFirestore.instance
        .collection('designes')
        .doc(widget.designId)
        .update({
      'status': 'unavailable',
    });
  }

  //======
  fetchDesignerToken() async {
    final docSnap =
        await firestore.collection('users').doc(widget.designerID).get();
    if (docSnap.exists) {
      // userName.value = docSnap.get('name');
      storeController.designerToken.value = docSnap.get('token');
    }
  }

  //======
  sendAndStoreNotifications(String body, title) async {
    try {
      notiService.sendNotifications(
          body, title, storeController.designerToken.value);

      //store the notification
      await firestore
          .collection('users')
          .doc(widget.designerID)
          .collection('notifications')
          .add({
        'title': title,
        'body': body,
        'customerName': customerName.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("after adding");
    } catch (e) {
      print("errorrrrrrrrrrrrrrr $e");
    }
  }

  //====
  sendOrder() async {
    try {
      storeController.createOrder(customerName.text, widget.designName,
          widget.designerID, cardID.text, amount.text);

      changeDesignStatus();
    } catch (e) {
      print(e);
    }
  }

  //===
  @override
  void initState() {
    fetchDesignerToken();
    super.initState();
  }

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
                TColor.background.withOpacity(0.9),
                TColor.primary.withOpacity(0.6),
              ],
            ),
            image: DecorationImage(
              image: AssetImage("assets/img/bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
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
                // Header section
                FadeInDown(
                  delay: Duration(milliseconds: 300),
                  child: Container(
                    width: width * 0.9,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
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
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TColor.primary.withOpacity(0.2),
                          ),
                          child: Icon(
                            Icons.payment,
                            size: 50,
                            color: TColor.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Complete Your Payment",
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Please enter your payment information to complete the purchase of ${widget.designName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Payment form section
                FadeInUp(
                  delay: Duration(milliseconds: 400),
                  child: Container(
                    width: width * 0.9,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Information",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Customer Name",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            hinttext: "Enter your full name",
                            mycontroller: customerName,
                            secure: false,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: TColor.primary,
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Customer name can't be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Card ID",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            hinttext: "Enter your card ID",
                            mycontroller: cardID,
                            secure: false,
                            prefixIcon: Icon(
                              Icons.credit_card_outlined,
                              color: TColor.primary,
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Card ID can't be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Amount",
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextForm(
                            hinttext: "Enter payment amount",
                            mycontroller: amount,
                            secure: false,
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: TColor.primary,
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Amount can't be empty";
                              }
                              if (double.tryParse(val) == null) {
                                return "Please enter a valid amount";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Action buttons
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                    width: width * 0.9,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ProfileBtn(
                            title: "Pay Now",
                            onTap: () {
                              if (formState.currentState!.validate()) {
                                print(
                                    " designer iddddddddddd ${widget.designerID}");
                                print(
                                    "=====================${storeController.designerToken.value}");

                                sendAndStoreNotifications(
                                    'You Have Received A New Order',
                                    "Order Request");
                                sendOrder();
                                clearField();

                                // Show success dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: TColor.background,
                                      title: Text(
                                        "Payment Successful!",
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "Your payment has been processed successfully. The designer will be notified of your order.",
                                        style: TextStyle(
                                          color: TColor.white.withOpacity(0.9),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Get.back();
                                          },
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                              color: TColor.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                print("Validation failed");
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ProfileBtn(
                            title: "Cancel",
                            onTap: () {
                              clearField();
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
