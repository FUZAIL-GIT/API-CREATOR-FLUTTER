import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/dashboard_page/bindings.dart';
import '../../pages/dashboard_page/view.dart';
import '../../pages/home_page/bindings.dart';
import '../../pages/home_page/view.dart';
import 'routes.dart';

class AppPages {
  static Duration transitionDuration = const Duration(seconds: 1);

  static List<String> history = [];
  static final List<GetPage> routes = [
    // DashBoard
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardScreenBindings(),
      transition: Transition.fade,
      transitionDuration: transitionDuration,
      curve: Curves.easeInOut,
    ),
    // Home
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeScreenBindings(),
      transition: Transition.fadeIn,
      transitionDuration: transitionDuration,
      curve: Curves.ease,
    ),
  ];
}
