extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String uncapitalize() {
    return "${this[0].toLowerCase()}${substring(1).toLowerCase()}";
  }
}
