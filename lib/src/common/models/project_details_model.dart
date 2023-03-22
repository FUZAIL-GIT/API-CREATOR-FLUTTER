import 'package:node_server_maker/src/common/models/server_details_model.dart';
import 'package:hive/hive.dart';
part 'project_details_model.g.dart';

@HiveType(typeId: 2)
class ProjectDetails extends HiveObject {
  @HiveField(0)
  String projectName;
  @HiveField(1)
  DateTime ceratedAt;
  @HiveField(2)
  List<DateTime> updatedAt;
  @HiveField(3)
  ServertDetails servertDetails;
  ProjectDetails({
    required this.ceratedAt,
    required this.updatedAt,
    required this.projectName,
    required this.servertDetails,
  });
}
