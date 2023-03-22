import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:node_server_maker/src/common/routes/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.HOME);
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
    );
  }
}
