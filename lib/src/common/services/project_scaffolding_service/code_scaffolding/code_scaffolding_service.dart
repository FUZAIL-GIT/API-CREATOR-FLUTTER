// Importing required packages
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importing models, extensions, controllers ,enums, and data service
import '../../../enums/enums.dart';
import '../../../models/attribute_model.dart';
import '../../../models/collection_model.dart';
import '../../../models/server_auth_model.dart';
import '../data_service/data_service.dart';
import 'package:api_creator/src/common/extensions/extension.dart';
import '../../../../pages/home_page/controller.dart';

// Importing code data
import 'code_data/middleware_template.dart';
import 'code_data/server_template.dart';
import 'code_data/swagger_documentation.dart';

// Creating instance of GetxController
class CodeScaffoldingService extends GetxController {
  // Creating instance of HomeController
  HomeController homeController = Get.find();

  // Creating instance variables
  late final Directory projectDir;
  late final String workingDirectory;
  late final Directory? downloadDirectoryPath;
  DataService dataService = DataService();

  // Method to run a command
  Future<bool> runCommand({
    required String workingDirectory,
    required String command,
    bool runInShell = true,
  }) async {
    try {
      var result = await Process.run(command, [],
              runInShell: runInShell, workingDirectory: workingDirectory)
          .timeout(const Duration(seconds: 60));
      if (result.exitCode != 0) {
        return false;
      } else {
        return true;
      }
    } on TimeoutException {
      // The operation timed out
      homeController.throwError('Timeout');
    }
    return false;
  }

  //create a porject
  Future<void> createProject({
    required String projectName,
    required List<Collection> collections,
    required List<Attribute> attributes,
    required String mongoDbUrl,
    required bool isTimestamp,
    required bool isPagination,
    required bool isOpenInVsCode,
    required bool isInstallPackages,
    bool isEdit = false,
    required ServerAuthentication serverAuthentication,
  }) async {
    try {
      downloadDirectoryPath = await dataService.downloadDirectory();
      projectDir = Directory("${downloadDirectoryPath!.path}/$projectName/app");

      if (!isEdit) {
        if (!projectDir.existsSync()) {
          homeController.updateCurrentStatus(Status.LOADING);
          await projectSetup(
              projectName: projectName,
              isAutomaticallyInstallPackages: isInstallPackages,
              attributes: attributes,
              collections: collections,
              mongoDbUrl: mongoDbUrl,
              serverAuthentication: serverAuthentication,
              isTimestamp: isTimestamp,
              isPagination: isPagination,
              isOpenInVsCode: isOpenInVsCode,
              isInstallPackages: isInstallPackages);
        } else {
          log("folder with this name already exist");
          homeController.throwError('folder with this name alread exist');
        }
      } else if (isEdit) {
        if (projectDir.existsSync()) {
          try {
            Directory("${downloadDirectoryPath!.path}/$projectName")
                .deleteSync(recursive: true);
          } catch (e) {
            log('', error: e);
          }
          homeController.updateCurrentStatus(Status.LOADING);
          await projectSetup(
              projectName: projectName,
              isAutomaticallyInstallPackages: isInstallPackages,
              attributes: attributes,
              collections: collections,
              mongoDbUrl: mongoDbUrl,
              serverAuthentication: serverAuthentication,
              isTimestamp: isTimestamp,
              isPagination: isPagination,
              isOpenInVsCode: isOpenInVsCode,
              isInstallPackages: isInstallPackages);
        } else {
          homeController.updateCurrentStatus(Status.LOADING);
          // File file = File(projectDir.path);
          // file.deleteSync();
          await projectSetup(
              projectName: projectName,
              isAutomaticallyInstallPackages: isInstallPackages,
              attributes: attributes,
              collections: collections,
              mongoDbUrl: mongoDbUrl,
              serverAuthentication: serverAuthentication,
              isTimestamp: isTimestamp,
              isPagination: isPagination,
              isOpenInVsCode: isOpenInVsCode,
              isInstallPackages: isInstallPackages);
        }
      }
    } catch (e) {
      log('', error: e);
    }
  }

  Future<void> projectSetup(
      {required String projectName,
      required List<Collection> collections,
      required List<Attribute> attributes,
      required String mongoDbUrl,
      required bool isTimestamp,
      required bool isPagination,
      required bool isOpenInVsCode,
      required bool isInstallPackages,
      required ServerAuthentication serverAuthentication,
      required bool isAutomaticallyInstallPackages}) async {
    // project root directory path
    workingDirectory = '${downloadDirectoryPath!.path}\\$projectName';

    //create project dir
    projectDir.createSync(recursive: true);

    //intialize as a node project
    await runCommand(workingDirectory: workingDirectory, command: 'npm init -y')
        .then((value) async {
      if (value) {
        log('npm initialized');
        homeController.updateCurrentStatus(Status.INITIALIZED);
        if (isAutomaticallyInstallPackages) {
          await runCommand(
                  workingDirectory: workingDirectory,
                  command:
                      'npm install express mongoose body-parser swagger-ui-express yamljs --save')
              .then((value) async {
            if (value) {
              log('npm packages installed');
              await createFolderStructure(
                attributes: attributes,
                collections: collections,
                mongoDbUrl: mongoDbUrl,
                projectName: projectName,
                serverAuthentication: serverAuthentication,
                isTimestamp: isTimestamp,
                isPagination: isPagination,
                isOpenInVsCode: isOpenInVsCode,
              ).then((value) {
                if (value) {
                  log("folder Structure created");
                }
              });
              homeController.updateCurrentStatus(Status.INSTALLED);
            } else {
              log('npm packages not installed');
              Get.showSnackbar(
                const GetSnackBar(
                  title: 'Internet may not avaiable',
                  message: 'you need to install packages manually',
                  leftBarIndicatorColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                ),
              );
              homeController.updateCurrentStatus(Status.INSTALLED);

              await createFolderStructure(
                attributes: attributes,
                collections: collections,
                mongoDbUrl: mongoDbUrl,
                projectName: projectName,
                serverAuthentication: serverAuthentication,
                isTimestamp: isTimestamp,
                isPagination: isPagination,
                isOpenInVsCode: isOpenInVsCode,
              ).then((value) {
                if (value) {
                  log("folder Structure created");
                }
              });
            }
          });
        } else if (!isAutomaticallyInstallPackages) {
          log('npm packages not installed');
          Get.showSnackbar(
            const GetSnackBar(
              title: 'Internet may not avaiable',
              message: 'you need to install packages manually',
              leftBarIndicatorColor: Colors.redAccent,
              duration: Duration(seconds: 2),
            ),
          );
          homeController.updateCurrentStatus(Status.INSTALLED);

          await createFolderStructure(
            attributes: attributes,
            collections: collections,
            mongoDbUrl: mongoDbUrl,
            projectName: projectName,
            serverAuthentication: serverAuthentication,
            isTimestamp: isTimestamp,
            isPagination: isPagination,
            isOpenInVsCode: isOpenInVsCode,
          ).then((value) {
            if (value) {
              log("folder Structure created");
            }
          });
        }
      } else {
        homeController.throwError('npm not installed');
      }
    }); //installing packages
  }

  Future<bool> createFolderStructure({
    required String projectName,
    required String mongoDbUrl,
    required List<Collection> collections,
    required List<Attribute> attributes,
    required bool isTimestamp,
    required bool isPagination,
    required bool isOpenInVsCode,
    required ServerAuthentication serverAuthentication,
  }) async {
    // Create sub-folders within myFolder
    Directory controllerFolder = Directory('${projectDir.path}\\controller');
    Directory middlewareFolder = Directory('${projectDir.path}\\middleware');
    Directory modelFolder = Directory('${projectDir.path}\\model');
    Directory routesFolder = Directory('${projectDir.path}\\routes');
    Directory configFolder = Directory('${projectDir.path}\\config');

    // Create the sub-folders
    await controllerFolder.create(recursive: true);
    if (serverAuthentication.authenticationLevel !=
        AuthenticationLevel.NONE.name) {
      await middlewareFolder.create(recursive: true);
    }
    await modelFolder.create(recursive: true);
    await routesFolder.create(recursive: true);
    await configFolder.create(recursive: true);

    for (var collection in collections) {
      // ############################################################################
      // model file
      File modelFile = File(
          "${modelFolder.path}/${collection.collectionName.uncapitalize()}_model.js");
      modelFile
          .writeAsStringSync(dataService.modelData(collection, attributes));

      // ############################################################################
      // controller file
      File controllerFile = File(
          "${controllerFolder.path}\\${collection.collectionName.uncapitalize()}_controller.js");
      controllerFile.writeAsStringSync(
          dataService.controllerData(collection, attributes));

      // ############################################################################
      //*route file
      File collectionRouteFile = File(
          '${projectDir.path}\\routes\\${collection.collectionName.uncapitalize()}_routes.js');
      collectionRouteFile.writeAsStringSync(
          dataService.collectionRoutesData(collection, attributes));
    }

    // ############################################################################
    //*route file
    File appRouteFile = File('${projectDir.path}\\routes\\app_routes.js');
    appRouteFile
        .writeAsStringSync(dataService.appRoutesData(collections, attributes));

    // ############################################################################
    // *server file
    File serverFile =
        File('${downloadDirectoryPath!.path}/$projectName/index.js');
    String server = serverTemplate(serverAuthentication: serverAuthentication);
    serverFile.writeAsStringSync(server);

    // ############################################################################
    // *swagger documentation file
    File documentatiionFile =
        File('${downloadDirectoryPath!.path}/$projectName/documentation.yaml');
    String document = swaggerDocumentation(
      collection: collections,
      attributes: attributes,
      projectName: projectName,
      serverAuthentication: serverAuthentication,
    );
    documentatiionFile.writeAsStringSync(document);

    // ############################################################################
    // *middleware file
    File middlewareFile = File('${projectDir.path}\\middleware\\middleware.js');
    String middleware =
        middlewareTemplate(serverAuthentication: serverAuthentication);
    if (serverAuthentication.authenticationLevel !=
        AuthenticationLevel.NONE.name) {
      middlewareFile.writeAsStringSync(middleware);
    }
    // ############################################################################
    // * config file
    File configFile = File('${projectDir.path}\\config\\config.js');
    configFile.writeAsStringSync(
        dataService.mongoDbConfig(mongoDbUrl, serverAuthentication));
    log(homeController.currentStatus.name);
    homeController.updateCurrentStatus(Status.COMPLETED);
    log(homeController.currentStatus.name);
    if (isOpenInVsCode) {
      runCommand(workingDirectory: workingDirectory, command: 'code .')
          .then((value) {
        if (value) {
          log('Project Created Successfully');
        } else {}
      });
    }
    return true;
  }
}
