// ignore_for_file: camel_case_types

import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/functions/boite.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class SCREEN_ALL_BOITE extends StatefulWidget {
  const SCREEN_ALL_BOITE({Key? key}) : super(key: key);

  @override
  State<SCREEN_ALL_BOITE> createState() => _SCREEN_ALL_BOITEState();
}

class _SCREEN_ALL_BOITEState extends State<SCREEN_ALL_BOITE> {
  List<Widget> vuBoites = [];
  bool isConstruct = true;

// =====================================================
  getList(BuildContext context) {
    loading.show("Chargement des boites ...");
    vuBoites = [];

    base.select_Boite((boites) {
      List<BOITE> listB = [];
      for (var map in boites) {
        BOITE b = BOITE(map);
        b.getHistorique((histos) {
          b.histoList = [];
          for (var histo in histos) {
            b.histoList.add(histo);
          }
          listB.add(b);

          setState(() {
            vuBoites = [];
            for (var b in listB) {
              vuBoites.add(Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: b.vu(context, isCarousel: true)));
            }
          });

          loading.hide();
        });
      }

      if (!(boites.length > 0)) loading.hide();
    }, getAll: true);
  }

  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    if (isConstruct) {
      getList(context);
      setState(() {
        isConstruct = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Liste des boites (${vuBoites.length} 🗃️)'),
          titleTextStyle: const TextStyle(
              fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          foregroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child:
                  BUTTON(text: '', action: () => getList(context), type: 'ICON')
                    ..icon = Icons.refresh,
            )
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: vuBoites.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                          child: Row(children: vuBoites),
                        ))
                    : Center(
                        child:
                            LABEL(text: 'Aucune boite', color: Colors.black)),
              )
            ]));
  }
}
