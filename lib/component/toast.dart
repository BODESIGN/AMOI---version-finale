import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TOAST {
  late BuildContext content;
  late MODALE vuNotyf;
  init(BuildContext context) {
    content = context;
    ToastContext().init(context);
  }

  showNotyf(String msg, String type) {
    vuNotyf = MODALE(content, 'Vu boites', '')
      ..type = 'NOTYF'
      ..child = Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: Container(
                      color: type == 'SUCCES'
                          ? Colors.green
                          : type == 'ERROR'
                              ? Colors.red
                              : type == 'PETIT INFO'
                                  ? Colors.black
                                  : Colors.orange,
                      child: Icon(
                          type == 'SUCCES'
                              ? Icons.check
                              : type == 'ERROR'
                                  ? Icons.close
                                  : type == 'PETIT INFO'
                                      ? Icons.message
                                      : Icons.warning,
                          color: Colors.white))),
            ),
            const SizedBox(height: 10),
            LABEL(
                text: msg,
                size: 14,
                isBold: true,
                color: type == 'SUCCES'
                    ? Colors.green
                    : type == 'ERROR'
                        ? Colors.red
                        : type == 'PETIT INFO'
                            ? Colors.black
                            : Colors.amber),
            const SizedBox(height: 20),
            BUTTON(
                text: 'OK',
                action: () {
                  vuNotyf.hide();
                }),
            const SizedBox(height: 10),
          ]));
    vuNotyf.show();
  }

  show(String msg, {int? duration = 3, int? gravity = Toast.bottom}) {
    Toast.show(msg,
        duration: duration,
        gravity: gravity,
        backgroundRadius: 5,
        backgroundColor: Colors.green);
  }
}
