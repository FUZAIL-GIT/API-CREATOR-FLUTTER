import 'package:get/get.dart';

class DashboardController extends GetxController {
  @override
  void onInit() async {
    // await LocalStorage.openDatabase();
    // // LocalStorage.getProjectDetails();
    // ProjectInfo projectInfo = ProjectInfo(
    //   projectName: "projectName",
    //   createdAt: DateTime.now(),
    //   updatedAt: [DateTime.now().add(Duration(days: 4))],
    //   projectDetails: ProjectDetails(
    //     attributes: [
    //       Attribute(
    //           fieldName: 'fieldName',
    //           fieldDataType: DataType.Boolean.name,
    //           collection: Collection(
    //               collectionName: 'collectionName',
    //               isTimeStamp: false,
    //               isPagination: true)),
    //     ],
    //     collections: [
    //       Collection(
    //           collectionName: 'collectionName',
    //           isTimeStamp: false,
    //           isPagination: true)
    //     ],
    //     mongoDbUrl: 'sd',
    //     serverAuthentication: ServerAuthentication.none(),
    //   ),
    // );
    // LocalStorage.putProjectDetails(projectInfo: projectInfo);
    super.onInit();
  }
}
