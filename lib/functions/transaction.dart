// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TRANSACTION {
  //
  String getTraiteur() {
    if (administrator['admin'].length == 1) return administrator['admin'][0];
    final _random = Random();
    return administrator['admin']
        [_random.nextInt(administrator['admin'].length)];
  }

  //
  retrait(String codeUser, String tel, int montant, Function pass) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    loading.show('Demande en cours ...');
    Map<String, dynamic> demande = {
      'type': 'Retrait',
      'codeUser': codeUser,
      'tel': tel,
      'montant': montant,
      'date': Timestamp.now(),
      'traiter': false,
      'traiterDate': Timestamp.now(),
      'traiteur': getTraiteur()
    };
    String code = "$codeUser - ${demande['type']}";
    base.insert(table['demande']!, code, demande, (result, value) {
      if (result == 'error') toast.show('Une problème est survenue !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      Map<String, dynamic> transaction = {
        'description':
            'Demande de retrait envoyé (Montant : $montant / tel : $tel)',
        'code': newCode(20),
        'dateTimes': Timestamp.now()
      };
      String here = "${table['user']}/$codeUser/${table['transaction']}";
      base.insert(here, transaction['code'], transaction, (result, value) {
        if (result == 'error') toast.show('Une problème est survenue !');
        if (result == 'error') loading.hide();
        if (result == 'error') return;
        loading.hide();
        pass();
      });
    });
  }

  //
  depot(String codeUser, String tel, int montant, Function pass) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    loading.show('Demande en cours ...');
    Map<String, dynamic> demande = {
      'type': 'Depot',
      'codeUser': codeUser,
      'tel': tel,
      'montant': montant,
      'date': Timestamp.now(),
      'traiter': false,
      'traiterDate': Timestamp.now(),
      'traiteur': getTraiteur()
    };
    String code = "$codeUser - ${demande['type']}";
    base.insert(table['demande']!, code, demande, (result, value) {
      if (result == 'error') toast.show('Une problème est survenue !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      Map<String, dynamic> transaction = {
        'description':
            'Demande de dépôt envoyé (Montant : $montant / tel : $tel)',
        'code': newCode(20),
        'dateTimes': Timestamp.now()
      };
      String here = "${table['user']}/$codeUser/${table['transaction']}";
      base.insert(here, transaction['code'], transaction, (result, value) {
        if (result == 'error') toast.show('Une problème est survenue !');
        if (result == 'error') loading.hide();
        if (result == 'error') return;
        loading.hide();
        pass();
      });
    });
  }

  // traiter  dmd
  traiterDepot(Map dmd, Function pass) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;
    loading.show('Traitement en cours ...');

    Map<String, dynamic> demande = {
      'type': dmd['type'],
      'codeUser': dmd['codeUser'],
      'tel': dmd['tel'],
      'montant': dmd['montant'],
      'date': dmd['date'],
      'traiter': true,
      'traiterDate': Timestamp.now(),
      'traiteur': dmd['traiteur']
    };
    // update LISTE DEMANDE - ADMIN
    String code = "${dmd['codeUser']} - ${dmd['type']}";
    base.insert(table['demande']!, code, demande, (result, value) {
      if (result == 'error') toast.show('Une problème est survenue ! (1)');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      // UPDATE MONATANT FICHE
      base.updateAriary(table['user']!, dmd['codeUser'], dmd['montant'],
          (result, value) {
        if (result == 'error') toast.show('Une problème est survenue ! (2)');
        if (result == 'error') loading.hide();
        if (result == 'error') return;
        // UPDATE CHIFFRE DAFFAIRE
        base.updateChiffreAffaire(
            table['setting']!, table['admin']!, dmd['montant'],
            (result, value) {
          if (result == 'error') toast.show('Une problème est survenue ! (3)');
          if (result == 'error') loading.hide();
          if (result == 'error') return;
          Map<String, dynamic> transaction = {
            'description':
                'Demande de dépôt validée avec succée (Montant : ${dmd['montant']} / tel : ${dmd['tel']})',
            'code': newCode(20),
            'dateTimes': Timestamp.now()
          };
          String here =
              "${table['user']}/${dmd['codeUser']}/${table['transaction']}";
          // SET TRANSACTION in HISTORIQUE
          base.insert(here, transaction['code'], transaction, (result, value) {
            if (result == 'error') {
              toast.show('Une problème est survenue ! (4)');
            }
            if (result == 'error') loading.hide();
            if (result == 'error') return;
            Map<String, dynamic> transaction2 = {
              'code': newCode(20),
              'admin': userActif['login'],
              'montant': dmd['montant'],
              'type': 'Entré',
              'dateTimes': Timestamp.now()
            };
            String here =
                "${table['setting']}/${table['admin']}/${table['histoMoney']}";
            // SET TRANSACTION in HISTORIQUE CHIFFRE DAFFAIER
            base.insert(here, transaction2['code'], transaction2,
                (result, value) {
              if (result == 'error') {
                toast.show('Une problème est survenue ! (5)');
              }
              if (result == 'error') loading.hide();
              if (result == 'error') return;
              loading.hide();
              pass();
            });
          });
        });
      });
    });
  }

  // traiter  dmd
  traiterRetrait(Map dmd, Function pass) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;
    loading.show('Traitement en cours ...');

    Map<String, dynamic> demande = {
      'type': dmd['type'],
      'codeUser': dmd['codeUser'],
      'tel': dmd['tel'],
      'montant': dmd['montant'],
      'date': dmd['date'],
      'traiter': true,
      'traiterDate': Timestamp.now(),
      'traiteur': dmd['traiteur']
    };
    // update LISTE DEMANDE - ADMIN
    String code = "${dmd['codeUser']} - ${dmd['type']}";
    base.insert(table['demande']!, code, demande, (result, value) {
      if (result == 'error') toast.show('Une problème est survenue ! (1)');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      // UPDATE MONATANT FICHE
      base.updateAriary(table['user']!, dmd['codeUser'], -(dmd['montant']),
          (result, value) {
        if (result == 'error') toast.show('Une problème est survenue ! (2)');
        if (result == 'error') loading.hide();
        if (result == 'error') return;
        // UPDATE CHIFFRE DAFFAIRE
        base.updateChiffreAffaireRetrait(
            table['setting']!, table['admin']!, (dmd['montant']),
            (result, value) {
          if (result == 'error') toast.show('Une problème est survenue ! (3)');
          if (result == 'error') loading.hide();
          if (result == 'error') return;
          Map<String, dynamic> transaction = {
            'description':
                'Demande de retrait validée avec succée (Montant : ${dmd['montant']} / tel : ${dmd['tel']})',
            'code': newCode(20),
            'dateTimes': Timestamp.now()
          };
          String here =
              "${table['user']}/${dmd['codeUser']}/${table['transaction']}";
          // SET TRANSACTION in HISTORIQUE
          base.insert(here, transaction['code'], transaction, (result, value) {
            if (result == 'error') {
              toast.show('Une problème est survenue ! (4)');
            }
            if (result == 'error') loading.hide();
            if (result == 'error') return;
            Map<String, dynamic> transaction2 = {
              'code': newCode(20),
              'admin': userActif['login'],
              'montant': dmd['montant'],
              'type': 'Sortie',
              'dateTimes': Timestamp.now()
            };
            String here =
                "${table['setting']}/${table['admin']}/${table['histoMoney']}";
            // SET TRANSACTION in HISTORIQUE CHIFFRE DAFFAIER
            base.insert(here, transaction2['code'], transaction2,
                (result, value) {
              if (result == 'error') {
                toast.show('Une problème est survenue ! (5)');
              }
              if (result == 'error') loading.hide();
              if (result == 'error') return;
              loading.hide();
              pass();
            });
          });
        });
      });
    });
  }

  // SUPPRIMER  dmd
  supprimerDemmande(Map dmd, Function pass) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;
    loading.show('Traitement en cours ...');

    Map<String, dynamic> demande = {
      'type': dmd['type'],
      'codeUser': dmd['codeUser'],
      'tel': dmd['tel'],
      'montant': dmd['montant'],
      'date': dmd['date'],
      'traiter': true,
      'traiterDate': Timestamp.now(),
      'traiteur': dmd['traiteur']
    };
    // update LISTE DEMANDE - ADMIN
    String code = "${dmd['codeUser']} - ${dmd['type']}";
    base.insert(table['demande']!, code, demande, (result, value) {
      if (result == 'error') toast.show('Une problème est survenue ! (1)');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      Map<String, dynamic> transaction = {
        'description':
            '⚠️ Demande supprimmée (Montant : ${dmd['montant']} / Type : ${dmd['type']} / tel : ${dmd['tel']})',
        'code': newCode(20),
        'dateTimes': Timestamp.now()
      };
      String here =
          "${table['user']}/${dmd['codeUser']}/${table['transaction']}";
      // SET TRANSACTION in HISTORIQUE
      base.insert(here, transaction['code'], transaction, (result, value) {
        if (result == 'error') toast.show('Une problème est survenue ! (4)');
        if (result == 'error') loading.hide();
        if (result == 'error') return;
        loading.hide();
        pass();
      });
    });
  }

  // get list transaction
  getTransaction(String codeUser, Function pass) {
    loading.show('Chargement des transaction ...');
    String here = "${table['user']}/$codeUser/${table['transaction']}";
    base.selectList(here, (res) {
      List<Map> liste = [];
      for (var transaction in res) {
        liste.add(transaction);
      }
      loading.hide();
      pass(liste);
    }, haveLimit: true,
      limit: 50,
      haveOrder: true,
      order: 'dateTimes',
      desc: true);
  }

  // get list ALL transaction FOR admin
  getDemandeAll(Function pass) {
    loading.show('Chargement des demandes ...');
    base.selectListTransaction(table['demande']!, (res) {
      List<Map> liste = [];
      for (var transaction in res) {
        liste.add(transaction);
      }
      loading.hide();
      pass(liste);
    });
  }
}
