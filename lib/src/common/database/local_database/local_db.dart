import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class LocalDatabase {
  static Future<File> _collectionFile({required String collectionName}) async {
    return File('$collectionName.json');
  }

//######################################################################################
// to create a collection in a file system

  static Future<void> createCollection({required String collectionName}) async {
    File collection = await _collectionFile(collectionName: collectionName);
    if (!collection.existsSync()) {
      collection.createSync();
      collection.writeAsStringSync('[]');
    } else {
      log('', error: 'Collection with this name already exist');
    }
  }
//######################################################################################

//######################################################################################
// * method to write data
// # check for id
// # check for collection is exist or not
  static Future<void> writeDocument(
      {required dynamic data, required String collectionName}) async {
    File collection = await _collectionFile(collectionName: collectionName);
    if (collection.existsSync()) {
      try {
        String previousData = collection.readAsStringSync();
        List<dynamic> fileData = jsonDecode(previousData);
        data.id = fileData.length;
        fileData.add(data);
        collection.writeAsStringSync(jsonEncode(fileData));
      } on NoSuchMethodError {
        log('', error: 'The object should contain a id parameter ');
      } catch (e) {
        log('', error: e);
      }
    } else {
      log('', error: 'Collection not exist');
    }
  }
//######################################################################################

//######################################################################################
// * method to red data
// # check for collection is exist or not
  static Future<dynamic> readDocument({required String collectionName}) async {
    File collection = await _collectionFile(collectionName: collectionName);
    if (collection.existsSync()) {
      try {
        dynamic fileData = collection.readAsStringSync();
        return jsonDecode(fileData);
      } catch (e) {
        log('', error: e);
      }
    } else {
      log('', error: 'Collection not exist');
    }
  }
//######################################################################################

//######################################################################################
// * method to red data
// # check for collection is exist or not
  static Future<dynamic> deleteDocument(
      {required String collectionName, required int id}) async {
    File collection = await _collectionFile(collectionName: collectionName);
    if (collection.existsSync()) {
      try {
        String previousData = collection.readAsStringSync();
        List<dynamic> fileData = jsonDecode(previousData);
        // fileData.removeAt(id);
        fileData.removeWhere((element) => element["id"] == id);
        collection.writeAsStringSync(jsonEncode(fileData));
      } catch (e) {
        log('', error: e);
      }
    } else {
      log('', error: 'Collection not exist');
    }
  }
//######################################################################################

//######################################################################################
// * method to delete collection
// # check for collection is exist or not
  static Future<dynamic> deleteCollection(
      {required String collectionName}) async {
    File collection = await _collectionFile(collectionName: collectionName);
    if (collection.existsSync()) {
      try {
        collection.deleteSync();
        log('$collectionName deleted successfully');
      } catch (e) {
        log('', error: e);
      }
    } else {
      log('', error: 'Collection not exist');
    }
  }
//######################################################################################
}
