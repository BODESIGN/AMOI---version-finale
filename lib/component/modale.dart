// ignore_for_file: prefer_final_fields

import 'package:amoi/component/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MODALE {
  MODALE(
    this.context,
    this.title,
    this.subTitle,
  );

  BuildContext context;
  String type = 'BUTTONS';
  Widget child = Container();

  bool isShowed = false;

  bool hideBt2 = false;

  String title;
  String subTitle;

  String labelButton1 = 'BUTTON 1';
  String labelButton2 = 'BUTTON 2';
  String labelButton3 = 'BUTTON 3';
  Function action1 = () {};
  Function action2 = () {};
  Function action3 = () {};
  IconData? icon1;
  IconData? icon2;
  IconData? icon3;

  void hide() {
    if (!isShowed) return;
    isShowed = false;
    Navigator.pop(context);
  }

  void show() {
    isShowed = true;
    switch (type) {
      case 'BUTTONS':
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
                    title: LABEL(text: title, color: Colors.green, size: 15),
                    message: LABEL(text: subTitle),
                    actions: <CupertinoActionSheetAction>[
                      CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            action1();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icon1 != null)
                                  Icon(icon1, color: Colors.green),
                                if (icon1 != null) const SizedBox(width: 10),
                                LABEL(
                                    text: labelButton1,
                                    isBold: true,
                                    color: Colors.green)
                              ])),
                      if (!hideBt2)
                        CupertinoActionSheetAction(
                            onPressed: () {
                              action2();
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (icon2 != null)
                                    Icon(icon2, color: Colors.green),
                                  if (icon2 != null) const SizedBox(width: 10),
                                  LABEL(
                                      text: labelButton2,
                                      isBold: true,
                                      color: Colors.green)
                                ])),
                      CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            action3();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icon3 != null) Icon(icon3),
                                if (icon3 != null) const SizedBox(width: 5),
                                LABEL(
                                    text: labelButton3,
                                    isBold: true,
                                    color: Colors.red)
                              ]))
                    ]));
        break;
      case 'PLEIN':
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            enableDrag: false,
            isDismissible: false,
            builder: (BuildContext context) {
              return SafeArea(child: child);
            });
        break;
      case 'PROFILE':
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                  child:
                      Padding(padding: const EdgeInsets.all(25), child: child));
            });
        break;
      case 'NOTYF':
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: child));
            });
        break;
      default:
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black12,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                  child: Container(
                      color: Colors.white,
                      child: child));
            });
    }
  }
}
