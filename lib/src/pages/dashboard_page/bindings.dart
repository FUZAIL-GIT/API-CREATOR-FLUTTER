import 'package:get/get.dart';
import 'package:node_server_maker/src/pages/dashboard_page/controller.dart';

class DashboardScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
