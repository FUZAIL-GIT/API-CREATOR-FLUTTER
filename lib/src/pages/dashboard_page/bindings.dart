import 'package:get/get.dart';
import 'package:api_creator/src/pages/dashboard_page/controller.dart';

class DashboardScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
