import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String uncapitalize() {
    return "${this[0].toLowerCase()}${substring(1).toLowerCase()}";
  }

  String toDateTime() {
    return DateFormat.EEEE().format(DateTime.parse(this));
  }
}

extension RandomString on int {
  String toRandomString() {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    final randomString = List.generate(
        this, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }
}

extension SpaceXY on double {
  SizedBox get spaceX => SizedBox(width: this);
  SizedBox get spaceY => SizedBox(height: this);
}
