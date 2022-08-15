import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pillar_test_getx/app/data/models/user.dart';
import 'package:pillar_test_getx/app/services/http_services.dart';

class HomeController extends GetxController {
  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isInternet = true.obs;
  final Rx<bool> isError = false.obs;
  final Rx<bool> isRefresh = false.obs;
  late HttpService http;
  var listener;

  List<User> userList = <User>[].obs;

  @override
  void onInit() {
    http = HttpService();
    getInternet();
    getListUser();
    super.onInit();
  }

  //late User user;
  Future getListUser() async {
    late Response activeResponse;

    try {
      isLoading.value = true;

      final response = await http.getRequest("users");

      isLoading.value = false;

      response.when(
        (exception) => isLoading.value = false,
        (response) => activeResponse = response,
      );

      if (activeResponse.statusCode == 200) {
        isLoading.value = false;
        userList = User.userlistFromJson(activeResponse.data);
        update();
      } else {
        isError.value = true;
        isLoading.value = false;
        Get.snackbar("Response Error", "Invalid Response from Server");
      }
    } on Exception catch (e) {
      isError.value = true;
      isLoading.value = false;
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
          getListUser();
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
    super.onClose();
  }
}
