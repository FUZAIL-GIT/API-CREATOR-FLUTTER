// import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class InternetConnectivity {
  // Future<bool> isInternetAvailable() async {
  //   bool isConnected = false;
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     // I am connected to a mobile network.
  //     isConnected = true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     // I am connected to a wifi network.
  //     isConnected = true;
  //   }
  //   return isConnected;
  // }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
