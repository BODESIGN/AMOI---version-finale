import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LOADING {
  int vu = 0; // 0 : dismissed      1 : toast    2 : progress

  setConfig() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.blue
      ..backgroundColor = Colors.amber
      ..indicatorColor = Colors.red
      ..textColor = Colors.black
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  show(String message) async {
    vu = 1;
    await EasyLoading.show(
        status: message, maskType: EasyLoadingMaskType.black);
  }

  showProgress(double val, String message) {
    if (vu == 1) hide();
    vu = 2;
    EasyLoading.showProgress(val, status: message);
  }

  hide() {
    vu = 0;
    EasyLoading.dismiss();
  }
}
