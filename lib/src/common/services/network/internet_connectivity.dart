import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivity {
  Future<bool> isInternetAvailable() async {
    bool isConnected = false;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isConnected = true;
    }
    return isConnected;
  }
}
