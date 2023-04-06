// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:amoi/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class CONNECTIVITE {
  Future<bool> checkData(_showToast) async {
    bool isPlatformValide = false;
    loading.show("Verification de connexion ...");

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      isPlatformValide = true;
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      isPlatformValide = false;
    } else {
      isPlatformValide = false;
    }
    if (!isPlatformValide) return loading.hide();
    if (!isPlatformValide) return true;

    // 1) -> check Data
    bool isConnectedInternet = await isActiveDataMobile();
    if (!isConnectedInternet) loading.hide();
    if (!isConnectedInternet) _showToast("Veuillez activer votre connexion");
    if (!isConnectedInternet) return false;

    // 2) -> check Connexion
    bool isHaveInternet = await isHaveMega();
    if (!isHaveInternet) loading.hide();
    if (!isHaveInternet) _showToast("Veuillez verifier votre connexion");
    if (!isHaveInternet) return false;

    loading.hide();
    return true;
  }

  Future<bool> isActiveDataMobile() async {
    bool res = false;
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      res = true;
    } else if (result == ConnectivityResult.mobile) {
      res = true;
    } else {
      res = false;
    }
    return res;
  }

  Future<bool> isHaveMega() async {
    bool res = false;
    try {
      await InternetAddress.lookup('www.google.com');
      res = true;
    } on SocketException {
      res = false;
    }
    return res;
  }
}
