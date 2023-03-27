import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TOAST {
  late BuildContext content;
  init(BuildContext context) {
    content = context;
    // ToastContext().init(context);
  }

  show(String msg, {int? duration = 3, int? gravity = Toast.bottom}) {
    ScaffoldMessenger.of(content).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          textColor: Colors.lightGreen,
          label: 'ok',
          onPressed: () {
            // Code to execute.
            ScaffoldMessenger.of(content).removeCurrentSnackBar();
          },
        ),
      ),
    );
    // Toast.show(msg,
    //     duration: duration,
    //     gravity: gravity,
    //     backgroundRadius: 5,
    //     backgroundColor: Colors.green);
  }
}
