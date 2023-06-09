// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/functions/crypto.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ===================== DESIGN
class BOITE {
  BOITE(this.map);

  Map<String, dynamic> map;
  late MODALE vuModaleNew;
  Function redraw = () {};

  String parentCode = '';

  double meProgression = 0;
  List<Map> histoList = [];

  // =============================

  Map get() {
    return map;
  }

  // ================================= INIT NEW
  initValueNew(int newMontant, String login) {
    map = {
      'code': newCode(7),
      'dateCreate': Timestamp.now(),
      'isNew': true,
      'montant': newMontant,
      'etages': {
        '3': ['vide', 'vide'],
        '2': ['vide', 'vide', 'vide', 'vide'],
        '1': ['vide', 'vide', 'vide', 'vide', 'vide', 'vide', 'vide', login]
      },
      'membres': [login],
      'informations': {
        login: {
          'childNbr': 0,
          'childs': [],
          'dateDebut': Timestamp.now(),
          'etage': 1
        }
      }
    };
  }

  int nbMyBoite = 0;

  // =========================== VU MODALE NEW
  initModaleNew(BuildContext context) {
    vuModaleNew = MODALE(context, 'Boite', '')
      ..type = 'CUSTOM'
      ..child = vu(context, isModaleNew: true);
  }

  // =========================== VU MODALE NEW
  initModaleSearch(BuildContext context, int _nbMyBoite) {
    nbMyBoite = _nbMyBoite;
    vuModaleNew = MODALE(context, 'Boite', '')
      ..type = 'CUSTOM'
      ..child = vu(context, isModaleSearch: true);
  }

  // ================================= INIT NEW
  search(BuildContext context, List<String> searchers, int nbBoite) {
    if (searchers[0] == '') toast.show("Code érronée");
    if (searchers[0] == '') return;
    if (searchers.length > 1) parentCode = searchers[1];

    loading.show("Recherche de la noite ...");
    base.select_Boite_Unique(searchers[0], (result, value) {
      if (result == 'error') toast.show('Boite introuvable !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      map = value.data() as Map<String, Object?>;
      loading.hide();
      initModaleSearch(context, nbBoite);
      // loading.show("Affichage ...");
      // Future.delayed(const Duration(milliseconds: 200), () {
      vuModaleNew.show();
      //   loading.hide();
      // });
    });
  }

  // =========================== VU
  Widget vu(
    BuildContext context, {
    bool isModaleNew = false,
    bool isModaleSearch = false,
    bool isCarousel = false,
  }) {
    List colors = const [
      // LinearGradient(colors: [
      //   Color.fromRGBO(254, 186, 139, 1),
      //   Color.fromRGBO(22298, 245, 100, 1)
      // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      // LinearGradient(colors: [
      //   Color.fromRGBO(107, 158, 223, 1),
      //   Color.fromRGBO(214, 97, 230, 1)
      // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      LinearGradient(colors: [
        Color.fromRGBO(254, 186, 138, 1),
        Color.fromRGBO(222, 98, 100, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      LinearGradient(colors: [
        Color.fromRGBO(0, 194, 221, 1),
        Color.fromRGBO(0, 109, 148, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      LinearGradient(colors: [
        Color.fromRGBO(193, 89, 233, 1),
        Color.fromRGBO(163, 16, 213, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      LinearGradient(colors: [
        Color.fromRGBO(43, 250, 230, 1),
        Color.fromRGBO(74, 131, 254, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      LinearGradient(colors: [
        Color.fromRGBO(255, 167, 0, 1),
        Color.fromRGBO(254, 0, 0, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      LinearGradient(colors: [
        Color.fromRGBO(239, 5, 141, 1),
        Color.fromRGBO(254, 0, 0, 1),
      ], begin: Alignment.centerRight, end: Alignment.topCenter),
    ];

    return isModaleNew
        ? Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                LABEL(
                    text: 'Code : ${map['code']}',
                    color: Colors.grey,
                    isBold: true),
                if (map['dateCreate'] != null)
                  LABEL(
                      text:
                          ' / ${DateFormat('dd/MM/yyyy HH:mm').format(map['dateCreate'].toDate()).toString()}')
              ]),
              LABEL(text: 'Montant Investi : ${map['montant']} MGA'),
              const SizedBox(height: 10),
              designEtage(),
              const SizedBox(height: 10),
              legende(),
              const SizedBox(height: 10),
              LABEL(
                  text:
                      "Mon code : ${CRYPTO().crypte("${map['code']}-${userActif['login']}")}",
                  color: Colors.grey),
              Row(children: [
                BUTTON(
                    text: 'Créer',
                    action: () {
                      parentCode = '';
                      create();
                    },
                    type: 'BLEU')
              ])
            ]))
        : isModaleSearch
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        LABEL(
                            text: 'Code : ${map['code']}',
                            color: Colors.grey,
                            isBold: true),
                        if (map['dateCreate'] != null)
                          LABEL(
                              text:
                                  ' / ${DateFormat('dd/MM/yyyy HH:mm').format(map['dateCreate'].toDate()).toString()}')
                      ]),
                      LABEL(text: 'Montant Investi : ${map['montant']} MGA'),
                      const SizedBox(height: 10),
                      designEtage(),
                      const SizedBox(height: 10),
                      legende(),
                      if (checIamInBoite(map)) const SizedBox(height: 10),
                      if (checIamInBoite(map))
                        LABEL(
                            text:
                                "Mon code : ${CRYPTO().crypte("${map['code']}-${userActif['login']}")}",
                            color: Colors.grey),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          if (checIamInBoite(map))
                            BUTTON(
                                text: 'Copier code',
                                action: () {
                                  String code = CRYPTO().crypte(
                                      "${map['code']}-${userActif['login']}");
                                  copieCodeToClip(code);
                                }),
                          if (checIamInBoite(map)) const SizedBox(width: 10),
                          BUTTON(
                              text: 'Voir les membres',
                              action: () => showModaleMembre(context)),
                          if (!checIamInBoite(map)) const SizedBox(width: 10),
                          if (!checIamInBoite(map))
                            BUTTON(
                                text: 'Rejoindre',
                                action: () => rejoindreBoite())
                              ..color = Colors.white
                              ..colorBg = Colors.green
                        ]),
                      )
                    ]))
            : isCarousel
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                        decoration: BoxDecoration(
                            // gradient: colors[Random().nextInt(colors.length)],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3))
                            ]),
                        child: InkWell(
                          splashColor: Colors.green,
                          onTap: () {
                            MODALE showMe = MODALE(context, 'Vu boites', '')
                              ..type = 'CUSTOM'
                              ..child = Container(child: vu(context));
                            showMe.show();
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LABEL(
                                        text: 'M.I : ${map['montant']} MGA',
                                        color: Colors.black),
                                    const SizedBox(height: 10),
                                    designEtage(isCarousel: true),
                                    const SizedBox(height: 10),
                                    mesState(isCarousel: false)
                                  ])),
                        )))
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                LABEL(
                                    text: 'Code : ${map['code']}',
                                    color: Colors.grey,
                                    isBold: true),
                                if (map['dateCreate'] != null)
                                  LABEL(
                                      text:
                                          ' / ${DateFormat('dd/MM/yyyy HH:mm').format(map['dateCreate'].toDate()).toString()}')
                              ]),
                              LABEL(
                                  text:
                                      'Montant Investi : ${map['montant']} MGA',
                                  color: Colors.brown),
                              const SizedBox(height: 10),
                              designEtage(),
                              const SizedBox(height: 10),
                              legende(),
                              const SizedBox(height: 10),
                              if (checIamInBoite(map)) mesState(),
                              if (checIamInBoite(map))
                                const SizedBox(height: 10),
                              if (checIamInBoite(map))
                                LABEL(
                                    text:
                                        "Mon code : ${CRYPTO().crypte("${map['code']}-${userActif['login']}")}",
                                    color: Colors.grey),
                              Row(children: [
                                if (checIamInBoite(map))
                                  BUTTON(
                                      text: 'Copier code',
                                      action: () {
                                        String code = CRYPTO().crypte(
                                            "${map['code']}-${userActif['login']}");
                                        copieCodeToClip(code);
                                      }),
                                const SizedBox(width: 10),
                                BUTTON(
                                    text: 'Voir les membres',
                                    action: () => showModaleMembre(context)),
                              ]),
                              const SizedBox(height: 10),
                              histo()
                            ]),
                      ),
                    ));
  }

  // =========================== FUNCTION
  create({bool isHaveSortant = false}) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    // INSERT new
    loading.show('Chargement ...');
    String t = table['boite']!;
    base.insert(t, map['code'].toString(), map, (result, value) {
      if (result == 'error') toast.show('Erreur de création de la boite !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      // UPDATE fiche
      loading.show('Mise à jour de la fiche ...');
      base.rejoindreBoite(
          userActif['login'], map['code'], parentCode, map['montant'],
          (result) {
        Map<String, dynamic> histo = {
          'description':
              '${userActif['login']} a réjoint la boite${parentCode != '' ? ', invité par $parentCode' : ''}.',
          'code': newCode(25),
          'dateTimes': Timestamp.now()
        };
        loading.show('Mise à jour de la tracage ...');
        String here = "${table['boite']}/${map['code']}/${table['histoBoite']}";
        base.insert(here, histo['code'], histo, (result, value) {
          if (result == 'error') toast.show('Une problème est survenue !');
          if (result == 'error') loading.hide();
          if (result == 'error') return;
          if (isHaveSortant) {
            base.updateTablePlein(map['code'], (res, value) {
              userActif["boites"].add(map['code']);
              userActif["ariary"] -= map['montant'];
              userActif["exp"] -= EXP().exp;
              toast.show("Nouvelle boite crée");
              loading.hide();
              vuModaleNew.hide();
              redraw();
            });
          } else {
            userActif["boites"].add(map['code']);
            userActif["ariary"] -= map['montant'];
            userActif["exp"] += EXP().exp;
            toast.show("Nouvelle boite crée");
            loading.hide();
            vuModaleNew.hide();
            redraw();
          }
        });
      });
    });
  }

  // ===================================================
  rejoindreBoite() async {
    if (map['montant'] > userActif['ariary']) {
      toast.show("Votre sold est insuffisant");
    }
    if (map['montant'] > userActif['ariary']) return;

    if (!EXP().checPrivillege_NbBoiteMaxe(userActif['level'], nbMyBoite))
      // ignore: curly_braces_in_flow_control_structures
      toast.show(
          "Vous avez déjà attein le nombre maximum de votre boite en cours !");
    if (!EXP().checPrivillege_NbBoiteMaxe(userActif['level'], nbMyBoite)) {
      return;
    }

    bool haveSortant = true;

    for (var i = 1; i < 4; i++) {
      if (i == 3) {
        for (var j = 0; j < 2; j++) {
          if (map['etages'][i.toString()][j] == 'vide') haveSortant = false;
        }
      }
      if (i == 2) {
        for (var j = 0; j < 4; j++) {
          if (map['etages'][i.toString()][j] == 'vide') haveSortant = false;
        }
      }
      if (i == 1) {
        for (var j = 0; j < 8; j++) {
          if (map['etages'][i.toString()][j] == 'vide') haveSortant = false;
        }
      }
    }
    if (haveSortant) toast.show("La boite est déjà plein !");
    if (haveSortant) return;

    // update place
    updatePlaceJoin();

    haveSortant = true;

    // chec  A Nouveau > pour le mettre dan la boite a traiter des admni
    for (var i = 1; i < 4; i++) {
      if (i == 3) {
        for (var j = 0; j < 2; j++) {
          if (map['etages'][i.toString()][j] == 'vide') haveSortant = false;
        }
      }
      if (i == 2) {
        for (var j = 0; j < 4; j++) {
          if (map['etages'][i.toString()][j] == 'vide') haveSortant = false;
        }
      }
      if (i == 1) {
        for (var j = 0; j < 8; j++) {
          if (map['etages'][i.toString()][j] == 'vide') haveSortant = false;
        }
      }
    }

    // chec SORTANT
    create(isHaveSortant: haveSortant);
  }

  // ===================================================

  updatePlaceJoin() {
    //  ETAGE
    if (map['isNew']) {
      map['etages']['3'][0] = map['etages']['3'][1];
      map['etages']['3'][1] = map['etages']['2'][0];

      map['etages']['2'][0] = map['etages']['2'][1];
      map['etages']['2'][1] = map['etages']['2'][2];
      map['etages']['2'][2] = map['etages']['2'][3];
      map['etages']['2'][3] = map['etages']['1'][0];
    }

    map['etages']['1'][0] = map['etages']['1'][1];
    map['etages']['1'][1] = map['etages']['1'][2];
    map['etages']['1'][2] = map['etages']['1'][3];
    map['etages']['1'][3] = map['etages']['1'][4];
    map['etages']['1'][4] = map['etages']['1'][5];
    map['etages']['1'][5] = map['etages']['1'][6];
    map['etages']['1'][6] = map['etages']['1'][7];
    map['etages']['1'][7] = userActif['login'];

    // INFO ETAGE
    if (map['etages']['3'][0] != 'vide') {
      map['informations'][map['etages']['3'][0]]['etage'] = 3;
    }
    if (map['etages']['3'][1] != 'vide') {
      map['informations'][map['etages']['3'][1]]['etage'] = 3;
    }

    if (map['etages']['2'][0] != 'vide') {
      map['informations'][map['etages']['2'][0]]['etage'] = 2;
    }
    if (map['etages']['2'][1] != 'vide') {
      map['informations'][map['etages']['2'][1]]['etage'] = 2;
    }
    if (map['etages']['2'][2] != 'vide') {
      map['informations'][map['etages']['2'][2]]['etage'] = 2;
    }
    if (map['etages']['2'][3] != 'vide') {
      map['informations'][map['etages']['2'][3]]['etage'] = 2;
    }

    if (map['etages']['1'][0] != 'vide') {
      map['informations'][map['etages']['1'][0]]['etage'] = 1;
    }
    if (map['etages']['1'][1] != 'vide') {
      map['informations'][map['etages']['1'][1]]['etage'] = 1;
    }
    if (map['etages']['1'][2] != 'vide') {
      map['informations'][map['etages']['1'][2]]['etage'] = 1;
    }
    if (map['etages']['1'][3] != 'vide') {
      map['informations'][map['etages']['1'][3]]['etage'] = 1;
    }
    if (map['etages']['1'][0] != 'vide') {
      map['informations'][map['etages']['1'][0]]['etage'] = 1;
    }
    if (map['etages']['1'][1] != 'vide') {
      map['informations'][map['etages']['1'][1]]['etage'] = 1;
    }
    if (map['etages']['1'][2] != 'vide') {
      map['informations'][map['etages']['1'][2]]['etage'] = 1;
    }
    if (map['etages']['1'][3] != 'vide') {
      map['informations'][map['etages']['1'][3]]['etage'] = 1;
    }

    map['membres'].add(userActif['login'].toString());

    // INFORMATIONS
    map['informations'][userActif['login']] = {
      'childNbr': 0,
      'childs': [],
      'dateDebut': Timestamp.now(),
      'etage': 1
    };

    if (parentCode == userActif['login'].toString()) parentCode = '';
    if (parentCode == '') return;
    if (!checParentIsInBoite(parentCode, map['membres'])) parentCode = '';
    if (!checParentIsInBoite(parentCode, map['membres'])) return;

    map['informations'][parentCode]['childNbr'] += 1;
    map['informations'][parentCode]['childs'].add(userActif['login']);
  }

  // =========================== VU

  Widget icon(String type, {bool isCarousel = false}) {
    double size = 20;
    if (type == 'ME') {
      return Icon(Icons.portrait, color: Colors.green, size: size);
    }
    if (type == 'OTHER') {
      return Icon(Icons.portrait, color: Colors.black, size: size);
    }
    // VIDE
    return Icon(Icons.check_box_outline_blank, color: Colors.black, size: size);
  }

  Widget designEtage({bool isCarousel = false}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(children: [
            icon(
                userActif['login'] == map['etages']['3'][0]
                    ? 'ME'
                    : 'vide' == map['etages']['3'][0]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['3'][1]
                    ? 'ME'
                    : 'vide' == map['etages']['3'][1]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            if (!isCarousel) const SizedBox(width: 5),
            if (!isCarousel) LABEL(text: ' ... (2e etage)', color: Colors.grey)
          ]),
          Row(children: [
            icon(
                userActif['login'] == map['etages']['2'][0]
                    ? 'ME'
                    : 'vide' == map['etages']['2'][0]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['2'][1]
                    ? 'ME'
                    : 'vide' == map['etages']['2'][1]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['2'][2]
                    ? 'ME'
                    : 'vide' == map['etages']['2'][2]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['2'][3]
                    ? 'ME'
                    : 'vide' == map['etages']['2'][3]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            if (!isCarousel) const SizedBox(width: 5),
            if (!isCarousel) LABEL(text: ' ... (1er etage)', color: Colors.grey)
          ]),
          Row(children: [
            icon(
                userActif['login'] == map['etages']['1'][0]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][0]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][1]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][1]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][2]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][2]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][3]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][3]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][4]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][4]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][5]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][5]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][6]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][6]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            icon(
                userActif['login'] == map['etages']['1'][7]
                    ? 'ME'
                    : 'vide' == map['etages']['1'][7]
                        ? 'VIDE'
                        : 'OTHER',
                isCarousel: isCarousel),
            if (!isCarousel) const SizedBox(width: 5),
            if (!isCarousel) LABEL(text: ' ... (Entré)', color: Colors.grey)
          ])
        ]));
  }

  Widget legende() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LABEL(text: 'Legende ', isBold: true, color: Colors.grey),
        // const SizedBox(height: 5),
        Row(children: [LABEL(text: 'Moi : '), icon('ME')]),
        Row(children: [LABEL(text: 'Autre : '), icon('OTHER')]),
        Row(children: [LABEL(text: 'Libre : '), icon('VIDE')]),
      ],
    );
  }

  recalculeProgression() {
    meProgression = 0;
    if (!checIamInBoite(map)) return;
    //
    if (map['informations'][userActif['login']]['childNbr'] > 0) {
      meProgression +=
          map['informations'][userActif['login']]['childNbr'] * cote;
    }
    //
    if (map['informations'][userActif['login']]['etage'] > 0) {
      meProgression +=
          (map['informations'][userActif['login']]['etage'] - 1) * cote;
    }

    if (map['informations'][userActif['login']]['childNbr'] > 1) {
      meProgression += bonusSortant;
    }

    if (map['informations'][userActif['login']]['etage'] > 2) {
      meProgression -= fraisSecu;
    }

    // ticket['informations']['cote child'] * ticket['informations']['nb child']
    // + ticket['informations']['cote etage'] * ticket['informations']['etage']
    // + ticket['informations']['bonus']
    // - ticket['informations']['frais secu']
  }

  Widget mesState({isCarousel = false}) {
    recalculeProgression();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LABEL(
            text: 'Mes statistiques ',
            isBold: true,
            color: isCarousel ? Colors.white : Colors.grey),
        if (checIamInBoite(map))
          LABEL(
              text:
                  'Nb. childs : ${map['informations'][userActif['login']]['childNbr']}',
              color: isCarousel ? Colors.white : Colors.black),
        if (checIamInBoite(map))
          LABEL(
              text:
                  'Etage : ${map['informations'][userActif['login']]['etage'] - 1}',
              color: isCarousel ? Colors.white : Colors.black),
        LABEL(
            text: 'Progression : $meProgression%',
            color: isCarousel ? Colors.white : Colors.black),
        LABEL(
            text:
                '${isCarousel ? 'A recévoir' : 'Montant a recévoir'}  : ${(map['montant'] * meProgression / 100).round()} MGA',
            color: isCarousel ? Colors.white : Colors.teal),
      ],
    );
  }

  // get list transaction
  getHistorique(Function pass) {
    loading.show('Chargement des historiques ...');
    String here = "${table['boite']}/${map['code']}/${table['histoBoite']}";
    base.selectList(here, (res) {
      List<Map> liste = [];
      for (var historique in res) {
        liste.add(historique);
      }
      loading.hide();
      pass(liste);
    },
        haveLimit: true,
        limit: 2,
        haveOrder: true,
        order: 'dateTimes',
        desc: true);
  }

  Widget histo() {
    List<Widget> histo = [];

    for (var t in histoList) {
      histo.add(Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SizedBox(
            width: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.calendar_month, size: 15),
                      if (t['date'] != null)
                        LABEL(
                            text: DateFormat('dd/MM/yyyy HH:mm')
                                .format(t['date'].toDate())
                                .toString(),
                            color: Colors.grey)
                    ]),
                    LABEL(text: t['description'])
                  ]),
            ),
          )));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LABEL(text: 'Historique ', isBold: true, color: Colors.grey),
          const SizedBox(height: 10),
          Column(children: histo)
        ]);
  }

// ============================================================
  showModaleMembre(BuildContext context) async {
    loading.show('Chargement des membres ...');

    List<Map<String, dynamic>> users = [];
    List<Widget> vu = [];

    for (var u in map['membres']) {
      await base.select(table['user']!, u.toString(), (result, value) {
        Map<String, dynamic> user = value.data() as Map<String, Object?>;
        users.add(user);
      });
    }

    for (var u in users) {
      vu.add(Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(children: [
            SizedBox(
                height: 40,
                width: 40,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: pdp(u['urlPdp'].toString(),
                        () => showProfile(context, u)))),
            LABEL(text: u['login'])
          ])));
    }

    // ignore: use_build_context_synchronously
    MODALE mListMembre = MODALE(context, 'Vu boites', '')
      ..type = 'CUSTOM'
      ..child = Column(children: [
        LABEL(text: "Les membres de la boite ", isBold: true),
        const SizedBox(height: 10),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: Row(children: vu))
      ]);

    loading.hide();
    mListMembre.show();
  }
}
