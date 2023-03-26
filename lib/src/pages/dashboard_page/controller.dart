import 'dart:developer';
import 'package:get/get.dart';
import 'package:api_creator/src/common/models/project_details_model.dart';
import '../../common/database/local_database/local_db.dart';

class DashboardController extends GetxController
    with StateMixin<List<ProjectDetails>> {
  Future<void> deleteDocument({required int id}) async {
    await LocalDatabase.deleteDocument(collectionName: 'projectInfo', id: id);
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      await LocalDatabase.createCollection(collectionName: 'projectInfo');
      List<dynamic> jsonResponse =
          await LocalDatabase.readDocument(collectionName: 'projectInfo');
      List<ProjectDetails> list =
          jsonResponse.map((e) => ProjectDetails.fromJson(e)).toList();
      if (list.isNotEmpty) {
        change(list, status: RxStatus.success());
      } else {
        change([], status: RxStatus.success());
      }
    } catch (e) {
      log(e.toString(), error: e);
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
