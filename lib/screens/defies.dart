// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// ==================================================================================
// ==================================================================================
// ==================================================================================

class DEFIE {
  // ---------------------------------------------------------------------------
  newDefieForUser(String login, String defieCode, Function pass) {
    loading.show("Mis a jour ...");
    base.newDefieForUser(login, defieCode, (res) {
      loading.hide();
      pass();
    });
  }

  // ---------------------------------------------------------------------------
  defieFinieAttrub(
      String login, int argent, int exp, String defieCode, Function pass) {
    loading.show("Mis a jour ...");
    base.defieEndAttribut(login, argent, exp, defieCode, (res) {
      loading.hide();
      delete_acitf(login, pass);
    });
  }

  // ---------------------------------------------------------------------------
  delete_acitf(String login, Function pass) {
    loading.show("Mise a jour ...");
    for (var i = 0; i < administrator['defie-en-cours'].length; i++) {
      if (administrator['defie-en-cours'][i]['userCode'].toString() == login) {
        administrator['defie-en-cours'].removeAt(i);
      }
    }

    base.removeDefieForUser(login, administrator['defie-en-cours'], (res) {
      loading.hide();
      pass();
    });
  }
}

// ==================================================================================
// ==================================================================================
// ==================================================================================

class SCREEN_DEFIES_ADMIN extends StatefulWidget {
  const SCREEN_DEFIES_ADMIN({super.key});

  @override
  State<SCREEN_DEFIES_ADMIN> createState() => _SCREEN_DEFIES_ADMINState();
}

class _SCREEN_DEFIES_ADMINState extends State<SCREEN_DEFIES_ADMIN> {
  bool isConstruct = true;
  List<Widget> vuDefies = [];
  List<Widget> vuDefiesActif = [];

  INPUT newRecomponse = INPUT(label: 'Récomponse');
  INPUT newDelais = INPUT(label: 'Délais');
  List<INPUT> newTaches = [];

  //  ===========================================================================
  reloadDefie() {
    loading.show("Chargement ...");

    base.select(table['setting']!, table['admin']!, (result, value) {
      administrator = value.data() as Map<String, Object?>;
      setState(() {
        vuDefies = [];
        vuDefiesActif = [];

        // -> INFO Gll
        for (var defie in administrator['defies']) {
          List<Widget> taches = [];
          for (var t in defie['Tache']) {
            taches.add(LABEL(text: "_ $t"));
          }
          vuDefies.add(Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  toast.show("Modale > or new Context for modif or delete");
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3))
                        ]),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LABEL(
                                  text: '${defie['recomponse']} 🎁',
                                  color: Colors.blue,
                                  isBold: true),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  LABEL(text: '⏱️ Delai : ', isBold: true),
                                  LABEL(text: '${defie['delai']}'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              LABEL(text: '☑️ Tache : ', isBold: true),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: taches)
                            ]))),
              )));
        }

        //
        for (var defie_en_cours in administrator['defie-en-cours']) {
          Map defie = {};

          for (var d in administrator['defies']) {
            if (d['code'].toString() == defie_en_cours['defieCode']) defie = d;
          }

          List<Widget> taches = [];
          for (var t in defie['Tache']) {
            taches.add(LABEL(text: "_ $t"));
          }
          vuDefiesActif.add(Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'ADMIN_DEFIE_TRAITER',
                      arguments: {
                        'code-defie': defie['code'].toString(),
                        'code-user': defie_en_cours['userCode'].toString(),
                      },
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ]),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LABEL(
                                    text:
                                        'user : ${defie_en_cours['userCode']} '),
                                const SizedBox(height: 5),
                                LABEL(
                                    text:
                                        'début : ${defie_en_cours['debut'].toDate().toString()} '),
                                const SizedBox(height: 5),
                                LABEL(
                                    text:
                                        'delais : ${DateTime.now().difference(defie_en_cours['debut'].toDate())} '),
                                const SizedBox(height: 5),
                                LABEL(text: '--'),
                                const SizedBox(height: 5),
                                LABEL(
                                    text: '${defie['recomponse']} 🎁',
                                    color: Colors.blue,
                                    isBold: true),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    LABEL(text: '⏱️ Delai : ', isBold: true),
                                    LABEL(text: '${defie['delai']}'),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                LABEL(text: '☑️ Tache : ', isBold: true),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: taches)
                              ]))))));
        }
      });

      loading.hide();
    });
  }

  //  ===========================================================================
  void _addNewDefie() {
    loading.show('Insertion ...');

    Map defie = {
      'code': getDateNow(),
      'delai': newDelais.getValue(),
      'recomponse': newRecomponse.getValue(),
      'Tache': []
    };

    for (var inp in newTaches) {
      defie['Tache'].add(inp.getValue());
    }

    base.newDefies(defie, (res, val) {
      loading.hide();
      reloadDefie();
    });
  }

  //  ===========================================================================
  @override
  Widget build(BuildContext context) {
    toast.init(context);

    if (isConstruct) {
      reloadDefie();
      setState(() => isConstruct = false);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: LABEL(text: 'Les defies', size: 15), actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: BUTTON(text: '', type: 'ICON', action: () => reloadDefie())
              ..icon = Icons.refresh,
          ),
        ]),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: LABEL(text: 'Créer une nouvelle défie', isBold: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(children: [
                    newRecomponse,
                    const SizedBox(height: 10),
                    newDelais,
                    const SizedBox(height: 10),
                    Column(children: newTaches),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () {
                            setState(
                                () => newTaches.add(INPUT(label: 'Tache')));
                          })
                        ..icon = Icons.add,
                      const SizedBox(width: 10),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () {
                            setState(
                                () => newTaches.removeAt(newTaches.length - 1));
                          })
                        ..icon = Icons.remove,
                      const SizedBox(width: 10),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () {
                            _addNewDefie();
                            setState(() {
                              newTaches = [];
                              newRecomponse.setText('');
                              newDelais.setText('');
                            });
                          })
                        ..icon = Icons.check
                        ..colorBg = Colors.green,
                      const SizedBox(width: 10),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () {
                            setState(() {
                              newTaches = [];
                              newRecomponse.setText('');
                              newDelais.setText('');
                            });
                          })
                        ..icon = Icons.cancel
                        ..colorBg = Colors.red,
                      const SizedBox(width: 10),
                    ])
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      LABEL(text: 'Listes des defies existants', isBold: true),
                ),
                vuDefies.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: vuDefies),
                        ))
                    : Center(
                        child: LABEL(
                            text: 'Aucune défie disponible',
                            color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      LABEL(text: 'Listes des defies en cours ', isBold: true),
                ),
                vuDefiesActif.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: vuDefiesActif),
                        ))
                    : Center(
                        child: LABEL(
                            text: 'Aucune défie en cours',
                            color: Colors.black)),
              ]),
        ),
      ),
    );
  }
}
