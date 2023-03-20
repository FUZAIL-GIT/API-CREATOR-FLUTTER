import 'package:flutter/material.dart';
import 'package:node_server_maker/src/pages/home_page/controller.dart';
import 'package:get/get.dart';
import 'package:node_server_maker/src/pages/home_page/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
    return Padding(
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
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: const Text('Create'),
            ),
        ],
      ),
    );
  }
}
