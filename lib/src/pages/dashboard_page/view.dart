import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:node_server_maker/src/common/database/local_database/local_db.dart';
import 'package:node_server_maker/src/common/models/project_details_model.dart';
import 'package:node_server_maker/src/common/routes/routes.dart';
import 'package:node_server_maker/src/pages/dashboard_page/controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAllNamed(AppRoutes.HOME);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        title: Text(
          "Node Api Maker",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: controller.obx(
        (state) {
          return GridView.builder(
            itemCount: state?.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) {
              ProjectDetails projectDetails = state![index];
              return GestureDetector(
                onDoubleTap: () {
                  LocalDatabase.deleteDocument(
                      collectionName: 'projectInfo', id: projectDetails.id!);
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'Project Name : ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceTint,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          children: [
                            TextSpan(
                              text: projectDetails.projectName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        onLoading: const LinearProgressIndicator(),
        onEmpty: const Center(
          child: Text('No Project Created yet'),
        ),
        onError: (error) {
          return Center(
            child: Text(error ?? ''),
          );
        },
      ),
    );
  }
}
