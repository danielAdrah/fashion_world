// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<QueryDocumentSnapshot> allDesignes = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> designerOrders = <QueryDocumentSnapshot>[].obs;
  //=====
  RxString userName = ''.obs;
  RxString userMail = ''.obs;
  RxString userNumber = ''.obs;
  RxBool addDesignLoading = false.obs;
  //=====

//=====FETCH USER INFO
  Future<void> fetchUserData() async {
    final docSnap = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (docSnap.exists) {
      userName.value = docSnap.get('name');
      userMail.value = docSnap.get('email');
      userNumber.value = docSnap.get('phoneNumber');
    }
  }

//=====ADD A NEW DESIGN
  Future<void> addDesign(
      String title, price, fabric, color, size, BuildContext context) async {
    try {
      addDesignLoading.value = true;
      DocumentReference response = await firestore.collection('designes').add({
        'title': title,
        'price': price,
        'fabric': fabric,
        'color': color,
        'size': size,
        'desingerID': FirebaseAuth.instance.currentUser!.uid,
      });
      addDesignLoading.value = false;
      await fetchDesinges();
      print("done adding");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Designe added successfully')),
      );
    } catch (e) {
      addDesignLoading.value = false;
      print(e.toString());
    }
  }

//=====FETCH ALL DESINES
  Future<void> fetchDesinges() async {
    try {
      QuerySnapshot data = await firestore.collection('designes').get();
      allDesignes.value = data.docs;
      print("number of designes are ${allDesignes.length}");
    } catch (e) {
      print(e.toString());
    }
  }

//======POST A NEWS
  Future<void> addNews(String newsContent) async {
    try {
      DocumentReference response = await firestore.collection('news').add({
        'user': FirebaseAuth.instance.currentUser!.email,
        'content': newsContent,
        'timestamp': Timestamp.now(),
      });
      fetchNews();
      print("done news");
    } catch (e) {
      print(e.toString());
    }
  }

  //=====FETCH THE NEWS
  Stream<List<Map<String, dynamic>>> fetchNews() {
    return firestore
        .collection("news")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final news = doc.data();
        return news;
      }).toList();
    });
  }

  //=====UPDATE USER INFO
  updateUserInfo(BuildContext context, String newName, newNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'name': newName,
        'phoneNumber': newNumber,
      });
      fetchUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your information has been updated')),
      );
      print("done update");
    } catch (e) {
      print(e.toString());
    }
  }

//=======CREATE ORDER AND PAYMENT
  createOrder(
    String customerName,
    designName,
    designerID,
    cardID,
    amount,
  ) async {
    try {
      DocumentReference response = await firestore.collection('orders').add({
        'customerName': customerName,
        'designName': designName,
        'designerId': designerID,
        'customerId': auth.currentUser!.uid,
      });
      print("order sent");
      DocumentReference paymentRef = firestore
          .collection('orders')
          .doc(response.id)
          .collection('payment')
          .doc();
      await paymentRef.set({
        'customerName': customerName,
        'transactionId': paymentRef.id,
        'cardId': cardID,
        'amount': amount,
        'timestamp': Timestamp.now(),
      });
      print("done payment");
    } catch (e) {
      print(e.toString());
    }
  }

//========POST A COMMENT
  sendComment(String designId, content) async {
    try {
      DocumentReference response = await firestore
          .collection('designes')
          .doc(designId)
          .collection('comments')
          .add({
        'user': FirebaseAuth.instance.currentUser!.email,
        'content': content,
        'timestamp': Timestamp.now(),
      });
      print("comment sent");
    } catch (e) {
      print(e);
    }
  }

//========FETCH COMMENTS
  Stream<List<Map<String, dynamic>>> fetchComments(String designId) {
    return firestore
        .collection("designes")
        .doc(designId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final news = doc.data();
        return news;
      }).toList();
    });
  }

//=======FETCH ORDERS FOR EACH DESIGNER
  Future<void> fetchOrder() async {
    try {
      
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("orders")
          .where("designerId",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      print('Number of orders fetched: ${data.docs.length}');
      designerOrders.value = data.docs;
    } catch (e) {
      print(e);
    }
  }
}
