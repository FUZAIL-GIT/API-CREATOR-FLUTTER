// Import necessary packages and dependencies
import 'dart:developer';
import 'package:api_creator/src/common/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:api_creator/src/common/models/project_details_model.dart';
import 'package:api_creator/src/common/routes/routes.dart';
import 'package:api_creator/src/pages/dashboard_page/controller.dart';

// Define class DashboardScreen which extends GetView with Generic type DashboardController
class DashboardScreen extends GetView<DashboardController> {
  // Constructor for DashboardScreen
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain width and height of screen
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Return a Scaffold widget with a controller observer,
    // containing a Stack widget which has a Container and a GridView builder as children
    return Scaffold(
      body: controller.obx(
        (state) {
          return Stack(
            children: [
              Container(
                height: height * 0.35,
                width: double.infinity,
                alignment: Alignment.topCenter,
                // color: Theme.of(context).colorScheme.surfaceTint,
                color: Colors.grey.shade800,
                padding: Responsive.isTablet(context)
                    ? EdgeInsets.only(left: 160, right: 150, top: height * 0.08)
                    : Responsive.isDesktop(context)
                        ? EdgeInsets.only(
                            left: 260, right: 250, top: height * 0.08)
                        : EdgeInsets.only(
                            left: 60, right: 50, top: height * 0.08),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your projects',
                    style: TextStyle(
                      fontSize: width > 800.0 && width < 1200
                          ? 30
                          : width > 1200.0
                              ? 30
                              : 25,
                      fontFamily: 'EncodeSansSC_Condensed',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: Responsive.isTablet(context)
                    ? EdgeInsets.only(left: 150, right: 150, top: height * 0.16)
                    : Responsive.isDesktop(context)
                        ? EdgeInsets.only(
                            left: 250, right: 250, top: height * 0.16)
                        : EdgeInsets.only(
                            left: 50, right: 50, top: height * 0.16),
                child: GridView.builder(
                  itemCount: state!.length + 1,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, crossAxisSpacing: 5.0),
                  itemBuilder: (context, index) {
                    log('$index');

                    // If index is zero, return gesture detector containing container and text
                    // to add a new project
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          Get.offAllNamed(AppRoutes.HOME);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 50,
                                color:
                                    Theme.of(context).colorScheme.surfaceTint,
                              ),
                              Text(
                                'Add project',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surfaceTint,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }

                    // If index is greater than zero, return container containing details of project
                    else if (index > 0) {
                      ProjectDetails projectDetails = state[index - 1];
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade900,
                          color: Theme.of(context).colorScheme.surfaceTint,

                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                projectDetails.projectName,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey.shade800,
                                  fontFamily: 'Orbitron',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                DateFormat.yMMMMEEEEd()
                                    .format(projectDetails.createdAt),
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'EncodeSansSC_Condensed',
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Get.offAllNamed(AppRoutes.HOME,
                                    arguments: projectDetails);
                              },
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Otherwise return null
                    return null;
                  },
                ),
              ),
            ],
          );
        },
        onLoading: const LinearProgressIndicator(),
        onError: (error) {
          return Center(
            child: Text(error ?? ''),
          );
        },
      ),
    );
  }
}
