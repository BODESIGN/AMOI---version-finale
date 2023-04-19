// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:amoi/screens/defies.dart';
import 'package:flutter/material.dart';

import '../panels/pane_ticket.dart';

class SCREEN_TRAITE_DEFIE extends StatefulWidget {
  const SCREEN_TRAITE_DEFIE({super.key});

  @override
  State<SCREEN_TRAITE_DEFIE> createState() => _SCREEN_TRAITE_DEFIEState();
}

class _SCREEN_TRAITE_DEFIEState extends State<SCREEN_TRAITE_DEFIE> {
  bool isConstruct = true;
  String login = '';
  String defie_code = '';
  Map<String, dynamic> defie = {};
  Map<String, dynamic> defie_actif = {};
  List<Widget> taches = [];
  String delai = '';

  Map<String, dynamic> user = {};
  List<Widget> vuChildDirect = [];

  TRANSACTION $ = TRANSACTION();
  List<DataRow> transactions = [];

  List<Widget> vuTiket = [];

  INPUT inputMonant = INPUT(label: 'Argent gagné ', isNumber: true);
  INPUT inputExp = INPUT(label: 'Experience gagné ', isNumber: true);

  // -----------------------------------SELECT TICKET
  reloadTicket() {
    loading.show("Chargement des récus ...");

    base.select_Tickets(login, (tickets) {
      setState(() => vuTiket = []);
      for (var ticket in tickets) {
        setState(() {
          vuTiket.add(Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: TICKET(ticket: ticket, forAdmin: true),
          ));
        });
      }
      loading.hide();
    });
  }

  // -----------------------------------SELECT TICKET
  _getUser() {
    // GET -->  USER
    loading.show("Chargement de la fiche ...");
    base.select(table['user']!, login, (result, value) {
      if (result == 'error') {
        toast.show('Compte inconnue !');
        loading.hide();
        return;
      }
      setState(() {
        user = value.data() as Map<String, Object?>;
        vuChildDirect = [];
      });
      loading.hide();

      // GET -->  des tarnsactions
      loading.show("Chargement des transactions ...");
      $.getTransaction(login, (liste) {
        setState(() => transactions = []);
        for (var t in liste) {
          transactions.add(DataRow(cells: <DataCell>[
            DataCell(Text(t['date'], style: const TextStyle(fontSize: 12))),
            DataCell(
                Text(t['description'], style: const TextStyle(fontSize: 12)))
          ]));
        }

        // GET -->  des childs
        reloadTicket();

        // GET -->  des childs
        loading.show("Chargement des child direct ...");
        if (user['childs-direct'].length > 0) {
          for (var code in user['childs-direct']) {
            base.select(table['user']!, code.toString(), (result, value) {
              loading.hide();
              if (result == 'error') return;
              Map<String, dynamic> u = value.data() as Map<String, Object?>;
              setState(() {
                vuChildDirect
                    .add(LABEL(text: "${u['dateCreate']} => ${u['fullname']}"));
              });
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    if (isConstruct) {
      final arg = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        isConstruct = false;
        login = arg['code-user'];
        defie_code = arg['code-defie'];

        for (var d in administrator['defies']) {
          if (d['code'].toString() == defie_code) defie = d;
        }

        for (var d in administrator['defie-en-cours']) {
          if (d['userCode'].toString() == login) defie_actif = d;
        }

        taches = [];
        for (var t in defie['Tache']) {
          taches.add(LABEL(text: "_ $t"));
        }

        delai =
            DateTime.now().difference(defie_actif['debut'].toDate()).toString();

        _getUser();
      });
    }

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: LABEL(text: 'Traiter défie ', size: 15),
              titleTextStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              surfaceTintColor: Colors.white,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: BUTTON(
                      text: '',
                      action: () {
                        setState(() {
                          delai = DateTime.now()
                              .difference(defie_actif['debut'].toDate())
                              .toString();
                        });
                        _getUser();
                      },
                      type: 'ICON')
                    ..icon = Icons.refresh,
                )
              ],
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                      padding: const EdgeInsets.all(20),
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
                                        text:
                                            'user : ${defie_actif['userCode']} '),
                                    const SizedBox(height: 5),
                                    LABEL(
                                        text:
                                            'début : ${defie_actif['debut'].toDate().toString()} '),
                                    const SizedBox(height: 5),
                                    LABEL(text: 'delais : $delai '),
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
                                        LABEL(
                                            text: '⏱️ Delai : ', isBold: true),
                                        LABEL(text: '${defie['delai']}'),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    LABEL(text: '☑️ Tache : ', isBold: true),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: taches)
                                  ])))),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: LABEL(
                          text: "Utilisateur : ${user['fullname']}",
                          isBold: true)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: LABEL(
                          text: "Récomponse a attribué : ",
                          color: Colors.blue,
                          size: 15)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(children: [inputMonant, inputExp]),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const SizedBox(width: 20),
                    BUTTON(
                        text: 'Attribuer',
                        action: () {
                          MODALE m = MODALE(context, "Valider la defie",
                              "Vous allez attribuée les recomponse a : ${user['fullname']}")
                            ..hideBt2 = true
                            ..labelButton1 = 'Attribuer'
                            ..icon1 = Icons.check
                            ..action1 = () {
                              int vola = 0;
                              int exp = 0;

                              bool pass = true;
                              String msg = '';
                              try {
                                vola = int.parse(inputMonant.getValue());
                              } catch (e) {
                                pass = false;
                                msg = 'Veuillez verifier : Argent attribué';
                              }
                              try {
                                exp = int.parse(inputExp.getValue());
                              } catch (e) {
                                pass = false;
                                msg = 'Veuillez verifier : Exp attribué';
                              }
                              if (!pass) toast.show(msg);

                              DEFIE().defieFinieAttrub(
                                  login, vola, exp, defie_code, () {
                                Navigator.pop(context);
                              });
                            }
                            ..labelButton3 = 'Annuler'
                            ..action3 = () {
                              Navigator.pop(context);
                            };
                          m.show();
                        })
                      ..colorBg = Colors.green,
                    const SizedBox(width: 20),
                    BUTTON(
                        text: 'Supprimer la défie',
                        action: () {
                          MODALE m = MODALE(context, "Supprimer la defie",
                              "Veuillez confirmmer la suppression")
                            ..hideBt2 = true
                            ..labelButton1 = 'Supprimer'
                            ..icon1 = Icons.delete
                            ..action1 = () {
                              DEFIE().delete_acitf(login, () {
                                Navigator.pop(context);
                              });
                            }
                            ..labelButton3 = 'Annuler'
                            ..action3 = () {
                              Navigator.pop(context);
                            };
                          m.show();
                        })
                      ..colorBg = Colors.red,
                    const SizedBox(width: 20)
                  ]),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: LABEL(
                          text: "Réseau direct : ",
                          color: Colors.blue,
                          size: 15)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: vuChildDirect)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: LABEL(
                          text: "List des tickets : ",
                          color: Colors.blue,
                          size: 15)),
                  SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: vuTiket.isNotEmpty
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SizedBox(
                                              // width: MediaQuery.of(context).size.width,
                                              child: Row(children: vuTiket)))
                                      : Center(
                                          child: LABEL(
                                              text: 'Aucun ticket',
                                              color: Colors.grey)))
                            ])),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: LABEL(
                          text: "List des transactions : ",
                          color: Colors.blue,
                          size: 15)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: DataTable(
                          dataRowHeight: 40,
                          horizontalMargin: 0,
                          columnSpacing: 20,
                          checkboxHorizontalMargin: 0,
                          columns: <DataColumn>[
                            DataColumn(
                                label: Expanded(
                                    child: LABEL(
                                        text: 'Date', color: Colors.blue))),
                            DataColumn(
                                label: Expanded(
                                    child: LABEL(
                                        text: 'Transactions',
                                        color: Colors.blue)))
                          ],
                          rows: transactions))
                ]))));
  }
}
