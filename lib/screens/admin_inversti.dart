import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/functions/boite.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class SCREEN_ALL_INVEST extends StatefulWidget {
  const SCREEN_ALL_INVEST({super.key});

  @override
  State<SCREEN_ALL_INVEST> createState() => _SCREEN_ALL_INVESTState();
}

class _SCREEN_ALL_INVESTState extends State<SCREEN_ALL_INVEST> {
  List<Widget> vuBoites = [];
  bool isConstruct = true;

  int nbTotSortant = 0;
  int miTot = 0;

// =====================================================
  getList(BuildContext context) {
    loading.show("Chargement des boites ...");
    setState(() {
      vuBoites = [];
      nbTotSortant = 0;
      miTot = 0;
    });

    base.select_Boite((boites) {
      for (var map in boites) {
        setState(() {
          nbTotSortant += 2;
          int m = map['montant'];
          miTot += (2 * m);

          vuBoites.add(Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LABEL(text: 'Code : ${map['code']}'),
                    LABEL(text: '${map['dateCreate']}'),
                    LABEL(text: 'Montant : ${map['montant']}'),
                    LABEL(text: 'Membre : ${map['membres'].length} / 14')
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
          surfaceTintColor: Colors.white,
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
                          LABEL(text: 'Nbr. tot sortant : $nbTotSortant'),
                          LABEL(text: 'M.I tot sortant : $miTot ariary')
                        ],
                      ),
                    )
                  : Center(
                      child: LABEL(text: 'Aucune boite', color: Colors.grey))
            ]));
  }
}
