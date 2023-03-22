import 'dart:developer';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:node_server_maker/src/common/models/project_details_model.dart';
import 'package:node_server_maker/src/common/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static late Box<ProjectDetails> _box;
  static Future<void> openDatabase() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(ProjectDetailsAdapter());
    _box = await Hive.openBox('projectDetails');
    talker.good("Hive Database initialized : ${_box.name}");
  }

  static Future<ProjectDetails?> getProjectDetails() async {
    ProjectDetails? projectInfo = _box.get('projectDetails');
    log(projectInfo?.projectName ?? 'null');
    return projectInfo;
  }

  static Future<void> putProjectDetails(
      {required ProjectDetails projectInfo}) async {
    await _box.add(projectInfo);
  }
}
