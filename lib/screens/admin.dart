// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';

import 'package:amoi/componantes/button.dart';
import 'package:amoi/componantes/label.dart';
import 'package:amoi/componantes/modale.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:app_installer/app_installer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class ADMIN extends StatefulWidget {
  const ADMIN({super.key});

  @override
  State<ADMIN> createState() => _ADMINState();
}

class _ADMINState extends State<ADMIN> {
  BUTTON btGeneral = BUTTON(text: 'General', action: () {}, type: 'BLEU');
  BUTTON btDemande =
      BUTTON(text: 'Gestion des demande', action: () {}, type: 'BLEU');
  BUTTON btBoites =
      BUTTON(text: 'Dispatche des boites', action: () {}, type: 'BLEU');
  int pageVu = 0;

  BUTTON btTraiterLaPeriode =
      BUTTON(text: 'Passer au période suivant', action: () {});

  BUTTON btDownloadLastVersion = BUTTON(text: 'Télécharger', action: () {});

  String periodeDebut = '';

  TRANSACTION transaction = TRANSACTION();
  List<Map> listDemande = [];
  List<Widget> listDemandeVu = [];
  late MODALE vuDemande;
  Map demandeVu = {};

  BUTTON btTraiteDmd = BUTTON(text: 'Traiter', action: () {}, type: 'BLEU');
  BUTTON btSupprimDmd = BUTTON(text: 'Supprimer', action: () {});
  Map boiteVu = {};
  late MODALE vuBoite;

  List<Map> listBoitePlein = [];
  List<Widget> listBoitePleinVu = [];

  BUTTON btTraiteBoite = BUTTON(text: 'Traiter', action: () {}, type: 'BLEU');

  bool isConstruct = true;
  List<Widget> listOldMontant = [];
  List<Widget> listInvestisseur = [];

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
          listOldMontant.add(LABEL(text: "$oldSold ariary"));
        }
        listInvestisseur = [];
        administrator['investiseurs'].forEach((key, value) {
          listInvestisseur.add(LABEL(text: "$key : $value"));
        });
      });
      loading.hide();
    });
  }

  // ===================================================
  Widget panelGeneral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, width: double.maxFinite, color: Colors.black12),
        const SizedBox(height: 10),
        LABEL(text: "Date debut appli : $periodeDebut", isBold: true),
        LABEL(text: "Entré : ${administrator['net-entre']} ariary"),
        LABEL(text: "Sortie : ${administrator['net-sortie']} ariary"),
        LABEL(
            text:
                "Rest : ${administrator['net-entre'] - administrator['net-sortie']} ariary"),
        const SizedBox(height: 10),
        LABEL(text: "Sold des mois precédents ", isBold: true),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listOldMontant),
        const SizedBox(height: 10),
        LABEL(
            text:
                "Sold de ce mois : ${administrator['sold de ce mois']} ariary",
            isBold: true),
        LABEL(text: "(100% pour les actionnaires)", color: Colors.grey),
        const SizedBox(height: 10),
        LABEL(text: "Actionnaires", isBold: true),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listInvestisseur),
        const SizedBox(height: 10),
        btTraiterLaPeriode,
        btDownloadLastVersion
      ],
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
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Text('Type de demande : '),
                Text(dmd['type'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Text(dmd['date'].toString(),
                style: const TextStyle(fontWeight: FontWeight.w300)),
            Container(
                height: 1, width: double.maxFinite, color: Colors.black12),
            Row(children: [
              const Text("👤 User : "),
              Text(dmd['codeUser'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]),
            Row(children: [
              const Text("📱 Tèl : "),
              Text(dmd['tel'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]),
            Row(children: [
              const Text(" 💵 Montant : "),
              Text(dmd['montant'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text(" Ariary ")
            ]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [btTraiteDmd, btSupprimDmd],
            ),
            const SizedBox(height: 20),
          ]);
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
                                    const Text(" Ariary ")
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
              const Text(" Ariary ")
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
    return Column(
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
        ]);
  }

  // ===================================================
  Widget panelBoite() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      const Text("Traiter sortant des boites ",
          style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(
          "creation new BOITE , update all fiche in boite , update info boite "),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listBoitePleinVu)
    ]);
  }

  // ===================================================
  @override
  Widget build(BuildContext context) {
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
        ..type = 'CUSTOM'
        ..child = rowDemande(demandeVu, isVu: true);
      vuBoite = MODALE(context, 'Vu boites', '')
        ..type = 'CUSTOM'
        ..child = rowBoite(demandeVu, isVu: true);
      //
      btTraiteDmd.action = () {
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
      };
      //
      btTraiteBoite.action = () {
        traiterPassationBoite(boiteVu, () {
          vuBoite.hide();
          toast.show("Boite traitée");
          _loadBoitePlein();
        });
      };
      //
      btSupprimDmd.action = () {
        transaction.supprimerDemmande(demandeVu, () {
          vuDemande.hide();
          toast.show("Demande suppriée");
          _loadDemande();
        });
      };
      btTraiterLaPeriode.action = () async {
        loading.show("Mise a jour de la solde ...");
        await base.passerAuPeriodeSuivant();
        loading.hide();
        _loadGenerale();
      };
      btDownloadLastVersion.action = () async {
        loading.show("Téléchargement ...");
        final storageRef = FirebaseStorage.instance.ref();
        final islandRef = storageRef.child("version/app.apk");
        final PathProviderPlatform provider = PathProviderPlatform.instance;
        final appDocDir = await provider.getExternalStoragePath();
        final filePath = "$appDocDir/amoi.apk";
        final File file = File(filePath);

        final downloadTask = islandRef.writeToFile(file);

        downloadTask.snapshotEvents.listen((taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              double percent =
                  ((taskSnapshot.bytesTransferred / taskSnapshot.totalBytes) *
                          100);
              loading.showProgress(percent,"téléchargement cours ...");
              break;
            case TaskState.paused:
              break;
            case TaskState.success:
              loading.hide();
              await AppInstaller.installApk(filePath);
              break;
            case TaskState.canceled:
              loading.hide();
              break;
            case TaskState.error:
              loading.hide();
              break;
          }
        });
      };
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed('SECONNECT');
        return true;
      },
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Amoi Groupe", style: TextStyle(fontSize: 20)),
                      const Text("Administateur"),
                      const SizedBox(height: 5),
                      Container(
                          height: 1,
                          width: double.maxFinite,
                          color: Colors.black12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            btGeneral,
                            const SizedBox(width: 10),
                            btDemande,
                            const SizedBox(width: 10),
                            btBoites,
                          ],
                        ),
                      ),
                      pageVu == 1
                          ? panelDemande()
                          : pageVu == 2
                              ? panelBoite()
                              : panelGeneral()
                    ]),
              ))),
    );
  }
}
