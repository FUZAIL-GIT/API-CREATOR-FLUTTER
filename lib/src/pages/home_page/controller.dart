import 'dart:developer';
import 'package:api_creator/src/pages/home_page/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:api_creator/src/common/enums/enums.dart';
import 'package:api_creator/src/common/models/project_details_model.dart';
import 'package:api_creator/src/common/models/server_details_model.dart';
import 'package:api_creator/src/common/routes/routes.dart';
import 'package:api_creator/src/common/services/network/internet_connectivity.dart';
import 'package:api_creator/src/common/services/project_scaffolding_service/code_scaffolding/code_scaffolding_service.dart';
import 'package:api_creator/src/common/models/collection_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../common/database/local_database/local_db.dart';
import '../../common/models/attribute_model.dart';
import '../../common/models/server_auth_model.dart';

class HomeController extends GetxController {
  // STEP 1: Stepper
  final RxInt _currentStep = 0.obs;
  FocusNode focusNode = FocusNode();
  int get currentStep => _currentStep.value;
  void tapped(int value) {
    _currentStep.value = value;
  }

  void continued() {
    // handle logic for moving to next step
    if (_currentStep.value == 0 && projectNameKey.currentState!.validate()) {
      _currentStep.value++;
      if (listOfCollections.isNotEmpty) {
        _selectedCollection.value = listOfCollections.first;
      }
    } else if (_currentStep.value == 1 && listOfCollections.isNotEmpty) {
      //###############################################
      // this algorithm verifies that all the collection have at least one document
      bool isValidate = true;
      for (var collection in listOfCollections) {
        int index = 0;
        Collection currentCollection = collection;
        for (var attribute in listOfAttributes) {
          if (currentCollection.collectionName ==
              attribute.collection.collectionName) {
            index++;
          }
        }
        if (index == 0) {
          Get.showSnackbar(
            GetSnackBar(
              title: "${currentCollection.collectionName} is Empty",
              message: 'a collection cannot be empty',
              leftBarIndicatorColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );

          isValidate = false;
          return;
        }
      }
      if (isValidate) {
        _currentStep.value++;
      }
    } else if (_currentStep.value == 1 && listOfCollections.isEmpty) {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'No Collections Added',
          message: 'you need to add atleast one collection',
          leftBarIndicatorColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (_currentStep.value == 2 &&
        mongoDbUrlKey.currentState!.validate()) {
      if (authenticationLevel == AuthenticationLevel.BASIC) {
        if (userNameKey.currentState!.validate() &&
            passwordKey.currentState!.validate()) {
          // createProject();
          _currentStep.value++;
        }
      } else if (authenticationLevel == AuthenticationLevel.TOKEN) {
        if (authorizationTokenKey.currentState!.validate()) {
          _currentStep.value++;
          // createProject();
        }
      } else if (authenticationLevel == AuthenticationLevel.NONE) {
        _currentStep.value++;
        // createProject();
      }
    } else if (currentStep == 3) {
      createProject();
    }
  }

  void cancel() {
    // handle logic for moving to previous step
    if (_currentStep.value > 0) {
      _currentStep.value--;
    }
  }

  // STEP 2: Collections
  RxList<Collection> listOfCollections = <Collection>[].obs;
  final RxBool _isTimeStamp = true.obs;
  bool get isTimeStamp => _isTimeStamp.value;
  final RxBool _isPagination = true.obs;
  bool get isPagination => _isPagination.value;
  TextEditingController collectionName = TextEditingController();
  GlobalKey<FormState> collectionNameKey = GlobalKey<FormState>();
  FocusNode collectionNameFocusNode = FocusNode();
  void addCollectionToList() {
    // handle logic for adding collection to list
    if (collectionNameKey.currentState!.validate()) {
      listOfCollections.add(
        Collection(
          collectionName: collectionName.text.replaceAll(' ', ''),
          isTimeStamp: _isTimeStamp.value,
          isPagination: _isPagination.value,
        ),
      );
      if (listOfCollections.length == 1) {
        selectCollection(listOfCollections.first);
      }
      collectionName.clear();
      _isTimeStamp.value = true;
      listOfCollections.refresh();
    }
  }

  void removeCollectionFromList(int index) {
    // handle logic for removing collection from list
    listOfCollections.removeAt(index - 1);
    _selectedCollection.value = Collection(
      collectionName: '',
      isTimeStamp: true,
      isPagination: true,
    );
    listOfCollections.refresh();
  }

  // STEP 3: Attributes
  RxList<Attribute> listOfAttributes = <Attribute>[].obs;
  final RxBool _isUniqueField = false.obs;
  bool get isUniqueField => _isUniqueField.value;
  final RxBool _isRequiredField = true.obs;
  bool get isRequiredField => _isRequiredField.value;
  List<String> dataTypes = [
    'Boolean',
    'Number',
    'String',
    'Array',
    'Map',
    'Date',
  ];
  final Rx<Collection> _selectedCollection =
      Collection(collectionName: '', isTimeStamp: true, isPagination: true).obs;
  Collection get selectedCollection => _selectedCollection.value;
  final RxString _selectedDataType = 'String'.obs;
  final RxBool _isEdit = false.obs;
  bool get isEdit => _isEdit.value;
  String get selectedDataType => _selectedDataType.value;
  TextEditingController fieldName = TextEditingController();
  GlobalKey<FormState> fieldNameKey = GlobalKey<FormState>();
  FocusNode fieldNameFocusNode = FocusNode();
  void selectCollection(Collection collection) {
    // handle logic for selecting collection
    _selectedCollection.value = collection;
  }

  void addFieldToCollection() {
    // handle logic for adding field to collection
    bool isAlreadyExist = false;
    if (fieldNameKey.currentState!.validate()) {
      for (var element in listOfAttributes) {
        if (element.fieldName == fieldName.text &&
            element.collection.collectionName ==
                _selectedCollection.value.collectionName) {
          isAlreadyExist = true;
        }
      }
      if (!isAlreadyExist) {
        listOfAttributes.add(
          Attribute(
            fieldName: fieldName.text.replaceAll(' ', ''),
            fieldDataType: _selectedDataType.value,
            isRequired: _isRequiredField.value,
            isUnique: _isUniqueField.value,
            collection: _selectedCollection.value,
          ),
        );
      } else {
        log('', error: 'Field Already Exist');
      }

      fieldName.clear();
      _selectedDataType.value = 'String';
      _isRequiredField.value = true;
      _isUniqueField.value = false;
      listOfAttributes.refresh();
    }
  }

  void updateField(int index) {
    // handle logic for adding field to collection

    if (fieldNameKey.currentState!.validate()) {
      listOfAttributes.removeAt(index);
      listOfAttributes.insert(
        index,
        Attribute(
          fieldName: fieldName.text,
          fieldDataType: _selectedDataType.value,
          isRequired: _isRequiredField.value,
          isUnique: _isUniqueField.value,
          collection: _selectedCollection.value,
        ),
      );

      fieldName.clear();
      _selectedDataType.value = 'String';
      _isRequiredField.value = true;
      _isUniqueField.value = false;
      listOfAttributes.refresh();
    }
  }

  void removeFieldFromDocument(int index) {
    // handle logic for removing field from collection
    listOfAttributes.removeAt(index);
    listOfAttributes.refresh();
  }

  void onDropDownChange(String? value) {
    // handle logic for changing selected data type
    _selectedDataType.value = value!;
  }

  void assignInitialValue(Attribute field) {
    fieldName.text = field.fieldName;
    _isRequiredField.value = field.isRequired;
    _isUniqueField.value = field.isUnique;
    _selectedDataType.value = field.fieldDataType;
  }

  void isRequiredChange(bool? value) {
    // handle logic for changing isRequired field
    _isRequiredField.value = value!;
  }

  void isUniqueChange(bool? value) {
    // handle logic for changing isUnique field
    _isUniqueField.value = value!;
  }

  void isTimeStampChange(bool? value) {
    // handle logic for changing isTimeStamp field
    _isTimeStamp.value = value!;
  }

  void isOpenInVsCodeChange(bool? value) {
    // handle logic for changing is open vs code or not
    _openInVsCode.value = value!;
  }

  void isAutomaticallyInstallPackagesChnage(bool? value) async {
    // handle logic for changing automatically install packages or not
    if (value! && await InternetConnectivity().isInternetAvailable() == false) {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Internet not avaiable',
          message: 'you need to install packages manually',
          leftBarIndicatorColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _automaticallyInstallPackages.value = value;
    }
  }

  void selectAuthentication(AuthenticationLevel? value) {
    _authenticationLevel.value = value!;
  }

  void isPaginationChange(bool? value) {
    // handle logic for changing isTimeStamp field
    _isPagination.value = value!;
  }

  // STEP 4: Server Project
  TextEditingController mongoDbUrl = TextEditingController();
  FocusNode mongoDbUrlFocusNode = FocusNode();
  GlobalKey<FormState> mongoDbUrlKey = GlobalKey<FormState>();
  TextEditingController authorizationToken = TextEditingController();
  GlobalKey<FormState> authorizationTokenKey = GlobalKey<FormState>();
  FocusNode authorizationTokenFocusNode = FocusNode();
  TextEditingController userName = TextEditingController();
  GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  FocusNode userNameFocusNode = FocusNode();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController projectName = TextEditingController();
  FocusNode projectNameFocusNode = FocusNode();
  GlobalKey<FormState> projectNameKey = GlobalKey<FormState>();
  int id = 0;
  RxString errorMessage = ''.obs;
  Stopwatch stopwatch = Stopwatch();
  final RxBool _automaticallyInstallPackages = true.obs;
  final RxBool _openInVsCode = true.obs;
  bool get automaticallyInstallPackages => _automaticallyInstallPackages.value;
  bool get openVsCode => _openInVsCode.value;
  final Rx<AuthenticationLevel> _authenticationLevel =
      AuthenticationLevel.NONE.obs;
  AuthenticationLevel get authenticationLevel => _authenticationLevel.value;
  final Rx<Status> _currentStatus = Status.IDLE.obs;
  Status get currentStatus => _currentStatus.value;
  RxDouble progressIndicatorPercentage = 0.0.obs;

  void createProject() {
    // handle logic for server authentication
    late ServerAuthentication serverAuthentication;
    if (authenticationLevel == AuthenticationLevel.BASIC) {
      serverAuthentication = ServerAuthentication.basic(
        userName: userName.text,
        password: password.text,
      );
    } else if (authenticationLevel == AuthenticationLevel.TOKEN) {
      serverAuthentication = ServerAuthentication.token(
        token: authorizationToken.text,
      );
    } else if (authenticationLevel == AuthenticationLevel.NONE) {
      serverAuthentication = ServerAuthentication.none();
    }

    // handle logic for creating server project
    CodeScaffoldingService codeTemplateService = CodeScaffoldingService();
    //call a timeout function to terminate the programe after some time
    codeTemplateService.createProject(
      projectName: projectName.text,
      collections: listOfCollections,
      mongoDbUrl: mongoDbUrl.text,
      attributes: listOfAttributes,
      serverAuthentication: serverAuthentication,
      isPagination: false,
      isTimestamp: false,
      isEdit: _isEdit.value,
      isInstallPackages: _automaticallyInstallPackages.value,
      isOpenInVsCode: _openInVsCode.value,
    );
    Get.defaultDialog(
        barrierDismissible: false,
        title: '',
        titlePadding: EdgeInsets.zero,
        content: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: progressIndicatorPercentage.value == 1.0,
                replacement: const Text('Creating...'),
                child: _currentStatus.value == Status.FAIL
                    ? Text(errorMessage.value)
                    : RichText(
                        text: TextSpan(
                          text: 'Created in ',
                          children: [
                            TextSpan(
                                text: (stopwatch.elapsedMilliseconds / 1000)
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                )),
                            const TextSpan(text: ' seconds')
                          ],
                        ),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 17.0,
                percent: _currentStatus.value == Status.FAIL
                    ? 1.0
                    : progressIndicatorPercentage.value,
                center: Text(
                  _currentStatus.value == Status.FAIL
                      ? 'FAILED'
                      : _currentStatus.value == Status.LOADING
                          ? "npm initializing"
                          : _currentStatus.value == Status.INITIALIZED
                              ? "npm install packages"
                              : 'Project Created \nSuccessfully',
                  textAlign: TextAlign.center,
                ),
                progressColor: _currentStatus.value == Status.FAIL
                    ? Colors.red
                    : Colors.deepPurpleAccent,
                animation: true,
                animationDuration: 1000,
                animateFromLastPercent: true,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: progressIndicatorPercentage.value == 1.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentStatus.value != Status.FAIL) {
                      ProjectDetails projectDetails = ProjectDetails(
                        createdAt: DateTime.now(),
                        updatedAt: [],
                        projectName: projectName.text,
                        servertDetails: ServerDetails(
                          attributes: listOfAttributes,
                          collections: listOfCollections,
                          mongoDbUrl: mongoDbUrl.text,
                          serverAuthentication: serverAuthentication,
                        ),
                      );
                      if (!_isEdit.value) {
                        LocalDatabase.writeDocument(
                            data: projectDetails,
                            collectionName: 'projectInfo');
                      } else {
                        LocalDatabase.updateDocument(
                            collectionName: 'projectInfo',
                            id: id,
                            data: projectDetails);
                      }
                    }
                    stopwatch.reset();
                    Get.offAndToNamed(AppRoutes.DASHBOARD);
                  },
                  child: const Text('Finish'),
                ),
              )
            ],
          ),
        ));
  }

  void updateProject(ProjectDetails projectDetails) {
    // handle logic for assigning value in case of update the project
    _isEdit.value = true;
    id = projectDetails.id!;
    _currentStep.value = 0;
    projectName.text = projectDetails.projectName;
    listOfCollections.value = projectDetails.servertDetails.collections;
    listOfAttributes.value = projectDetails.servertDetails.attributes;
    mongoDbUrl.text = projectDetails.servertDetails.mongoDbUrl;
    _authenticationLevel.value = projectDetails
                .servertDetails.serverAuthentication.authenticationLevel ==
            'NONE'
        ? AuthenticationLevel.NONE
        : projectDetails
                    .servertDetails.serverAuthentication.authenticationLevel ==
                'BASIC'
            ? AuthenticationLevel.BASIC
            : AuthenticationLevel.TOKEN;
    userName.text =
        projectDetails.servertDetails.serverAuthentication.userName ?? '';
    password.text =
        projectDetails.servertDetails.serverAuthentication.password ?? '';
    authorizationToken.text =
        projectDetails.servertDetails.serverAuthentication.token ?? '';
  }

// keyboard shortcut settings
  Map<Set<LogicalKeyboardKey>, VoidCallback> keyboardShortcuts(
      BuildContext buildContext) {
    return {
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyN}: continued,
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyC}:
          currentStep == 1 ? addCollectionToList : () {},
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.arrowDown}:
          currentStep == 1 ? collectionScrollUp : () {},
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.arrowUp}:
          currentStep == 1 ? collectionScrollDown : () {},
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shift}:
          currentStep == 1 ? addFieldToCollection : () {},
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyA}:
          currentStep == 1
              ? () {
                  attributePrompt(context: buildContext);
                }
              : () {},
    };
  }

  void collectionScrollUp() {
    if (listOfCollections.length > 1) {
      for (var i = 0; i < listOfCollections.length; i++) {
        if (listOfCollections[i].collectionName ==
            _selectedCollection.value.collectionName) {
          if (i + 1 < listOfCollections.length) {
            _selectedCollection.value = listOfCollections[++i];
          }
          break;
        }
      }
    }
  }

  void collectionScrollDown() {
    if (listOfCollections.length > 1) {
      for (var i = 0; i < listOfCollections.length; i++) {
        if (listOfCollections[i].collectionName ==
            _selectedCollection.value.collectionName) {
          if (i > 0) {
            _selectedCollection.value = listOfCollections[--i];
          }
          break;
        }
      }
    }
  }

  void updateCurrentStatus(Status value) {
    // handle logic for changing status
    _currentStatus.value = value;
    if (value == Status.LOADING) {
      progressIndicatorPercentage.value = 0.3;
      stopwatch.start();
    } else if (value == Status.INITIALIZED) {
      progressIndicatorPercentage.value = 0.5;
    } else if (value == Status.INITIALIZED) {
      progressIndicatorPercentage.value = 0.8;
    } else if (value == Status.COMPLETED) {
      progressIndicatorPercentage.value = 1.0;
      stopwatch.stop();
    }
  }

  void throwError(String error) {
    _currentStatus.value = Status.FAIL;
    errorMessage.value = error;
    progressIndicatorPercentage.value = 1.0;
  }

  @override
  void onInit() async {
    _automaticallyInstallPackages.value =
        await InternetConnectivity().isInternetAvailable();
    focusNode.requestFocus();

    projectNameFocusNode.requestFocus();
    super.onInit();
  }
}
