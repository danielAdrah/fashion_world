// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../services/notification_service.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final NotificationService notificationService = NotificationService();
  RxList<QueryDocumentSnapshot> allDesignes = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> designerOrders = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> comments = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> allNotifications =
      <QueryDocumentSnapshot>[].obs;
  //=====
  RxString userName = ''.obs;
  RxString userMail = ''.obs;
  RxString userNumber = ''.obs;
  RxString designerToken = ''.obs;
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
  Future<void> addDesign(String title, price, fabric, color, size, imageUrl,
      designerName, BuildContext context) async {
    try {
      addDesignLoading.value = true;
      DocumentReference response = await firestore.collection('designes').add({
        'title': title,
        'price': price,
        'fabric': fabric,
        'color': color,
        'size': size,
        'imageUrl': imageUrl,
        'status': 'available',
        'desingerID': FirebaseAuth.instance.currentUser!.uid,
        'desingerName': designerName,
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
  Future<void> addNews(String newsContent, newsImage, userName) async {
    try {
      DocumentReference response = await firestore.collection('news').add({
        // 'user': FirebaseAuth.instance.currentUser!.email,
        'user': userName,
        'content': newsContent,
        'image': newsImage,
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
    String designId, // Add this parameter
  ) async {
    try {
      DocumentReference response = await firestore.collection('orders').add({
        'customerName': customerName,
        'designName': designName,
        'designerId': designerID,
        'customerId': auth.currentUser!.uid,
        'designId': designId, // Add this line
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

//========
  Future<void> fetchListComments(String designId) async {
    try {
      QuerySnapshot data = await firestore
          .collection('designes')
          .doc(designId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();
      comments.value = data.docs;
      print("number of designes are ${comments.length}");
    } catch (e) {
      print(e.toString());
    }
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

//FETCH THE NOTIFICATION FOR EACH USER
  Future<void> fetchNotification() async {
    try {
      QuerySnapshot data = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();
      allNotifications.value = data.docs;
      print("number of designes are ${allNotifications.length}");
    } catch (e) {
      print(e);
    }
  }

  //======DELETE ORDER
  deleteOrder(String id) async {
    try {
      await firestore.collection('orders').doc(id).delete();
      print("done delete");
      fetchOrder();
    } catch (e) {
      print(e);
    }
  }

  // Add method to add item to cart
  Future<void> addToCart({
    required String designId,
    required String designName,
    required String designerId,
    required String designerName,
    required double price,
    required String imageUrl,
  }) async {
    try {
      final customerId = auth.currentUser!.uid;

      print("Adding item to cart:");
      print("  Design ID: $designId");
      print("  Design Name: $designName");
      print("  Designer ID: $designerId");
      print("  Designer Name: $designerName");
      print("  Price: $price");
      print("  Image URL (passed in): '$imageUrl'");

      // Always try to fetch the image URL from the design document to ensure we have the correct one
      String finalImageUrl = imageUrl;
      print("Fetching design document to get image URL");
      try {
        final designDoc =
            await firestore.collection('designes').doc(designId).get();
        if (designDoc.exists) {
          final fetchedImageUrl = designDoc.get('imageUrl') ?? '';
          print("Fetched image URL from design document: '$fetchedImageUrl'");
          if (fetchedImageUrl.isNotEmpty) {
            finalImageUrl = fetchedImageUrl;
            print("Using fetched image URL instead of passed one");
          } else {
            print("Fetched image URL is empty, using passed one: '$imageUrl'");
          }
        } else {
          print(
              "Design document does not exist, using passed image URL: '$imageUrl'");
        }
      } catch (e) {
        print("Error fetching design image URL: $e");
        print("Using passed image URL: '$imageUrl'");
      }

      final cartItemData = {
        'designId': designId,
        'designName': designName,
        'designerId': designerId,
        'designerName': designerName,
        'price': price,
        'status': 'pending',
        'timestamp': Timestamp.now(),
        'imageUrl': finalImageUrl,
      };

      print("Cart item data to be saved: $cartItemData");

      final docRef = await firestore
          .collection('cart')
          .doc(customerId)
          .collection('items')
          .add(cartItemData);

      print("Added to cart successfully with document ID: ${docRef.id}");
      print("Final image URL stored: '$finalImageUrl'");
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  // Fetch cart items
  Stream<List<CartItem>> getCartItems() {
    final customerId = auth.currentUser!.uid;
    print("Fetching cart items for customer: $customerId");

    return firestore
        .collection('cart')
        .doc(customerId)
        .collection('items')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print(
          "Received cart items snapshot with ${snapshot.docs.length} documents");
      final items = snapshot.docs.map((doc) {
        print("Processing cart item document: ${doc.id}");
        print("Document data: ${doc.data()}");
        final cartItem = CartItem.fromMap(doc.data(), doc.id);
        print("Created cart item with image URL: '${cartItem.imageUrl}'");
        return cartItem;
      }).toList();
      print("Returning ${items.length} cart items");
      return items;
    });
  }

  // Update cart item status (when designer accepts/rejects)
  Future<void> updateCartItemStatus(String itemId, String status) async {
    final customerId = auth.currentUser!.uid;

    await firestore
        .collection('cart')
        .doc(customerId)
        .collection('items')
        .doc(itemId)
        .update({'status': status});
  }

  // New method to notify customers about order status changes
  Future<void> notifyOrderStatusChange(
      String customerId, String orderStatus, String designName) async {
    await notificationService.notifyOrderStatusChange(
        customerId, orderStatus, designName);
  }
}
