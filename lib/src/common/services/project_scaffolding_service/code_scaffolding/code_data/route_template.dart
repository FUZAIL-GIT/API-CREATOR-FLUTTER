import 'package:node_server_maker/src/common/extensions/extension.dart';

import '../../../../models/attribute_model.dart';
import '../../../../models/collection_model.dart';

String createAppRouteTemplate(
  List<Collection> collection,
  List<Attribute> attributes,
) {
  String importStatement() {
    String data = '';
    for (var element in collection) {
      data += '''
    const {${element.collectionName.uncapitalize()}Routes} = require("../routes/${element.collectionName.uncapitalize()}_routes.js"); \n''';
    }
    return data;
  }

  String appRoutes() {
    String data = '';
    for (var element in collection) {
      data += "${element.collectionName.uncapitalize()}Routes(router)\n";
    }
    return data;
  }
//   String routes() {
//     String data = '';
//     for (var element in collection) {
//       data += '''
//  // Create a new ${element.collectionName}
//   router.post("/${element.collectionName.uncapitalize()}/post", jsonParser ,${element.collectionName.capitalize()}.create);

//   // Retrieve all ${element.collectionName}
//   router.get("/${element.collectionName.uncapitalize()}/get", ${element.collectionName.capitalize()}.findAll);

//   // Retrieve a single ${element.collectionName} with id
//   router.get("/${element.collectionName.uncapitalize()}/get/:id", ${element.collectionName.capitalize()}.findOne);

//   // Update a ${element.collectionName} with id
//   router.put("/${element.collectionName.uncapitalize()}/update/:id", ${element.collectionName.capitalize()}.update);

//   // Delete a ${element.collectionName} with id
//   router.delete("/${element.collectionName.uncapitalize()}/delete/:id", ${element.collectionName.capitalize()}.delete);

//   // Delete all ${element.collectionName}
//   router.delete("/${element.collectionName.uncapitalize()}/delete", ${element.collectionName.capitalize()}.deleteAll);

// \n\n
// ''';
//     }
//     return data;
//   }

  return '''
 module.exports = app => {
 ${importStatement()}
 
  var router = require("express").Router();
 ${appRoutes()}
  app.use('/api', router);
};

''';
}

String createCollectionRoute(
  Collection collection,
  List<Attribute> attributes,
) {
  String importStatement() {
    String data = '';
    data += '''
const ${collection.collectionName.capitalize()} = require("../controller/${collection.collectionName.uncapitalize()}_controller.js"); \n''';
    return data;
  }

  String routes() {
    String data = '';

    data += '''
 // Create a new ${collection.collectionName}
  router.post("/${collection.collectionName.uncapitalize()}/post" ,${collection.collectionName.capitalize()}.create);

  // Retrieve all ${collection.collectionName}
  router.get("/${collection.collectionName.uncapitalize()}/get", ${collection.collectionName.capitalize()}.findAll);

  // Retrieve a single ${collection.collectionName} with id
  router.get("/${collection.collectionName.uncapitalize()}/get/:id", ${collection.collectionName.capitalize()}.findOne);

  // Update a ${collection.collectionName} with id
  router.put("/${collection.collectionName.uncapitalize()}/update/:id", ${collection.collectionName.capitalize()}.update);

  // Delete a ${collection.collectionName} with id
  router.delete("/${collection.collectionName.uncapitalize()}/delete/:id", ${collection.collectionName.capitalize()}.delete);

  // Delete all ${collection.collectionName}
  router.delete("/${collection.collectionName.uncapitalize()}/delete", ${collection.collectionName.capitalize()}.deleteAll);
\n
''';

    return data;
  }

  return '''
${importStatement()}
exports.${collection.collectionName.uncapitalize()}Routes = (router) => {

${routes()}

}
''';
}
