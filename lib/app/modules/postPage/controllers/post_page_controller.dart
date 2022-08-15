import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pillar_test_getx/app/data/models/post.dart';
import 'package:pillar_test_getx/app/data/models/user.dart';
import 'package:pillar_test_getx/app/services/http_services.dart';

class PostPageController extends GetxController {
  User user = Get.arguments;
  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isInternet = true.obs;
  final Rx<bool> isError = false.obs;
  final Rx<bool> isRefresh = false.obs;
  late int userId = user.id;
  late String userName = user.name;
  late HttpService http;
  var listener;

  List<Post> postList = <Post>[].obs;

  @override
  void onInit() {
    http = HttpService();
    getInternet();
    getPost();
    super.onInit();
  }

  Future getPost() async {
    late Response activeResponse;

    try {
      isLoading.value = true;

      final response = await http.getRequest("posts?userId=$userId");

      isLoading.value = false;

      response.when(
        (exception) => isLoading.value = false, // TODO: Handle exception
        (response) =>
            activeResponse = response, // TODO: Do something with location
      );

      if (activeResponse.statusCode == 200) {
        isLoading.value = false;
        postList = Post.postlistFromJson(activeResponse.data);
        postList.sort((a, b) => a.title.length.compareTo(b.title.length));
        update();
        //return userList;
      } else {
        isError.value = true;
        isLoading.value = false;
        Get.snackbar("Response Error", "Invalid Response from Server");
      }
    } on Exception catch (e) {
      isError.value = true;
      isLoading.value = false;
      isInternet.value = false;
      Get.snackbar("Error Loading", "Please Connect to Internet");
      print(e);
    }
  }

  Future getInternet() async {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isInternet.value = true;
          isLoading.value = false;
          getPost();
          Get.snackbar("Online", "Internet Conneted");
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          isInternet.value = false;
          isError.value = true;
          isLoading.value = false;
          Get.snackbar("Offline", "Internet Disconneted");
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    listener.cancel();
  }
}
