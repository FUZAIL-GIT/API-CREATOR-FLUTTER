import 'dart:io';

import 'package:node_server_maker/src/common/enums/enums.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../pages/home_page/model.dart';
import '../code_scaffolding/code_data/controller_template.dart';
import '../code_scaffolding/code_data/modal_code_template.dart';
import '../code_scaffolding/code_data/route_template.dart';
import '../models/server_auth_model.dart';

class DataService {
  //get download directory
  Future<Directory?> downloadDirectory() async => await getDownloadsDirectory();

  //it will create the model file code
  String modelData(
    Collection collection,
    List<Field> attributes,
  ) =>
      modelTemplate(collection, attributes);

  //it will create the controller file code
  String controllerData(
    Collection collection,
    List<Field> attributes,
  ) =>
      createControllerTemplate(collection, attributes);

  //it will create the controller file code
  String routesData(
    List<Collection> collections,
    List<Field> attributes,
  ) =>
      createRouteTemplate(collections, attributes);

  //it will create the db config file code
  String mongoDbConfig(
      String mongoDbUrl, ServerAuthentication serverAuthentication) {
    String authCredentials = serverAuthentication.authenticationLevel ==
            AuthenticationLevel.BASIC
        ? '''
 userName: "${serverAuthentication.userName}",
  password: "${serverAuthentication.password}"
'''
        : serverAuthentication.authenticationLevel == AuthenticationLevel.TOKEN
            ? '''
token: "${serverAuthentication.token}"
'''
            : '';
    return '''
const pagination = {
  pageSize: 10,
  pageNo: 1
}
const authenticationCredentials = { 
        $authCredentials
}
module.exports = {
  mongoDbUrl: "$mongoDbUrl",
  pagination,
  authenticationCredentials
};
''';
  }
}
