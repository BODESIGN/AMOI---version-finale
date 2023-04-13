// ignore_for_file: file_names

import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

traiterPassationBoite(Map boite, Function pass) async {
  // chec connexion
  if (!await connectivite.checkData(toast.show)) return;

  // INSERT new
  loading.show('Chargement ...');

  // SEND MONTANT >> TO 2 sortant > montant to SOLD AMOI
  List<String> sortants = [];
  for (var sortant in boite['etages']['3']) {
    sortants.add(sortant.toString());
  }

  // Create 2 MAP
  // => 1 ==============================================================
  Map<String, dynamic> map1 = {
    'code': newCode(),
    'montant': boite['montant'],
    'dateCreate': getDateNow(),
    'isNew': false,
    'etages': {
      '1': ['vide', 'vide', 'vide', 'vide', 'vide', 'vide', 'vide', 'vide'],
      '2': [
        boite['etages']['1'][0].toString(),
        boite['etages']['1'][1].toString(),
        boite['etages']['1'][2].toString(),
        boite['etages']['1'][3].toString()
      ],
      '3': [
        boite['etages']['2'][0].toString(),
        boite['etages']['2'][1].toString()
      ]
    },
    'membres': [
      boite['etages']['2'][0].toString(),
      boite['etages']['2'][1].toString(),
      boite['etages']['1'][0].toString(),
      boite['etages']['1'][1].toString(),
      boite['etages']['1'][2].toString(),
      boite['etages']['1'][3].toString()
    ],
    'informations': {
      boite['etages']['2'][0].toString(): boite['informations']
          [boite['etages']['2'][0].toString()],
      boite['etages']['2'][1].toString(): boite['informations']
          [boite['etages']['2'][1].toString()],
      boite['etages']['1'][0].toString(): boite['informations']
          [boite['etages']['1'][0].toString()],
      boite['etages']['1'][1].toString(): boite['informations']
          [boite['etages']['1'][1].toString()],
      boite['etages']['1'][2].toString(): boite['informations']
          [boite['etages']['1'][2].toString()],
      boite['etages']['1'][3].toString(): boite['informations']
          [boite['etages']['1'][3].toString()],
    }
  };
  map1['informations'][boite['etages']['2'][0].toString()]['etage'] = 3;
  map1['informations'][boite['etages']['2'][1].toString()]['etage'] = 3;
  map1['informations'][boite['etages']['1'][0].toString()]['etage'] = 2;
  map1['informations'][boite['etages']['1'][1].toString()]['etage'] = 2;
  map1['informations'][boite['etages']['1'][2].toString()]['etage'] = 2;
  map1['informations'][boite['etages']['1'][3].toString()]['etage'] = 2;

  // => 2 ==============================================================
  Map<String, dynamic> map2 = {
    'code': newCode(),
    'montant': boite['montant'],
    'dateCreate': getDateNow(),
    'isNew': false,
    'etages': {
      '1': ['vide', 'vide', 'vide', 'vide', 'vide', 'vide', 'vide', 'vide'],
      '2': [
        boite['etages']['1'][4].toString(),
        boite['etages']['1'][5].toString(),
        boite['etages']['1'][6].toString(),
        boite['etages']['1'][7].toString()
      ],
      '3': [
        boite['etages']['2'][2].toString(),
        boite['etages']['2'][3].toString()
      ]
    },
    'membres': [
      boite['etages']['2'][2].toString(),
      boite['etages']['2'][3].toString(),
      boite['etages']['1'][4].toString(),
      boite['etages']['1'][5].toString(),
      boite['etages']['1'][6].toString(),
      boite['etages']['1'][7].toString()
    ],
    'informations': {
      boite['etages']['2'][2].toString(): boite['informations']
          [boite['etages']['2'][2].toString()],
      boite['etages']['2'][3].toString(): boite['informations']
          [boite['etages']['2'][3].toString()],
      boite['etages']['1'][4].toString(): boite['informations']
          [boite['etages']['1'][4].toString()],
      boite['etages']['1'][5].toString(): boite['informations']
          [boite['etages']['1'][5].toString()],
      boite['etages']['1'][6].toString(): boite['informations']
          [boite['etages']['1'][6].toString()],
      boite['etages']['1'][7].toString(): boite['informations']
          [boite['etages']['1'][7].toString()],
    }
  };
  map2['informations'][boite['etages']['2'][2].toString()]['etage'] = 3;
  map2['informations'][boite['etages']['2'][3].toString()]['etage'] = 3;
  map2['informations'][boite['etages']['1'][4].toString()]['etage'] = 2;
  map2['informations'][boite['etages']['1'][5].toString()]['etage'] = 2;
  map2['informations'][boite['etages']['1'][6].toString()]['etage'] = 2;
  map2['informations'][boite['etages']['1'][7].toString()]['etage'] = 2;

  // SEND NOTIF into 2 MAP
  Map<String, dynamic> histo1 = {
    'description':
        '✅ Boite dupliquée, la code a changé (veuillez recopier votre code 😉)',
    'date': getDateNow(),
    'dateTimes': Timestamp.now()
  };
  String here1 = "${table['boite']}/${map1['code']}/${table['histoBoite']}";

  Map<String, dynamic> histo2 = {
    'description':
        '✅ Boite dupliquée, la code a changé (veuillez recopier votre code 😉)',
    'date': getDateNow(),
    'dateTimes': Timestamp.now()
  };
  String here2 = "${table['boite']}/${map2['code']}/${table['histoBoite']}";

  // = RUN
  loading.show('Création des nouveau boites ...');
  await createBoite(map1, map2, histo1, histo2, here1, here2);

  loading.show('Mise à jour de membre de la boite 1 ...');
  await updateAllUser(map1['membres'], boite['code'], map1['code']);

  loading.show('Mise à jour de membre de la boite 2 ...');
  await updateAllUser(map2['membres'], boite['code'], map2['code']);

  loading.show('Mise à jour des sortants ...');
  await updateSortant(sortants, boite);

  loading.show('Mise à jour des Parent des sortants ...');
  await updateSortantParent(sortants, boite);

  loading.show("Suppression de l'ancien boite ...");
  await deleteBoite(boite['code']);

  loading.show("Mise à jour Sold du mois ...");
  await updateSoldDuMois(boite['montant']);

  loading.hide();

  pass();
}

// ==========================================================================
updateAllUser(List<String> users, String exBoite, String newBoite) async {
  for (var u in users) {
    await base.quitBoiteToNew(u, exBoite, newBoite);
  }
}

// ==========================================================================
double cote = 48.5;
double bonusSortant = 17.5;
double fraisSecu = 12.5;

int getProgress(String u, Map map) {
  double meProgression = 0;
  //
  if (map['informations'][u]['childNbr'] > 0) {
    meProgression += map['informations'][u]['childNbr'] * cote;
  }
  //
  if (map['informations'][u]['etage'] > 0) {
    meProgression += (map['informations'][u]['etage'] - 1) * cote;
  }
  //
  if (map['informations'][u]['childNbr'] > 1) {
    meProgression += bonusSortant;
  }
  meProgression -= fraisSecu;

  // ticket['informations']['cote child'] * ticket['informations']['nb child']
  // + ticket['informations']['cote etage'] * ticket['informations']['etage']
  // + ticket['informations']['bonus']
  // - ticket['informations']['frais secu']

  return (map['montant'] * meProgression / 100).round();
}

updateSortant(List<String> users, Map map) async {
  for (var u in users) {
    int m = getProgress(u, map);
    Map<String, dynamic> infoTicket = {
      'montant': map['montant'],
      'cote child': cote,
      'cote etage': cote,
      'bonus': map['informations'][u]['childNbr'] > 1 ? bonusSortant : 0,
      'frais secu': fraisSecu,
      'nb child': map['informations'][u]['childNbr'],
      'etage': map['informations'][u]['etage'],
      'code boite': map['code'],
      'Net recu': m
    };
    await base.quitBoiteToSortant(u, map['code'], m);
    await base.sendTiquetSortant(u, map['code'], m, infoTicket);
  }
}

// ==========================================================================
updateSortantParent(List<String> users, Map map) async {
  for (var u in users) {
    int m = map['informations'][u]['childNbr'] > 1
        ? (map['montant'] * bonusSortant / 100).round()
        : 0;
    Map<String, dynamic> infoTicket = {
      'montant': map['montant'],
      'cote': map['informations'][u]['childNbr'] > 1 ? bonusSortant : 0,
      'code boite': map['code'],
      'Net recu': m
    };
    await base.quitBoiteToSortantParent(u, m);
    await base.sendTiquetSortantParent(u, map['code'], m, infoTicket);
  }
}

// ==========================================================================
createBoite(
  Map<String, dynamic> map1,
  Map<String, dynamic> map2,
  Map<String, dynamic> histo1,
  Map<String, dynamic> histo2,
  String here1,
  String here2,
) async {
  await base.createNewBoite(map1, histo1, here1);
  await base.createNewBoite(map2, histo2, here2);
}

// ==========================================================================
deleteBoite(String code) async {
  await base.deleteBoite(code);
}

// ==========================================================================
updateSoldDuMois(int montant) async {
  double sold = montant * (fraisSecu / 100);
  sold *= 2; // pour 2 sortant
  await base.updateChiffreSold(sold);
}
