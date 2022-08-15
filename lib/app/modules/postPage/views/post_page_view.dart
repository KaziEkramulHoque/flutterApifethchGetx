import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/post_page_controller.dart';

class PostPageView extends GetView<PostPageController> {
  final PostPageController _postController = Get.find<PostPageController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${_postController.userName}'s Posts",
            style: GoogleFonts.didactGothic(
              color: Color.fromARGB(255, 80, 78, 78),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 201, 17, 97),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 100, 98, 98),
          ),
        ),
        body: Obx(
          () => SafeArea(
            child: _postController.isInternet.isFalse
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            child: Text("No internet.Show Offline Data"),
                            onPressed: () {
                              _postController.isInternet.value = true;
                              _postController.getPost();
                              if (_postController.postList.isEmpty) {
                                _postController.isInternet.value = false;
                                Get.snackbar(
                                    "User Empty", "No Offline Data Found");
                              }
                            }),
                      ],
                    ),
                  )
                : _postController.isLoading.isTrue
                    ? Center(child: CircularProgressIndicator())
                    : _postController.isInternet.isTrue
                        ? ListView.builder(
                            itemBuilder: (context, index) => Card(
                              //final post = postList[index];
                              elevation: 6,
                              margin: const EdgeInsets.all(10),
                              color: Color.fromARGB(255, 100, 98, 98),
                              child: ListTile(
                                title: Text(
                                  _postController
                                      .postList[index].title.capitalize
                                      .toString(),

                                  //textAlign: TextAlign.justify,
                                  style: GoogleFonts.didactGothic(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 235, 29, 118),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  _postController.postList[index].body,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.didactGothic(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            itemCount: _postController.postList.length,
                          )
                        : Center(
                            child: Text("No User Object"),
                          ),
          ),
        ));
  }
}
