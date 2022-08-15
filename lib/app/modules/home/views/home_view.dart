import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pillar_test_getx/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final HomeController _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "U S E R S",
            style: GoogleFonts.didactGothic(
              color: Color.fromARGB(255, 100, 98, 98),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 201, 17, 97),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 100, 98, 98),
          ),
        ),
        body: Obx(
          () => _controller.isInternet.isFalse
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
                            _controller.isInternet.value = true;
                            _controller.getListUser();
                            if (_controller.userList.isEmpty) {
                              _controller.isInternet.value = false;
                              Get.snackbar(
                                  "User Empty", "No Offline Data Found");
                            }
                          }),
                    ],
                  ),
                )
              : _controller.isLoading.isTrue
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        _controller.isRefresh.value = true;
                        _controller.getListUser();
                      },
                      child: ListView.builder(
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.POST_PAGE,
                                arguments: _controller.userList[index]);
                          },
                          child: Card(
                            //final user = userList[index];
                            elevation: 6,
                            margin: const EdgeInsets.all(10),
                            color: Color.fromARGB(255, 100, 98, 98),
                            child: ListTile(
                              title: Text(
                                _controller.userList[index].name,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.didactGothic(
                                    // fontFamily: "Rbotoo",
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 235, 29, 118)),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://w7.pngwing.com/pngs/627/97/png-transparent-avatar-web-development-computer-network-avatar-game-web-design-heroes-thumbnail.png"),
                              ),
                              subtitle: Text(
                                _controller.userList[index].email,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.didactGothic(
                                    // fontFamily: "Rbotoo",
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        itemCount: _controller.userList.length,
                      )),

          // : Center(
          //     child: Text("No User Object"),
          //   )
        ));
  }
}
