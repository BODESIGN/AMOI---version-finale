import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SCREEN_ALL_INVEST extends StatefulWidget {
  const SCREEN_ALL_INVEST({Key? key}) : super(key: key);

  @override
  State<SCREEN_ALL_INVEST> createState() => _SCREEN_ALL_INVESTState();
}

class _SCREEN_ALL_INVESTState extends State<SCREEN_ALL_INVEST> {
  List<Widget> vuBoites = [];
  bool isConstruct = true;

  int pourSortans = 0;

// =====================================================
  getList(BuildContext context) {
    loading.show("Chargement des boites ...");
    setState(() {
      vuBoites = [];
      pourSortans = 0;
    });

    base.select_Boite((boites) {
      for (var map in boites) {
        setState(() {
          pourSortans += (2 * map['montant']).round();

          vuBoites.add(Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LABEL(text: 'Code : ${map['code']}'),
                    if (map['dateCreate'] != null)
                      LABEL(
                          text: DateFormat('dd/MM/yyyy HH:mm')
                              .format(map['dateCreate'].toDate())
                              .toString()),
                    LABEL(text: 'Membre : ${map['membres'].length} / 14'),
                    LABEL(text: '--'),
                    LABEL(text: 'M.I : ${map['montant']} ar'),
                    LABEL(
                        text:
                            'Fond : ${map['membres'].length * map['montant']} ar'),
                    LABEL(
                        text: 'Preduction de fond : ${14 * map['montant']} ar'),
                    LABEL(text: '--'),
                    LABEL(
                        text:
                            'Pour sortant (sans child) : ${2 * map['montant']} ar'),
                    LABEL(
                        text:
                            'Reste : ${(map['membres'].length * map['montant']) - (2 * map['montant'])} ar'),
                  ]),
            ),
          ));
        });
      }
      loading.hide();
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
          title: Text('Totales investisement (${vuBoites.length} boites)'),
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
              vuBoites.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: LABEL(text: 'List des boite', isBold: true),
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                  // width: MediaQuery.of(context).size.width,
                                  child: Row(children: vuBoites))),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: LABEL(text: 'Descriptions', isBold: true),
                          ),
                          LABEL(
                              text:
                                  "Sold AMOI : ${administrator['net-entre'] - administrator['net-sortie']} ar"),
                          LABEL(text: "Preduction sortant: $pourSortans ar"),
                          LABEL(text: "Sold utilisable : 2x M.I / Personne "),
                        ],
                      ),
                    )
                  : Center(
                      child: LABEL(text: 'Aucune boite', color: Colors.grey))
            ]));
  }
}
