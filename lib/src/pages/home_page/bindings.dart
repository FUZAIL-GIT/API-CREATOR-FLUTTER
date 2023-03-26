import 'package:get/get.dart';
import 'package:api_creator/src/pages/home_page/controller.dart';

class HomeScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
