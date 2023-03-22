import 'package:get/get.dart';
import 'package:node_server_maker/src/pages/home_page/controller.dart';

class HomeScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
