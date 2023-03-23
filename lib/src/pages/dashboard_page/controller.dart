// import 'dart:math';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:node_server_maker/src/common/database/local_database/local_db.dart';
import 'package:node_server_maker/src/common/models/project_details_model.dart';

class DashboardController extends GetxController
    with StateMixin<List<ProjectDetails>> {
  RxList<ProjectDetails> projectDetails = <ProjectDetails>[].obs;
  Future<void> fetchData() async {
    try {
      LocalDatabase.createCollection(collectionName: 'projectInfo');
      List<dynamic> jsonResponse =
          await LocalDatabase.readDocument(collectionName: 'projectInfo');
      if (jsonResponse.isNotEmpty) {
        change(jsonResponse.map((e) => ProjectDetails.fromJson(e)).toList(),
            status: RxStatus.success());
      } else if (jsonResponse.isEmpty) {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      log('', error: e);
      change(null, status: RxStatus.error());
    }
  }

  @override
  void onInit() async {
    await fetchData();
    super.onInit();
  }
}
  // @override
  // void onInit() async {
  //   var model = ProjectDetails(
  //     createdAt: DateTime.now(),
  //     updatedAt: [DateTime.now().add(Duration(days: 3))],
  //     projectName: 'test',
  //     servertDetails: ServerDetails(
  //       attributes: [
  //         Attribute(
  //             fieldName: 'fieldName',
  //             fieldDataType: 'String',
  //             collection: Collection(
  //                 collectionName: 'collectionName',
  //                 isTimeStamp: false,
  //                 isPagination: false))
  //       ],
  //       collections: [
  //         Collection(
  //             collectionName: 'collectionName',
  //             isTimeStamp: false,
  //             isPagination: false)
  //       ],
  //       mongoDbUrl: 'mongoDbUrl',
  //       serverAuthentication: ServerAuthentication.none(),
  //     ),
  //   );
  //   // await LocalDatabase.deleteCollection(collectionName: 'projectInfo');
  //   LocalDatabase.createCollection(collectionName: 'projectInfo');
  //   await LocalDatabase.writeDocument(
  //       data: model, collectionName: 'projectInfo');
  //   // LocalDatabase.deleteDocument(collectionName: 'projectInfo', id: 1);
  //   List<dynamic> data =
  //       await LocalDatabase.readDocument(collectionName: 'projectInfo');
  //   projectDetails.value = data.map((e) => ProjectDetails.fromJson(e)).toList();
    // for (var element in projectDetails) {
    //   log(jsonEncode(element));
    // }
  //   super.onInit();
  // }