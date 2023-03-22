import 'package:node_server_maker/src/common/services/project_scaffolding_service/models/server_auth_model.dart';
import 'package:node_server_maker/src/pages/home_page/model.dart';

class ProjectInfo {
  String projectName;
  DateTime createdAt;
  List<DateTime> updatedAt;
  ProjectDetails projectDetails;
  ProjectInfo({
    required this.projectName,
    required this.createdAt,
    required this.updatedAt,
    required this.projectDetails,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      projectName: json["projectName"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      projectDetails: json["projectDetails"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "projectName": projectName,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "projectDetails": projectDetails
    };
  }
}

class ProjectDetails {
  List<Collection> collections;
  List<Field> attributes;
  String mongoDbUrl;
  ServerAuthentication serverAuthentication;
  ProjectDetails({
    required this.attributes,
    required this.collections,
    required this.mongoDbUrl,
    required this.serverAuthentication,
  });
}
