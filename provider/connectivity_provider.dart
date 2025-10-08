import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ConnectionVia { online, offline }

class ConnectivityProvider with ChangeNotifier {
  bool _isonline = false;
  bool get isOnline => _isonline;
  // Create our public controller

  ConnectivityProvider() {
    Connectivity _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateconn(result);
    });

  }
  

retryConnection() async {
  try {
    final response = await http.get(Uri.parse('https://xcaldata.com/'));
    if (response.statusCode == 200) {
      _isonline = true; // Website is online
      notifyListeners();
    } else {
      _isonline = false; // Website is offline or returned an error
      notifyListeners();
    }
  } catch (e) {
    // Error occurred during the request, website might be offline
    _isonline = false;
  }

  
}

  // _updateconn_bystatus(bool  ){
  //   if (result == ConnectivityResult.none) {
  //     _isonline = false;
  //     notifyListeners();
  //   } else {
  //     _isonline = true;
  //     notifyListeners();
  //   }
  // }
  _updateconn(List<ConnectivityResult> result) {
    if (result == ConnectivityResult.none) {
      _isonline = false;
      notifyListeners();
    } else {
      _isonline = true;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}
