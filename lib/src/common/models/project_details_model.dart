import 'package:api_creator/src/common/models/server_details_model.dart';

class ProjectDetails {
  int?  id;
  String projectName;
  DateTime createdAt;
  List<DateTime> updatedAt;
  ServerDetails servertDetails;
  ProjectDetails({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.projectName,
    required this.servertDetails,
  });
//   @override
//   toString() {
//     return '''
// | createdAt : $createdAt
// | updatedAt : $updatedAt
// | projectName : $projectName
// | servertDetails : $servertDetails
// ''';
//   }

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
        id: json['id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: List<DateTime>.from(
            json["updatedAt"].map((x) => DateTime.parse(x))),
        projectName: json["projectName"],
        servertDetails: ServerDetails.fromJson(json["servertDetails"]),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toString(),
        "updatedAt": List<dynamic>.from(updatedAt.map((x) => x.toString())),
        "projectName": projectName,
        "servertDetails": servertDetails.toJson(),
      };
}
