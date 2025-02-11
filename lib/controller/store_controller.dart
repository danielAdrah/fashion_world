// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<QueryDocumentSnapshot> allDesignes = <QueryDocumentSnapshot>[].obs;
  //=====
  RxBool addDesignLoading = false.obs;
  //=====

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
}
