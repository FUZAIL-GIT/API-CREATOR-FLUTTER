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
