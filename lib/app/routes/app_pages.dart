import 'package:get/get.dart';

import 'package:pillar_test_getx/app/modules/home/bindings/home_binding.dart';
import 'package:pillar_test_getx/app/modules/home/views/home_view.dart';
import 'package:pillar_test_getx/app/modules/postPage/bindings/post_page_binding.dart';
import 'package:pillar_test_getx/app/modules/postPage/views/post_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.POST_PAGE,
      page: () => PostPageView(),
      binding: PostPageBinding(),
    ),
  ];
}
