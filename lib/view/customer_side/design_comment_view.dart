// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/custom_appBar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class DesignCommentView extends StatefulWidget {
  const DesignCommentView(
      {super.key, required this.designId, required this.designImage});
  final String designId;
  final String designImage;

  @override
  State<DesignCommentView> createState() => _DesignCommentViewState();
}

class _DesignCommentViewState extends State<DesignCommentView> {
  final commentController = TextEditingController();
  final storeController = Get.put(StoreController());
  @override
  void initState() {
    storeController.fetchListComments(widget.designId);
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
                  SizedBox(height: 4),
                  CustomAppBar(),
                  FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInDown(
                    delay: Duration(milliseconds: 600),
                    child: Container(
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
                  ),
                  SizedBox(height: 60),
                  storeController.comments.isEmpty
                      ? Center(
                          child: FadeInDown(
                            delay: Duration(milliseconds: 650),
                            child: Text(
                              'There are no comments yet!',
                              style: TextStyle(
                                  color: TColor.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: FadeInDown(
                            delay: Duration(milliseconds: 700),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: StreamBuilder(
                                        stream: storeController
                                            .fetchComments(widget.designId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: TColor.primary));
                                          }
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: Text(
                                                "There are no news yet",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                var comment =
                                                    snapshot.data![index];
                                                return CommentTile(
                                                  name: comment['user'],
                                                  content: comment['content'],
                                                );
                                              });
                                        })
                                    //
                                    ),
                                // SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//===to display comments
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.name,
    required this.content,
  });
  final String name;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
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
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: TColor.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
