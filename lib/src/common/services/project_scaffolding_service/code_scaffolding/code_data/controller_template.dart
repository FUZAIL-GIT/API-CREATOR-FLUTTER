import 'package:node_server_maker/src/common/extensions/extension.dart';
import '../../../../../pages/home_page/model.dart';

String createControllerTemplate(
  Collection collection,
  List<Field> attributes,
) {
  String modelName = collection.collectionName;

  String validateRequest() {
    String data = '';
    for (var element in attributes) {
      if (element.isRequired &&
          element.collection.collectionName == collection.collectionName) {
        data += '''
      if (!req.body.${element.fieldName}) {
        res.status(400).send({ message: "${element.fieldName} can not be empty!" });
        return;
      } \n
    ''';
      }
    }
    return data;
  }

  String queryObjects() {
    String data = '';
    for (var element in attributes) {
      if (element.isRequired &&
          element.fieldDataType == 'String' &&
          element.collection.collectionName == collection.collectionName) {
        data += '''
        const ${element.fieldName} = req.query.${element.fieldName}; \n''';
      }
    }
    return data;
  }

  String queryCondition() {
    String data = '';
    for (var element in attributes) {
      if (element.isRequired &&
          element.fieldDataType == 'String' &&
          element.collection.collectionName == collection.collectionName) {
        data += '''
        ${element.fieldName}: { 
        \$regex: new RegExp(${element.fieldName}), 
        \$options: "i"
         },
       ''';
      }
    }
    return data;
  }

  String initValue() {
    String data = '';
    for (var element in attributes) {
      if (element.collection.collectionName == collection.collectionName) {
        data += '''
    ${element.fieldName} : req.body.${element.fieldName},\n''';
      }
    }
    return data;
  }

  String getRequestById() {
    return '''
      // Find a single $modelName with an id
      exports.findOne = (req, res) => {
      const id = req.params.id;
        ${modelName.capitalize()}.findById(id)
      .then(data => {
      if (!data)
        res.status(404).send({ message: "Not found $modelName with id " + id });
      else res.send(data);
      })
      .catch(err => {
      res
        .status(500)
        .send({ message: "Error retrieving $modelName with id=" + id });
      });
      };
      ''';
  }

  String deleteRequestById() {
    return '''
      // Delete a $modelName with the specified id in the request
      exports.delete = (req, res) => {
         const id = req.params.id;
      ${modelName.capitalize()}.findByIdAndRemove(id)
      .then(data => {
        if (!data) {
          res.status(404).send({
            message: `Cannot delete $modelName with id=\${id}. Maybe $modelName was not found!`
          });
        } else {
          res.send({
            message: "$modelName was deleted successfully!"
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Could not delete $modelName with id=" + id
        });
      });
      };
      ''';
  }

  return '''
const { ${modelName.capitalize()} } = require("../model/${modelName..uncapitalize()}_model.js");


// Create and Save a new Tutorial
exports.create = (req, res) => {

  //Validate request
  ${validateRequest()}

  // Create a  ${modelName}Model
  const ${modelName.toLowerCase()} = new ${modelName.capitalize()}({
   ${initValue()}
  });

  // Save $modelName in the database
 ${modelName.toLowerCase()}
    .save(${modelName.toLowerCase()})
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the $modelName."
      });
    });
  
};


// Retrieve all $modelName from the database.
exports.findAll = (req, res) => {
    ${collection.isPagination ? '''
  // destructure page and limit and set default values
  const { page = 1, limit = 10 } = req.query;
''' : ''}
  ${queryObjects()}
    var condition = {
     ${queryCondition()}
    };
    ${modelName.capitalize()}
    .find(condition)
    ${collection.isPagination ? '''
     .limit(limit * 1)
     .skip((page - 1) * limit)
    ''' : ''}
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving $modelName."
      });
    });
};

${getRequestById()}

// Update a $modelName by the id in the request
exports.update = (req, res) => {

   if (!req.body) {
    return res.status(400).send({
      message: "Data to update can not be empty!"
    });
  }

  const id = req.params.id;

  ${modelName.capitalize()}.findByIdAndUpdate(id, req.body, { useFindAndModify: false })
    .then(data => {
      if (!data) {
        res.status(404).send({
          message: `Cannot update $modelName with id=\${id}. Maybe $modelName was not found!`
        });
      } else res.send({ message: "$modelName was updated successfully." });
    })
    .catch(err => {
      res.status(500).send({
        message: "Error updating $modelName with id=" + id
      });
    });
  
};

${deleteRequestById()}

// Delete all $modelName from the database.
exports.deleteAll = (req, res) => {
  ${modelName.capitalize()}.deleteMany({})
    .then(data => {
      res.send({
        message: `\${data.deletedCount} $modelName were deleted successfully!`
      });
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while removing all $modelName."
      });
    });
};

''';
}
