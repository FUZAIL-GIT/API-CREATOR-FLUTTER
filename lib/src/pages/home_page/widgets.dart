import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:api_creator/src/common/enums/enums.dart';
import 'controller.dart';
import '../../common/models/collection_model.dart';

Step inputStepPrompt({
  required HomeController controller,
  required TextEditingController textEditingController,
  required BuildContext context,
  GlobalKey<FormState>? formKey,
  required int index,
  required String label,
  required String hintText,
  required bool validation,
  Color? borderColor,
}) {
  return Step(
    title: Text(label),
    content: Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Form(
          key: formKey,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == '') {
                return 'Please Enter $label Name';
              }
              return null;
            },
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        ),
      ],
    ),
    isActive: controller.currentStep >= 0,
    state: controller.currentStep > index
        ? StepState.complete
        : StepState.disabled,
  );
}

Step collectionPrompt({
  required HomeController controller,
  required BuildContext context,
}) {
  return Step(
    title: const Text('Collections'),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: Form(
                key: controller.collectionNameKey,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty || value == '') {
                      return 'Please Enter Collection Name';
                    }
                    if (isNumberic(value)) {
                      return 'Numbers not allowed';
                    }
                    if (value.isNotEmpty || value != '') {
                      bool isAlreadyExist = false;
                      for (var element in controller.listOfCollections) {
                        if (element.collectionName == value) {
                          isAlreadyExist = true;
                        }
                      }
                      if (isAlreadyExist) {
                        return 'collection already exist';
                      }
                    }
                    return null;
                  },
                  controller: controller.collectionName,
                  decoration: InputDecoration(
                    hintText: 'Collection Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: CheckboxListTile(
                activeColor: Theme.of(context).colorScheme.onSurface,
                tileColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                value: controller.isTimeStamp,
                onChanged: controller.isTimeStampChange,
                title: Text(
                  "Timestamp",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: CheckboxListTile(
                activeColor: Theme.of(context).colorScheme.onSurface,
                tileColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                value: controller.isPagination,
                onChanged: controller.isPaginationChange,
                title: Text(
                  "Pagination",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              child: IconButton(
                onPressed: () {
                  controller.addCollectionToList();
                },
                icon: const Icon(Icons.add),
              ),
            )
          ],
        ),
        //###########################################################
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.50,
                // width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.listOfCollections.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: const [
                            ListTile(
                              title: Text(
                                "Collection",
                                style: TextStyle(),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      } else {
                        Collection collection =
                            controller.listOfCollections[index - 1];
                        return Obx(() => ListTile(
                              tileColor:
                                  controller.selectedCollection == collection
                                      ? Theme.of(context).colorScheme.onTertiary
                                      : Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              onTap: () {
                                controller.selectCollection(collection);
                              },
                              title: Text(
                                collection.collectionName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              trailing: Visibility(
                                visible:
                                    controller.selectedCollection == collection,
                                child: IconButton(
                                  onPressed: () {
                                    controller.removeCollectionFromList(index);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                              ),
                              // trailing: Text(field.fieldDataType),
                            ));
                      }
                    }),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.50,
                width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.onTertiary,
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.listOfAttributes.length + 1,
                    itemBuilder: (context, index) {
                      // Field field = controller.listOfAttributes[index - 1];
                      return index == 0
                          ? Column(
                              children: [
                                Obx(
                                  () => ListTile(
                                    title: Text(
                                      "Document : ${controller.selectedCollection.collectionName}",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceTint),
                                    ),
                                    leading: Visibility(
                                      visible: controller.selectedCollection
                                              .collectionName !=
                                          '',
                                      child: IconButton(
                                        onPressed: () {
                                          attributePrompt(
                                              context: context,
                                              controller: controller);
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline_rounded,
                                          size: 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                    minLeadingWidth: 0,
                                  ),
                                ),
                                const Divider(),
                              ],
                            )
                          : Obx(() {
                              return controller.listOfAttributes[index - 1]
                                          .collection.collectionName ==
                                      controller
                                          .selectedCollection.collectionName
                                  ? GestureDetector(
                                      onDoubleTap: () {
                                        controller
                                            .removeFieldFromDocument(index - 1);
                                      },
                                      child: ExpansionTile(
                                        title: Text(
                                          controller.listOfAttributes[index - 1]
                                              .fieldName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),

                                        leading: IconButton(
                                          onPressed: () {
                                            controller.assignInitialValue(
                                              controller
                                                  .listOfAttributes[index - 1],
                                            );
                                            attributePrompt(
                                              context: context,
                                              controller: controller,
                                              isEditable: true,
                                              index: index - 1,
                                            );
                                            // controller.removeFieldFromDocument(
                                            //     index - 1);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.cyan,
                                          ),
                                        ),
                                        // subtitle: Text('Trailing expansion arrow icon'),
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              '\t\t\t\t\t\t\t\t\t\t\tRequired : ${controller.listOfAttributes[index - 1].isRequired}',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              '\t\t\t\t\t\t\t\t\t\t\tUnique : ${controller.listOfAttributes[index - 1].isUnique}',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox();
                            });
                    })),
              ),
            ),
          ],
        )
      ],
    ),
    isActive: controller.currentStep >= 0,
    state: controller.currentStep > 1 ? StepState.complete : StepState.disabled,
  );
}

Step finishSection({
  required HomeController controller,
  required BuildContext context,
}) {
  return Step(
    title: const Text('Finish'),
    content: Column(
      children: [
        CheckboxMenuButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimary),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          value: controller.automaticallyInstallPackages,
          onChanged: controller.isAutomaticallyInstallPackagesChnage,
          child: Text(
            "automatically install packages",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CheckboxMenuButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          value: controller.openVsCode,
          onChanged: controller.isOpenInVsCodeChange,
          child: Text(
            "open in vs code after create",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      ],
    ),
    isActive: controller.currentStep >= 0,
    state:
        controller.currentStep == 3 ? StepState.complete : StepState.disabled,
  );
}

Future<void> attributePrompt({
  required BuildContext context,
  required HomeController controller,
  bool isEditable = false,
  int? index,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (builder) {
        return AlertDialog(
          title: const Text('Schema'),
          content: IntrinsicHeight(
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Form(
                          key: controller.fieldNameKey,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
                                return 'Please Enter Field Name';
                              }
                              if (isNumberic(value)) {
                                return 'Numbers not allowed';
                              }
                              return null;
                            },
                            controller: controller.fieldName,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              labelText: 'Field Name',
                              labelStyle: const TextStyle(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButton<String>(
                            dropdownColor:
                                Theme.of(context).colorScheme.secondary,
                            focusColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            underline: const SizedBox(),
                            value: controller.selectedDataType,
                            style: const TextStyle(color: Colors.white),
                            onChanged: controller.onDropDownChange,
                            items: controller.dataTypes.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: CheckboxListTile(
                          activeColor: Theme.of(context).colorScheme.onSurface,
                          tileColor: Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          value: controller.isRequiredField,
                          onChanged: controller.isRequiredChange,
                          title: Text(
                            "Required",
                            style: TextStyle(color: Colors.grey.shade900),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: CheckboxListTile(
                          activeColor: Theme.of(context).colorScheme.onSurface,
                          tileColor: Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          value: controller.isUniqueField,
                          onChanged: controller.isUniqueChange,
                          title: Text(
                            "Unique",
                            style: TextStyle(color: Colors.grey.shade900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(isEditable ? 'Update' : 'Add'),
              onPressed: () {
                if (!isEditable) {
                  controller.addFieldToCollection();
                  Navigator.pop(context);
                } else {
                  controller.updateField(index!);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      });
}

Step database({
  required BuildContext context,
  required HomeController controller,
}) {
  return Step(
    title: const Text('DataBase'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Authentication : ',
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton(
                value: controller.authenticationLevel,
                dropdownColor: Theme.of(context).colorScheme.secondary,
                focusColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                // icon: const SizedBox(),
                underline: const SizedBox(),
                items: [
                  AuthenticationLevel.NONE,
                  AuthenticationLevel.BASIC,
                  AuthenticationLevel.TOKEN
                ].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectAuthentication(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: controller.authenticationLevel != AuthenticationLevel.NONE,
          child: Visibility(
            visible:
                controller.authenticationLevel == AuthenticationLevel.BASIC,
            replacement: Form(
              key: controller.authorizationTokenKey,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value == '') {
                      return 'Please Enter Token';
                    }
                    return null;
                  },
                  controller: controller.authorizationToken,
                  decoration: InputDecoration(
                    labelText: 'Bearer Token',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ),
              ),
            ),
            child: Column(
              children: [
                Form(
                  key: controller.userNameKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Please Enter Username';
                      }
                      return null;
                    },
                    controller: controller.userName,
                    decoration: InputDecoration(
                      labelText: 'UserName',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: controller.passwordKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Please Enter Username';
                      }
                      return null;
                    },
                    controller: controller.password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 20,
        ),
        Form(
          key: controller.mongoDbUrlKey,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == '') {
                return 'Please Enter Mongo Db Url';
              }
              return null;
            },
            controller: controller.mongoDbUrl,
            decoration: InputDecoration(
              labelText: 'Mongo Db Url',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        ),
      ],
    ),
    isActive: controller.currentStep >= 0,
    state: controller.currentStep > 2 ? StepState.complete : StepState.disabled,
  );
}

bool isNumberic(String value) {
  //numbers validation
  for (var i = 0; i < value.length; i++) {
    if (double.tryParse(value[i]) != null) {
      return true;
    }
  }
  return false;
}
