// ignore_for_file: camel_case_types

import 'package:amoi/main.dart';
import 'package:amoi/panels/pane_hyerarchie.dart';
import 'package:flutter/material.dart';

class SCREEN_ALL_TREE extends StatefulWidget {
  const SCREEN_ALL_TREE({super.key});

  @override
  State<SCREEN_ALL_TREE> createState() => _SCREEN_ALL_TREESState();
}

class _SCREEN_ALL_TREESState extends State<SCREEN_ALL_TREE> {
  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    return Scaffold(
        appBar: AppBar(
            title: const Text('Liste hyerarchique'),
            titleTextStyle: const TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
            surfaceTintColor: Colors.white),
        body: MYHYERARCHY());
  }
}
