import 'package:node_server_maker/src/common/enums/enums.dart';
import 'package:node_server_maker/src/common/extensions/extension.dart';
import 'package:node_server_maker/src/common/services/project_scaffolding_service/models/server_auth_model.dart';

import '../../../../../pages/home_page/model.dart';

String swaggerDocumentation({
  required String projectName,
  required List<Collection> collection,
  required List<Field> attributes,
  required ServerAuthentication serverAuthentication,
}) {
  String schemas() {
    String data = '';
    for (var element in collection) {
      data +=
          '    ${element.collectionName.capitalize()}Model:\n      type: object\n      properties:\n';
      for (var field in attributes) {
        if (field.collection == element) {
          data +=
              '        ${field.fieldName}:\n         type: ${field.fieldDataType}\n';
        }
      }
    }
    return data;
  }

  String authentication() {
    return serverAuthentication.authenticationLevel == AuthenticationLevel.TOKEN
        ? '''
  securitySchemes:
    bearerAuth:            
      type: http
      scheme: bearer
security:
  - bearerAuth: []  
'''
        : serverAuthentication.authenticationLevel == AuthenticationLevel.BASIC
            ? '''
  securitySchemes:
    basicAuth:    
      type: http
      scheme: basic
security:
  - basicAuth: [] 
'''
            : '';
  }

  String queryObjects({required Collection collection}) {
    String data = '';
    for (var element in attributes) {
      if (element.isRequired &&
          element.fieldDataType == 'String' &&
          element.collection.collectionName == collection.collectionName) {
        data += '''
      - name: ${element.fieldName}
        in: query
        required: false
        type: ${element.fieldDataType}\n
''';
      }
    }
    return data;
  }

  String methods() {
    String data = '';
    for (var element in collection) {
      data += '''
##########################################################
# Get Request
  /${element.collectionName.uncapitalize()}/get:
    get:
      tags: 
      - ${element.collectionName.capitalize()}
      summary: to get the whole collection of ${element.collectionName.uncapitalize()} 
      parameters:     
      # Search Queries  
${queryObjects(collection: element)}
      # Pagination Queries
      - name: page
        in: query
        required: false
        default: 1
        type: number
      - name: limit
        in: query
        default: 10
        required: false
        type: number
      responses: 
        200:
          description: Success  
          content:
            application/json:
              schema: 
                \$ref: "#/components/schemas/${element.collectionName.capitalize()}Model"
        403:
          description: Client Error
        500:
          description: Internal Server Error
        404:
          description: Not Found              

##########################################################
# Get Request By Id
  /${element.collectionName.uncapitalize()}/get/{id}:
    get:
      tags:
      - ${element.collectionName.capitalize()}
      summary: to get the ${element.collectionName.uncapitalize()} by id 
      parameters:
      - name: id
        in: path
        description: Document Id
        required: true
        type: string
      responses: 
        200:
          description: Success  
          content:
            application/json:
              schema: 
                \$ref: "#/components/schemas/${element.collectionName.capitalize()}Model"
        403:
          description: Client Error
        500:
          description: Internal Server Error
        404:
          description: Not Found  

##########################################################
# Post Request
  /${element.collectionName.uncapitalize()}/post:
    post:
      tags: 
      - ${element.collectionName.capitalize()}
      summary: to post data to database
      requestBody:
        required: true
        content:
          application/json:
            schema: 
              \$ref: "#/components/schemas/${element.collectionName.capitalize()}Model"
      responses: 
        200:
          description: Success  
          content:
            application/json:
              schema: 
                \$ref: "#/components/schemas/${element.collectionName.capitalize()}Model"
        201:
          description: Created  
          content:
            application/json:
              schema: 
                \$ref: "#/components/schemas/${element.collectionName.capitalize()}Model"
        403:
          description: Client Error
        500:
          description: Internal Server Error
        404:
          description: Not Found

##########################################################
# Delete Request
  /${element.collectionName.uncapitalize()}/delete:
    delete:
      tags: 
      - ${element.collectionName.capitalize()}
      responses: 
        200:
          description: Success  
        403:
          description: Client Error
        500:
          description: Internal Server Error
        404:
          description: Not Found

##########################################################
# Delete Request By Id
  /${element.collectionName.uncapitalize()}/delete/{id}:
    delete:
      tags:
      - ${element.collectionName.capitalize()}
      summary: to delete the ${element.collectionName.uncapitalize()} by id
      parameters:
      - name: id
        in: path
        description: Document Id
        required: true
        type: string
      responses: 
        200:
          description: Success  
        403:
          description: Client Error
        500:
          description: Internal Server Error
        404:
          description: Not Found 

''';
    }
    return data;
  }

  return '''
openapi: '3.0.0'
##########################################################
# Setup
info:
# project name here 
  title: $projectName
  # description: "Documentation of api containing product and categoy"
  version: 1.0.0
  contact:
    email: mohammadfuzailzaman@gmail.com


servers:
    - url: "http://localhost:8080/api/"
schemes: 
- http



paths:
  ${methods()}


components:
  schemas:
${schemas()}
 
${authentication()}









''';
}
