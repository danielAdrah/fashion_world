// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/custom_appBar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import '../auth_view/log_in.dart';
import 'update_personal_info.dart';

class CustomerProfileView extends StatefulWidget {
  const CustomerProfileView({super.key});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storeController = Get.put(StoreController());
  RxString userRole = ''.obs;
  Rx<DateTime?> accountCreationDate = Rx<DateTime?>(null);

  @override
  void initState() {
    storeController.fetchUserData();
    fetchAdditionalUserInfo();
    super.initState();
  }

  Future<void> fetchAdditionalUserInfo() async {
    try {
      final docSnap = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (docSnap.exists) {
        final data = docSnap.data() as Map<String, dynamic>;
        userRole.value = data['role'] ?? '';

        // Get account creation date from Firebase Auth
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          accountCreationDate.value = user.metadata.creationTime;
        }
      }
    } catch (e) {
      print("Error fetching additional user info: $e");
    }
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
            image: DecorationImage(
              image: const AssetImage("assets/img/bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const CustomAppBar(),
                  const SizedBox(height: 30),
                  // Profile header section
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                      padding: const EdgeInsets.all(25),
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
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: TColor.white,
                              radius: 60,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: TColor.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            storeController.userName.value.isEmpty
                                ? "User"
                                : storeController.userName.value,
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            storeController.userMail.value,
                            style: TextStyle(
                              color: TColor.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          Obx(() => userRole.value.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: TColor.primary.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: TColor.primary.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      userRole.value,
                                      style: TextStyle(
                                        color: TColor.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Personal information section
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                      padding: const EdgeInsets.all(25),
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
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Personal Information",
                                style: TextStyle(
                                  color: TColor.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Get.to(const UpdatePersonalInfo());
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: TColor.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                          const SizedBox(height: 20),
                          InfoTile(
                            onTap: () {},
                            name: "Full Name",
                            value: storeController.userName.value,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 20),
                          InfoTile(
                            onTap: () {},
                            name: "Email Address",
                            value: storeController.userMail.value,
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 20),
                          InfoTile(
                            onTap: () {},
                            name: "Phone Number",
                            value: storeController.userNumber.value,
                            icon: Icons.phone_outlined,
                          ),
                          Obx(() => accountCreationDate.value != null
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    InfoTile(
                                      onTap: () {},
                                      name: "Member Since",
                                      value:
                                          "${accountCreationDate.value!.day}/${accountCreationDate.value!.month}/${accountCreationDate.value!.year}",
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                  ],
                                )
                              : const SizedBox()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Other options section
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                      padding: const EdgeInsets.all(25),
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
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Options",
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                          const SizedBox(height: 20),
                          InfoTile2(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.off(const LogIn());
                            },
                            name: "Log Out",
                            value: "",
                            icon: Icons.logout,
                          ),
                          const SizedBox(height: 20),
                          InfoTile2(
                            onTap: () {
                              // TODO: Implement account deletion
                            },
                            name: "Delete Account",
                            value: "",
                            icon: Icons.delete_outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//=======to display user info
class InfoTile extends StatelessWidget {
  InfoTile({
    super.key,
    required this.name,
    required this.value,
    required this.onTap,
    this.icon,
  });
  final String name;
  final String value;
  void Function()? onTap;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: TColor.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: TextStyle(
                color: TColor.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? "Not provided" : value,
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

//=======
class InfoTile2 extends StatelessWidget {
  InfoTile2({
    super.key,
    required this.name,
    required this.value,
    required this.onTap,
    this.icon,
  });
  final String name;
  final String value;
  void Function()? onTap;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: TColor.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              name,
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: TColor.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
