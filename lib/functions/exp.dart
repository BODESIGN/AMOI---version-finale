// ignore_for_file: non_constant_identifier_names

import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:flutter/material.dart';

class EXP {
  Map level = {
    1: 0, // + 1000
    2: 1000, // + 1500
    3: 2500, // + 2000
    4: 4500, // + 2500
    5: 7000, // + 3000
    6: 10000, // + 5000
    7: 15000
  };

  Map privilege = {
    'Niv. 1': {
      'id': 1,
      'nom': 'Membre junior',
      'nb boite max': 3,
      'sold delivrable max': 30000, //ariary
      'revenue actionnaire': 0 //%
    },
    'Niv. 2': {
      'id': 2,
      'nom': 'Membre sénior',
      'nb boite max': 5,
      'sold delivrable max': 50000, //ariary
      'revenue actionnaire': 0 //%
    },
    'Niv. 3': {
      'id': 3,
      'nom': 'Collaborateur junior',
      'nb boite max': 0,
      'sold delivrable max': 50000, //ariary
      'revenue actionnaire': 0 //%
    },
    'Niv. 4': {
      'id': 4,
      'nom': 'Collaborateur sénior',
      'nb boite max': 0,
      'sold delivrable max': 100000, //ariary
      'revenue actionnaire': 0 //%
    },
    'Niv. 5': {
      'id': 5,
      'nom': 'Pré-actionnaire',
      'nb boite max': 0,
      'sold delivrable max': 100000, //ariary
      'revenue actionnaire': 1 //%
    },
    'Niv. 6': {
      'id': 6,
      'nom': 'Actionnaire junior',
      'nb boite max': 0,
      'sold delivrable max': 0, //ariary
      'revenue actionnaire': 2.5 //%
    },
    'Niv. 7': {
      'id': 7,
      'nom': 'Actionnaire sénior',
      'nb boite max': 0,
      'sold delivrable max': 0, //ariary
      'revenue actionnaire': 5 //%
    },
  };

  int exp = 75; // REFA :
  // _ mirejoindre boite
  // _ mis child mi rejoindre

  // -----------------------------------------------------------------
  bool checPrivillege_NbBoiteMaxe(int niv, int nbMyBoite) {
    if (privilege['Niv. $niv']['nb boite max'] == 0) return true;
    if (privilege['Niv. $niv']['nb boite max'] == nbMyBoite) return false;
    return true;
  }

  bool checPrivillege_SoldMax(int niv, int sold) {
    if (privilege['Niv. $niv']['sold delivrable max'] == 0) return true;
    if (privilege['Niv. $niv']['sold delivrable max'] <= sold) return false;
    return true;
  }

  // -----------------------------------------------------------------
  int getLevelOf(int exp) {
    int niv = 1;
    bool b = false;
    if (exp < level[2]) {
      niv = 1;
      b = true;
    }
    if ((exp < level[3]) && !b) {
      niv = 2;
      b = true;
    }
    if ((exp < level[4]) && !b) {
      niv = 3;
      b = true;
    }
    if ((exp < level[5]) && !b) {
      niv = 4;
      b = true;
    }
    if ((exp < level[6]) && !b) {
      niv = 5;
      b = true;
    }
    if ((exp < level[7]) && !b) {
      niv = 6;
      b = true;
    }
    if (exp >= level[7]) {
      niv = 7;
    }
    return niv;
  }

  // -----------------------------------------------------------------
  showPrivilege(BuildContext context, int niv, int exp) {
    List<Widget> vu = [];
    privilege.forEach((key, value) {
      //
      String exp = '';
      //
      if (value['id'] < 7) {
        level.forEach((k, v) {
          if (k == value['id'] + 1) exp = "(Exp max : $v)";
        });
      } else {
        exp = "(Exp : +${level[7]})";
      }
      //
      vu.add(Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              LABEL(
                  text:
                      'Niveau ${value['id']} / ${value['nom']} ${niv == value['id'] ? '(👤)' : ''}',
                  isBold: true),
              LABEL(text: exp, isBold: true)
            ]),
            LABEL(text: 'Nombre maximum de boite : ${value['nb boite max']}'),
            LABEL(
                text:
                    'Sold délivrable maximum (pour les dépot) : ${value['sold delivrable max']} MGA'),
            LABEL(
                text: 'Révenue actionnaire : ${value['revenue actionnaire']} %')
          ])));
    });
    MODALE m = MODALE(context, 'Vu boites', '')
      ..type = 'CUSTOM'
      ..child = SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LABEL(
                        text: "Niveau & Privillège",
                        size: 15,
                        color: Colors.green),
                    const SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: vu)
                  ])));
    m.show();
  }
}
