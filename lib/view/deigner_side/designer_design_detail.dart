// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/custom_appBar.dart';
import '../../common_widget/design_info_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import '../customer_side/design_comment_view.dart';

class DesignerDesignDetail extends StatefulWidget {
  const DesignerDesignDetail(
      {super.key,
      required this.designID,
      required this.designerID,
      required this.designColor,
      required this.designFabric,
      required this.designPrice,
      required this.designSize,
      required this.designName,
      required this.designStatus,
      required this.designImage, required this.designTitle});
  final String designID;
  final String designerID;
  final String designColor;
  final String designFabric;
  final String designPrice;
  final String designSize;
  final String designName;
  final String designStatus;
  final String designImage;
  final String designTitle;

  @override
  State<DesignerDesignDetail> createState() => _DesignerDesignDetailState();
}

class _DesignerDesignDetailState extends State<DesignerDesignDetail> {
  final storeController = Get.put(StoreController());

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
            child: FadeInDown(
              delay: Duration(milliseconds: 600),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CustomAppBar(),
                  Text(
                    "Details of Design",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 160, 109, 137),
                          ),
                          child: CldImageWidget(
                            publicId: widget.designImage,
                            // width: 150,
                            // height: 150,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            widget.designTitle,
                            style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                 
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DesinInfoTile(
                          name: "Designer ID: ",
                          value: "${widget.designerID}".substring(0, 19),
                        ),
                        SizedBox(height: 15),
                        DesinInfoTile(
                          name: "Status: ",
                          value: widget.designStatus,
                        ),
                        SizedBox(height: 15),
                        DesinInfoTile(
                          name: "Color: ",
                          value: widget.designColor,
                        ),
                        SizedBox(height: 15),
                        DesinInfoTile(
                          name: "Fabric: ",
                          value: widget.designFabric,
                        ),
                        SizedBox(height: 15),
                        DesinInfoTile(
                          name: "Price: ",
                          value: "${widget.designPrice} SR",
                        ),
                        SizedBox(height: 15),
                        DesinInfoTile(
                          name: "Size: ",
                          value: widget.designSize,
                        ),
                        SizedBox(height: 15),
                        DesinInfoTile(
                          name: "Design ID: ",
                          value: widget.designID,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.to(DesignCommentView(
                        designId: widget.designID,
                        designImage: widget.designImage,
                      ));
                    },
                    child: Text(
                      "Show Comments",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 50),
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
