// Import necessary libraries for this class
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  // Define the file for the collection
  static Future<File> _collectionFile({required String collectionName}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$collectionName.json');
  }

  // Create a collection
  static Future<void> createCollection({required String collectionName}) async {
    // Get the file for the specified collection
    File collection = await _collectionFile(collectionName: collectionName);

    // If the file does not exist, create a new one and write an empty array to it
    if (!collection.existsSync()) {
      collection.createSync();
      collection.writeAsStringSync('[]');
    } else {
      // If the file exists, log an error
      log('Collection with this name already exists', name: 'LocalDatabase');
    }
  }

  // Write a document to the collection
  static Future<void> writeDocument(
      {required dynamic data, required String collectionName}) async {
    // Get the file for the specified collection
    File collection = await _collectionFile(collectionName: collectionName);

    // If the file exists, add the new document to its contents
    if (collection.existsSync()) {
      try {
        // Parse the existing contents of the file from JSON
        String previousData = collection.readAsStringSync();
        List<dynamic> fileData = jsonDecode(previousData);

        // Add the new document to the array and give it an ID
        data.id = fileData.length;
        fileData.add(data);

        // Write the updated array back to the file in JSON format
        collection.writeAsStringSync(jsonEncode(fileData));
      } on NoSuchMethodError {
        // If the document does not have an ID parameter, log an error
        log('The object should contain an id parameter', name: 'LocalDatabase');
      } catch (e) {
        // If an unknown error occurs, log the exception
        log('', error: e.toString(), name: 'LocalDatabase');
      }
    } else {
      // If the file does not exist, log an error
      log('Collection does not exist', name: 'LocalDatabase');
    }
  }

  // Read a document or array of documents from the collection
  static Future<dynamic> readDocument({required String collectionName}) async {
    // Get the file for the specified collection
    File collection = await _collectionFile(collectionName: collectionName);

    // If the file exists, parse its contents and return them
    if (collection.existsSync()) {
      try {
        // Parse the contents of the file from JSON
        String fileData = collection.readAsStringSync();
        return jsonDecode(fileData);
      } catch (e) {
        // If an error occurs, log the exception
        log('', error: e.toString(), name: 'LocalDatabase');
      }
    } else {
      // If the file does not exist, log an error
      log('Collection does not exist', name: 'LocalDatabase');
    }
  }

  // Delete a document from the collection by ID
  static Future<dynamic> deleteDocument(
      {required String collectionName, required int id}) async {
    // Get the file for the specified collection
    File collection = await _collectionFile(collectionName: collectionName);

    // If the file exists, remove the specified document from its contents
    if (collection.existsSync()) {
      try {
        // Parse the existing contents of the file from JSON
        String previousData = collection.readAsStringSync();
        List<dynamic> fileData = jsonDecode(previousData);

        // Remove the specified document from the array and write the updated
        // array back to the file in JSON format
        fileData.removeWhere((element) => element.id == id);
        collection.writeAsStringSync(jsonEncode(fileData));
      } catch (e) {
        // If an error occurs, log the exception
        log('', error: e.toString(), name: 'LocalDatabase');
      }
    } else {
      // If the file does not exist, log an error
      log('Collection does not exist', name: 'LocalDatabase');
    }
  }

  // Update an existing document in the collection by ID
  static Future<dynamic> updateDocument(
      {required String collectionName,
      required int id,
      required dynamic data}) async {
    // Get the file for the specified collection
    File collection = await _collectionFile(collectionName: collectionName);

    // If the file exists, update the specified document in its contents
    if (collection.existsSync()) {
      try {
        // Parse the existing contents of the file from JSON
        String previousData = collection.readAsStringSync();
        List<dynamic> fileData = jsonDecode(previousData);

        // Remove the specified document from the array, update its contents,
        // and re-insert it into the array, then write the updated array back
        // to the file in JSON format
        fileData.removeWhere((element) => element["id"] == id);
        data.id = id;
        fileData.insert(id, data);
        collection.writeAsStringSync(jsonEncode(fileData));
      } catch (e) {
        // If an error occurs, log the exception
        log('', error: e.toString(), name: 'LocalDatabase');
      }
    } else {
      // If the file does not exist, log an error
      log('Collection does not exist', name: 'LocalDatabase');
    }
  }

  // Delete a collection and its file from the local storage
  static Future<dynamic> deleteCollection(
      {required String collectionName}) async {
    // Get the file for the specified collection
    File collection = await _collectionFile(collectionName: collectionName);

    // If the file exists, delete it, otherwise log an error
    if (collection.existsSync()) {
      try {
        collection.deleteSync();
        log('$collectionName deleted successfully', name: 'LocalDatabase');
      } catch (e) {
        // If an error occurs, log the exception
        log('', error: e.toString(), name: 'LocalDatabase');
      }
    } else {
      // If the file does not exist, log an error
      log('Collection does not exist', name: 'LocalDatabase');
    }
  }
}
