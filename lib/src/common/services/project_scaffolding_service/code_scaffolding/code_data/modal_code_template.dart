import 'package:node_server_maker/src/common/extensions/extension.dart';

import '../../../../models/attribute_model.dart';
import '../../../../models/collection_model.dart';

String modelTemplate(
  Collection collection,
  List<Attribute> attributes,
) {
  String modelName = collection.collectionName.capitalize();
  String objects() {
    String modalField = '';
    for (var element in attributes) {
      if (element.collection.collectionName == collection.collectionName) {
        modalField += '''
    ${element.fieldName}: {
        type: ${element.fieldDataType},
        required: ${element.isRequired},
        unique: ${element.isUnique},
    },\n''';
      }
    }
    return modalField;
  }

  return '''
const mongoose = require("mongoose");

const ${modelName.capitalize()} = mongoose.model(
    "${modelName.toLowerCase()}",
    mongoose.Schema({
    ${objects()}

    },
    ${collection.isTimeStamp ? '{timestamps: true}' : ''}
    )
);
module.exports = {
   ${modelName.capitalize()}
}
''';
}
