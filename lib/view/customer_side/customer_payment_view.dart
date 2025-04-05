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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your order has been sent !')),
      );
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
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          CustomTextForm(
                            hinttext: "Customer Name",
                            mycontroller: customerName,
                            secure: false,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 40),
                          CustomTextForm(
                            hinttext: "Card ID",
                            mycontroller: cardID,
                            secure: false,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 40),
                          CustomTextForm(
                            hinttext: "Amount",
                            mycontroller: amount,
                            secure: false,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
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
                            } else {
                              print("noo");
                            }
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
      ),
    );
  }
}
