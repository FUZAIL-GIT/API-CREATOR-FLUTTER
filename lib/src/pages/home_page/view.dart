import 'package:flutter/material.dart';
import 'package:node_server_maker/src/common/models/project_details_model.dart';
import 'package:node_server_maker/src/common/routes/routes.dart';
import 'package:node_server_maker/src/pages/home_page/controller.dart';
import 'package:get/get.dart';
import 'package:node_server_maker/src/pages/home_page/widgets.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectDetails? projectDetails = Get.arguments;
    if (projectDetails != null) {
      controller.updateProject(projectDetails);
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.offAndToNamed(AppRoutes.DASHBOARD);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return stepperButton(
                context: context,
                details: details,
                homeController: controller,
              );
            },
            type: StepperType.vertical,
            physics: const BouncingScrollPhysics(),
            currentStep: controller.currentStep,
            onStepTapped: (step) => controller.tapped,
            onStepContinue: controller.continued,
            onStepCancel: controller.cancel,
            steps: [
              inputStepPrompt(
                controller: controller,
                context: context,
                textEditingController: controller.projectName,
                formKey: controller.projectNameKey,
                index: 0,
                label: 'Project',
                hintText: 'Project Name',
                validation: true,
              ),
              collectionPrompt(controller: controller, context: context),
              database(context: context, controller: controller),
              finishSection(controller: controller, context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget stepperButton(
      {required BuildContext context,
      required ControlsDetails details,
      required HomeController homeController}) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            if (homeController.currentStep > 0)
              ElevatedButton(
                onPressed: details.onStepCancel,
                child: const Text('Back'),
              ),
            const SizedBox(width: 10),
            if (homeController.currentStep <= 2)
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: const Text('Next'),
              ),
            if (homeController.currentStep == 3)
              homeController.isEdit
                  ? ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Update'),
                    )
                  : ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Create'),
                    ),
          ],
        ),
      ),
    );
  }
}
