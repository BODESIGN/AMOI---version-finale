// ignore_for_file: unused_element

import 'dart:async';

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ADMIN extends StatefulWidget {
  const ADMIN({Key? key}) : super(key: key);

  @override
  State<ADMIN> createState() => _ADMINState();
}

class _ADMINState extends State<ADMIN> {
  final int _currentIndex = 0;

  BUTTON btGeneral = BUTTON(text: 'General', action: () {}, type: 'BLEU');
  BUTTON btDemande =
      BUTTON(text: 'Gestion des demande', action: () {}, type: 'BLEU');
  BUTTON btBoites =
      BUTTON(text: 'Dispatche des boites', action: () {}, type: 'BLEU');
  int pageVu = 0;

  BUTTON btTraiterLaPeriode =
      BUTTON(text: 'Passer au période suivant', action: () {});

  String periodeDebut = '';

  TRANSACTION transaction = TRANSACTION();
  List<Map> listDemande = [];
  List<Widget> listDemandeVu = [];
  late MODALE vuDemande;
  Map demandeVu = {};
  Map boiteVu = {};
  late MODALE vuBoite;

  List<Map> listBoitePlein = [];
  List<Widget> listBoitePleinVu = [];

  BUTTON btTraiteBoite = BUTTON(text: 'Traiter', action: () {}, type: 'BLEU');

  bool isConstruct = true;
  List<Widget> listOldMontant = [];
  List<Widget> listInvestisseur = [];
  List<Widget> listContact = [];

  // ===================================================
  void _loadGenerale() {
    loading.show("Chargement ...");

    base.select(table['setting']!, table['admin']!, (result, value) {
      administrator = value.data() as Map<String, Object?>;
      cote = administrator['cote'];
      bonusSortant = administrator['bonusSortant'];
      // -> INFO Gll

      setState(() {
        periodeDebut = DateFormat('dd MMMM yyyy')
            .format((administrator['date-debut-appli'] as Timestamp).toDate())
            .toString();

        listOldMontant = [];
        for (var oldSold in administrator['sold des mois avant']) {
          listOldMontant.add(LABEL(text: "$oldSold MGA"));
        }
        listInvestisseur = [];
        administrator['investiseurs'].forEach((key, value) {
          listInvestisseur.add(LABEL(text: "$key : $value"));
        });
        listContact = [];
        administrator['contact'].forEach((key, value) {
          listContact.add(LABEL(text: "$key : $value"));
        });
      });
      loading.hide();
    });
  }

  // ===================================================
  Widget panelGeneral() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, width: double.maxFinite, color: Colors.black12),
          const SizedBox(height: 10),
          LABEL(text: "Date debut appli : $periodeDebut", isBold: true),
          LABEL(text: "Entré : ${administrator['net-entre']} MGA"),
          LABEL(text: "Sortie : ${administrator['net-sortie']} MGA"),
          LABEL(
              text:
                  "Rest : ${administrator['net-entre'] - administrator['net-sortie']} MGA"),
          const SizedBox(height: 10),
          LABEL(text: "Sold des mois precédents ", isBold: true),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listOldMontant),
          const SizedBox(height: 10),
          LABEL(
              text: "Sold de ce mois : ${administrator['sold de ce mois']} MGA",
              isBold: true),
          LABEL(text: "(100% pour les actionnaires)", color: Colors.grey),
          const SizedBox(height: 10),
          LABEL(text: "Actionnaires", isBold: true),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listInvestisseur),
          const SizedBox(height: 10),
          btTraiterLaPeriode,
          const SizedBox(height: 10),
          LABEL(text: "Notre contact", isBold: true),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listContact),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ===================================================
  void _loadDemande() {
    transaction.getDemandeAll((res) {
      setState(() {
        listDemande = res;
        listDemandeVu = [];
      });
      for (var dmd in listDemande) {
        setState(() => listDemandeVu.add(rowDemande(dmd)));
      }
    });
  }

  // ===================================================
  void _loadBoitePlein() {
    loading.show('Chargement des boites ...');
    base.select_Boite_Plein((res) {
      setState(() {
        listBoitePlein = [];
        for (var boite in res) {
          listBoitePlein.add(boite);
        }
        listBoitePleinVu = [];
      });
      for (var boite in listBoitePlein) {
        setState(() => listBoitePleinVu.add(rowBoite(boite)));
      }
      loading.hide();
    });
  }

  // ===================================================
  Widget rowDemande(Map dmd, {bool isVu = false}) {
    INPUT montantValide = INPUT(label: 'Montant Accordé');
    montantValide.setText(dmd['montant'].toString());

    return !isVu
        ? InkWell(
            onTap: () {
              loading.show("Chargement ...");
              setState(() {
                demandeVu = dmd;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                loading.hide();
                vuDemande.show();
              });
            },
            child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(5)), //here
                        color: Colors.black12),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Type de demande : ${dmd['type']} '),
                                      const SizedBox(width: 30),
                                      Text(dmd['date']),
                                    ],
                                  ),
                                  Text(
                                      "👤 User : ${dmd['codeUser']}  | 📱 Tèl : ${dmd['tel']}  | 💵 Montant : ${dmd['montant']} Ar")
                                ]))))),
          )
        : Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 30),
              LABEL(text: 'Traiter demande ', size: 25),
              Container(
                  height: 1, width: double.maxFinite, color: Colors.black12),
              Row(children: [
                LABEL(text: 'Type : '),
                LABEL(text: dmd['type'].toString(), isBold: true)
              ]),
              Row(children: [
                LABEL(text: 'Date : '),
                LABEL(text: dmd['date'].toString(), isBold: true)
              ]),
              Row(children: [
                LABEL(text: '👤 User (login) : '),
                LABEL(text: dmd['codeUser'].toString(), isBold: true)
              ]),
              Row(children: [
                LABEL(text: '📱 Tèl : '),
                LABEL(text: dmd['tel'].toString(), isBold: true)
              ]),
              Row(children: [
                LABEL(text: ' 💵 Montant : '),
                LABEL(text: "${dmd['montant'].toString()} MGA", isBold: true)
              ]),
              montantValide,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BUTTON(
                          text: 'Traiter',
                          action: () {
                            int m = 0;
                            try {
                              m = int.parse(montantValide.getValue());
                            } catch (e) {
                              toast.show('Veuillez verifier votre montant !');
                              return;
                            }
                            if (m < 2000) {
                              toast.show('Montant trop bas');
                              return;
                            }
                            
                            demandeVu['montant'] = m;

                            if (demandeVu['type'] == 'Depot') {
                              transaction.traiterDepot(demandeVu, () {
                                vuDemande.hide();
                                toast.show("Demande traitée");
                                _loadDemande();
                              });
                            } else {
                              // RETRAIT
                              transaction.traiterRetrait(demandeVu, () {
                                vuDemande.hide();
                                toast.show("Demande traitée");
                                _loadDemande();
                              });
                            }
                          })
                        ..colorBg = Colors.green,
                      const SizedBox(width: 10),
                      BUTTON(
                          text: 'Voir Sold',
                          action: () {
                            loading.show("Chargement ...");
                            base.select(table['user']!,
                                demandeVu['codeUser'].toString(),
                                (result, value) {
                              if (result == 'error') {
                                loading.hide();
                                return;
                              }

                              late Map<String, dynamic> user;
                              user = value.data() as Map<String, Object?>;
                              loading.hide();
                              toast.showNotyf(
                                  "Sold actuel : ${user['ariary']} MGA",
                                  'PETIT INFO');
                            });
                          })
                        ..colorBg = Colors.green,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () {
                            transaction.supprimerDemmande(demandeVu, () {
                              vuDemande.hide();
                              toast.show("Demande suppriée");
                              _loadDemande();
                            });
                          })
                        ..icon = Icons.delete
                        ..colorBg = Colors.red,
                      const SizedBox(width: 10),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () {
                            Navigator.pop(context);
                          })
                        ..icon = Icons.vertical_align_bottom
                        ..colorBg = Colors.grey
                    ],
                  ),
                ],
              ),
            ]),
          );
  }

  // ===================================================
  Widget rowBoite(Map boite, {bool isVu = false}) {
    return !isVu
        ? InkWell(
            onTap: () {
              loading.show("Chargement ...");
              setState(() {
                boiteVu = boite;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                loading.hide();
                vuBoite.show();
              });
            },
            child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(5)), //here
                        color: Colors.black12),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Code boite : '),
                                      Text(boite['code'].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Row(children: [
                                    const Text(" 💵 Montant : "),
                                    Text(boite['montant'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Text(" MGA ")
                                  ]),
                                ]))))),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Text('Code boite : '),
                Text(boiteVu['code'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(children: [
              const Text(" 💵 Montant : "),
              Text(boiteVu['montant'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text(" MGA ")
            ]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [btTraiteBoite],
            ),
            const SizedBox(height: 20),
          ]);
  }

  // ===================================================
  Widget panelDemande() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            const Text("Traiter demande Dépôt ou retrait ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Liste des demandes non traité '),
            const SizedBox(height: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: listDemandeVu)
          ]),
    );
  }

  // ===================================================
  Widget panelBoite() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        const Text("Traiter sortant des boites ",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text(
            "creation new BOITE , update all fiche in boite , update info boite "),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listBoitePleinVu)
      ]),
    );
  }

  // ===================================================
  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    toast.init(context);
    if (isConstruct) {
      _loadGenerale();
      setState(() => isConstruct = false);
    }
    setState(() {
      btGeneral.action = () {
        setState(() => pageVu = 0);
        _loadGenerale();
      };
      btDemande.action = () {
        setState(() => pageVu = 1);
        _loadDemande();
      };
      btBoites.action = () {
        setState(() => pageVu = 2);
        _loadBoitePlein();
      };
      vuDemande = MODALE(context, 'Demande a traiter', '')
        ..type = 'PLEIN'
        ..child = rowDemande(demandeVu, isVu: true);
      vuBoite = MODALE(context, 'Vu boites', '')
        ..type = 'CUSTOM'
        ..child = rowBoite(demandeVu, isVu: true);
      //
      btTraiteBoite.action = () {
        traiterPassationBoite(boiteVu, () {
          vuBoite.hide();
          toast.show("Boite traitée");
          _loadBoitePlein();
        });
      };
      //
      btTraiterLaPeriode.action = () async {
        loading.show("Mise à jour de la solde ...");
        await base.passerAuPeriodeSuivant();
        loading.hide();
        _loadGenerale();
      };
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed('SECONNECT');
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Amoi Groupe",
                              style: TextStyle(fontSize: 20)),
                          const Text("Administateur"),
                          const SizedBox(height: 5),
                          Container(
                              height: 1,
                              width: double.maxFinite,
                              color: Colors.black12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              ButtonBar(
                                children: [btGeneral, btDemande, btBoites],
                              )
                            ]),
                          ),
                          Expanded(
                            child: pageVu == 1
                                ? panelDemande()
                                : pageVu == 2
                                    ? panelBoite()
                                    : panelGeneral(),
                          )
                        ]))),
          ),
          BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (value) => setState(() {
                    // _currentIndex = value;
                    if (value == 1) {
                      Navigator.of(context).pushNamed('ADMIN_DASHBOARD');
                    }
                  }),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: 'Statistic')
              ])
        ],
      ),
    );
  }
}
