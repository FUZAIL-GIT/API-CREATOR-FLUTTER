import 'package:node_server_maker/src/common/extensions/extension.dart';

import '../../../../../pages/home_page/model.dart';

String createRouteTemplate(
  List<Collection> collection,
  List<Field> attributes,
) {
  String importStatement() {
    String data = '';
    for (var element in collection) {
      data += '''
    const ${element.collectionName.capitalize()} = require("../controller/${element.collectionName.uncapitalize()}_controller.js"); \n''';
    }
    return data;
  }

  String routes() {
    String data = '';
    for (var element in collection) {
      data += '''
 // Create a new ${element.collectionName}
  router.post("/${element.collectionName.uncapitalize()}/post", jsonParser ,${element.collectionName.capitalize()}.create);

  // Retrieve all ${element.collectionName}
  router.get("/${element.collectionName.uncapitalize()}/get", ${element.collectionName.capitalize()}.findAll);

  // Retrieve a single ${element.collectionName} with id
  router.get("/${element.collectionName.uncapitalize()}/get/:id", ${element.collectionName.capitalize()}.findOne);

  // Update a ${element.collectionName} with id
  router.put("/${element.collectionName.uncapitalize()}/update/:id", ${element.collectionName.capitalize()}.update);

  // Delete a ${element.collectionName} with id
  router.delete("/${element.collectionName.uncapitalize()}/delete/:id", ${element.collectionName.capitalize()}.delete);

  // Delete all ${element.collectionName}
  router.delete("/${element.collectionName.uncapitalize()}/delete", ${element.collectionName.capitalize()}.deleteAll);

\n\n
''';
    }
    return data;
  }

  return '''
module.exports = app => {
 ${importStatement()}
  // create application/json parser
  var bodyParser = require("body-parser");
  var jsonParser = bodyParser.json();

  // create application/x-www-form-urlencoded parser
  var urlencodedParser = bodyParser.urlencoded({ extended: false });
 
  var router = require("express").Router();
  app.use(jsonParser);
 ${routes()}
   app.use('/api', router);
};

''';
}
