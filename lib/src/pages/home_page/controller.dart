import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:node_server_maker/src/common/enums/enums.dart';
import 'package:node_server_maker/src/common/services/network/internet_connectivity.dart';
import 'package:node_server_maker/src/common/services/project_scaffolding_service/code_scaffolding/code_scaffolding_service.dart';
import 'package:node_server_maker/src/pages/home_page/model.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../common/services/project_scaffolding_service/models/server_auth_model.dart';

class HomeController extends GetxController {
  // STEP 1: Stepper
  final RxInt _currentStep = 0.obs;
  int get currentStep => _currentStep.value;
  void tapped(int value) {
    _currentStep.value = value;
  }

  void continued() {
    // handle logic for moving to next step
    if (_currentStep.value == 0 && projectNameKey.currentState!.validate()) {
      _currentStep.value++;
    } else if (_currentStep.value == 1 && listOfCollections.isNotEmpty) {
      //###############################################
      // this algorithm verifies that all the collection have at least one document
      bool isValidate = true;
      for (var collection in listOfCollections) {
        int index = 0;
        Collection currentCollection = collection;
        for (var attribute in listOfAttributes) {
          if (currentCollection == attribute.collection) {
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
  void addCollectionToList() {
    // handle logic for adding collection to list
    if (collectionNameKey.currentState!.validate()) {
      listOfCollections.add(
        Collection(
          collectionName: collectionName.text,
          isTimeStamp: _isTimeStamp.value,
          isPagination: _isPagination.value,
        ),
      );
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
  RxList<Field> listOfAttributes = <Field>[].obs;
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
  String get selectedDataType => _selectedDataType.value;
  TextEditingController fieldName = TextEditingController();
  GlobalKey<FormState> fieldNameKey = GlobalKey<FormState>();
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
          Field(
            fieldName: fieldName.text,
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
        Field(
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

  void assignInitialValue(Field field) {
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
  GlobalKey<FormState> mongoDbUrlKey = GlobalKey<FormState>();
  TextEditingController authorizationToken = TextEditingController();
  GlobalKey<FormState> authorizationTokenKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  TextEditingController projectName = TextEditingController();
  GlobalKey<FormState> projectNameKey = GlobalKey<FormState>();
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
        authenticationLevel: authenticationLevel,
        userName: userName.text,
        password: password.text,
      );
    } else if (authenticationLevel == AuthenticationLevel.TOKEN) {
      serverAuthentication = ServerAuthentication.token(
        authenticationLevel: authenticationLevel,
        token: authorizationToken.text,
      );
    } else if (authenticationLevel == AuthenticationLevel.NONE) {
      serverAuthentication =
          ServerAuthentication.none(authenticationLevel: authenticationLevel);
    }

    // handle logic for creating server project
    CodeScaffoldingService codeTemplateService = CodeScaffoldingService();
    codeTemplateService.createProject(
      projectName: projectName.text,
      collections: listOfCollections,
      mongoDbUrl: mongoDbUrl.text,
      attributes: listOfAttributes,
      serverAuthentication: serverAuthentication,
      isPagination: false,
      isTimestamp: false,
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
                child: RichText(
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
                percent: progressIndicatorPercentage.value,
                center: Text(
                  _currentStatus.value == Status.LOADING
                      ? "npm initializing"
                      : _currentStatus.value == Status.INITIALIZED
                          ? "npm install packages"
                          : _currentStatus.value == Status.COMPLETED
                              ? "Project Created \nSuccessfully"
                              : '',
                  textAlign: TextAlign.center,
                ),
                progressColor: Colors.deepPurpleAccent,
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
                    Get.back();
                    stopwatch.reset();
                  },
                  child: const Text('Finish'),
                ),
              )
            ],
          ),
        ));
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

    log('$value / $progressIndicatorPercentage');
  }

// for testing purpose
  @override
  void onInit() async {
    mongoDbUrl.text = "mongodb://localhost:27017";
    _automaticallyInstallPackages.value =
        await InternetConnectivity().isInternetAvailable();
    super.onInit();
  }
}
