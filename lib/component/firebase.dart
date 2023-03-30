// ignore_for_file: non_constant_identifier_names

import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

// ===============================================================================

initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// ===============================================================================

class FIREBASE {
  FIREBASE();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // > SELECT
  Future<void> select(
    String table,
    String id,
    Function actionAfter,
  ) async {
    await firestore.collection(table).doc(id).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) actionAfter('succes', documentSnapshot);
        if (!documentSnapshot.exists) actionAfter('error', 'Not exist');
      },
    ).catchError((error) {
      actionAfter('error', error);
    });
  }

  // ----------------------- > INSERT
  insert(
    String table,
    String id,
    Map<String, dynamic> donner,
    Function actionAfter,
  ) {
    firestore
        .collection(table)
        .doc(id)
        .set(donner)
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      actionAfter('error', error);
    });
  }

  // ----------------------- > UPDATE FULLNAME
  update_fiche(
    String tableUser,
    String login,
    dynamic value,
    String column,
    Function actionAfter,
  ) {
    firestore
        .collection(tableUser)
        .doc(login)
        .update({column.toString(): value})
        .then((res) => {actionAfter('succes', res)})
        .catchError((error) => {actionAfter('error', error)});
  }

  void updateAriary(
    String tableUser,
    String login,
    int montant,
    Function actionAfter,
  ) {
    firestore
        .collection(tableUser)
        .doc(login)
        .update(
          {"ariary": FieldValue.increment(montant)},
        )
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  // ----------------------- > UPDATE CHIFFRE D'AFFAIRE APPLI
  void updateChiffreAffaire(
    String tableAdmin,
    String colAdmin,
    int montant,
    Function actionAfter,
  ) {
    firestore
        .collection(tableAdmin)
        .doc(colAdmin)
        .update(
          {"net-entre": FieldValue.increment(montant)},
        )
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  // ----------------------- > UPDATE ADMIN
  void updateTablePlein(String boiteCode, Function actionAfter) {
    firestore
        .collection(table['setting']!)
        .doc(table['admin'])
        .update({
          "boitesPlein": FieldValue.arrayUnion([boiteCode])
        })
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  // ----------------------- > UPDATE CHIFFRE D'AFFAIRE APPLI
  void updateChiffreAffaireRetrait(
    String tableAdmin,
    String colAdmin,
    int montant,
    Function actionAfter,
  ) {
    firestore
        .collection(tableAdmin)
        .doc(colAdmin)
        .update(
          {
            "net-sortie": FieldValue.increment(montant),
          },
        )
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  // ----------------------- > UPDATE CHIFFRE D'AFFAIRE APPLI
  updateChiffreSold(double montant) async {
    firestore
        .collection(table['setting']!)
        .doc(table['admin']!)
        .update(
          {
            "sold de ce mois": FieldValue.increment(montant),
          },
        )
        .then((value) => {toast.show("Sold du mois mis a jour !")})
        .catchError(
            (error) => {toast.show('Erreur de la mis a jour du sold de mois')});
  }

  // ----------------------- > UPDATE CHIFFRE D'AFFAIRE APPLI
  passerAuPeriodeSuivant() async {
    await firestore
        .collection(table['setting']!)
        .doc(table['admin']!)
        .update(
          {
            "sold de ce mois": 0,
            "sold des mois avant":
                FieldValue.arrayUnion([administrator['sold de ce mois']])
          },
        )
        .then((value) => {toast.show("Sold du mois mis a jour !")})
        .catchError(
            (error) => {toast.show('Erreur de la mis a jour du sold de mois')});
  }

  // ----------------------- > SELECT TRANSACTION
  void selectList(
    String table,
    Function actionAfter, {
    bool haveLimit = false,
    int limit = 3,
    bool haveOrder = false,
    String order = 'code',
    bool desc = false,
  }) {
    if (haveLimit == true && haveOrder == true) {
      // LIMITE
      firestore
          .collection(table)
          .orderBy(order, descending: desc)
          .limit(limit)
          .get()
          .then((querySnapshot) {
        List<Map> liste = [];
        for (var result in querySnapshot.docs) {
          liste.add(result.data());
        }
        actionAfter(liste);
      }).onError((error, stackTrace) => actionAfter([]));
    } else if (haveLimit == false && haveOrder == true) {
      // LIMITE
      firestore
          .collection(table)
          .orderBy(order, descending: desc)
          .get()
          .then((querySnapshot) {
        List<Map> liste = [];
        for (var result in querySnapshot.docs) {
          liste.add(result.data());
        }
        actionAfter(liste);
      }).onError((error, stackTrace) => actionAfter([]));
    } else if (haveLimit == true && haveOrder == false) {
      // LIMITE
      firestore.collection(table).limit(limit).get().then((querySnapshot) {
        List<Map> liste = [];
        for (var result in querySnapshot.docs) {
          liste.add(result.data());
        }
        actionAfter(liste);
      }).onError((error, stackTrace) => actionAfter([]));
    } else {
      // NO LIMIT - NO ORDER
      firestore.collection(table).get().then((querySnapshot) {
        List<Map> liste = [];
        for (var result in querySnapshot.docs) {
          liste.add(result.data());
        }
        actionAfter(liste);
      }).onError((error, stackTrace) => actionAfter([]));
    }
  }

  // ----------------------- > SELECT TRANSACTION
  void selectListTransaction(
    String table,
    Function actionAfter,
  ) {
    // LIMITE
    firestore
        .collection(table)
        .where("traiter", isEqualTo: false)
        .get()
        .then((querySnapshot) {
      List<Map> liste = [];
      for (var result in querySnapshot.docs) {
        liste.add(result.data());
      }
      actionAfter(liste);
    }).onError((error, stackTrace) => actionAfter([]));
  }

  // ----------------------- > SELECT BOITES - LIST
  void select_Boite(Function actionAfter, {bool isIamNotIn = false}) {
    firestore.collection(table['boite']!).get().then((querySnapshot) {
      List<Map> boites = [];
      List<Map> boitesImNotIn = [];
      for (var result in querySnapshot.docs) {
        if (checIamInBoite(result.data())) {
          boites.add(result.data());
        } else {
          boitesImNotIn.add(result.data());
        }
      }
      actionAfter(isIamNotIn ? boitesImNotIn : boites);
    }).onError((error, stackTrace) => actionAfter([]));
  }

  // ----------------------- > SELECT BOITES - LIST
  bool checkInCodePlein(Map<String, dynamic> boite) {
    bool i = false;
    administrator['boitesPlein'].forEach((element) {
      if (element.toString() == boite['code'].toString()) i = true;
    });
    return i;
  }

  void select_Boite_Plein(Function actionAfter) {
    firestore.collection(table['boite']!).get().then((querySnapshot) {
      List<Map> boites = [];
      for (var result in querySnapshot.docs) {
        if (checkInCodePlein(result.data())) {
          boites.add(result.data());
        }
      }
      actionAfter(boites);
    }).onError((error, stackTrace) => actionAfter([]));
  }

  // ----------------------- > SELECT BOITES - UNIQUE
  void select_Boite_Unique(
    String code,
    Function actionAfter,
  ) {
    firestore.collection(table['boite']!).doc(code).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) actionAfter('succes', documentSnapshot);
        if (!documentSnapshot.exists) actionAfter('error', 'Not exist');
      },
    ).catchError((error) {
      actionAfter('error', error);
    });
  }

  // ----------------------- > REJOINDRE BOITE
  void rejoindreBoite(
    String login,
    String boiteCode,
    String parent,
    int montant,
    Function actionAfter,
  ) {
    firestore.collection(table['user']!).doc(login).update(
      {
        "ariary": FieldValue.increment(-montant),
        "exp": FieldValue.increment(EXP().exp),
        "boites": FieldValue.arrayUnion([boiteCode])
      },
    ).then((value) {
      if (parent != '') {
        updateExp(parent, actionAfter);
      } else {
        actionAfter('succes');
      }
    }).catchError((error) {
      actionAfter('error');
    });
  }

  // ----------------------- > QUIT BOITE
  quitBoiteToNew(String login, String boiteCode, String newBoiteCode) async {
    await firestore
        .collection(table['user']!)
        .doc(login)
        .update({
          // "boites": FieldValue.arrayRemove([boiteCode]),
          "boites": FieldValue.arrayUnion([newBoiteCode])
        })
        .then((value) => {toast.show("User : $login a jour !")})
        .catchError((error) => {toast.show(error.toString())});
  }

  // ----------------------- > QUIT BOITE
  quitBoiteToSortant(String login, String boiteOld, double montant) async {
    await firestore
        .collection(table['user']!)
        .doc(login)
        .update({
          "boites": FieldValue.arrayRemove([boiteOld]),
          "ariary": FieldValue.increment(montant)
        })
        .then((value) => {toast.show("User : $login a jour !")})
        .catchError((error) => {toast.show(error.toString())});
  }

  // ----------------------- > QUIT BOITE
  updateExp(String login, Function actionAfter) {
    firestore
        .collection(table['user']!)
        .doc(login)
        .update({"exp": FieldValue.increment(EXP().exp)})
        .then((res) => {actionAfter('succes')})
        .catchError((error) => {actionAfter('error')});
  }

  // ----------------------- > QUIT BOITE
  sendTiquetSortant(String login, String boiteOld, double montant,
      Map<String, dynamic> infos) async {
    await firestore
        .collection("${table['user']}/$login/${table['ticket']}")
        .doc(getDateNow())
        .set({
          'dateTime': Timestamp.now(),
          'date': getDateNow(),
          'login': login,
          'code': "AMOI-TK${newCode()}-${newCode()}",
          'vu': false,
          'description':
              'Ticket de sortant de la boite : $boiteOld, Montant : $montant ajouté dans votre solde 💵',
          'informations': infos
        })
        .then((value) => {toast.show("User : $login a jour !")})
        .catchError((error) => {toast.show(error.toString())});
  }

  // ----------------------- > QUIT BOITE
  deleteBoite(String boiteCode) async {
    await firestore
        .collection(table['boite']!)
        .doc(boiteCode)
        .delete()
        .then((value) => {toast.show("Ancien boite supprimé !")})
        .catchError((error) => {toast.show(error.toString())});
  }

  // ----------------------- > QUIT BOITE
  createNewBoite(
    Map<String, dynamic> map,
    Map<String, dynamic> histo,
    String here,
  ) async {
    await firestore
        .collection(table['boite']!)
        .doc(map['code'])
        .set(map)
        .then((value) => {toast.show("Nouveau boite créer !")})
        .catchError((error) => {toast.show(error.toString())});
    await firestore
        .collection(here)
        .doc(histo['date'])
        .set(histo)
        .then((value) => {toast.show("Historique créer !")})
        .catchError((error) => {toast.show(error.toString())});
  }

  // ----------------------- > SELECT BOITES - LIST
  select_Tickets(Function actionAfter) {
    if (kDebugMode) {
      print("${table['user']}/${userActif['login']}/${table['ticket']}");
    }
    firestore
        .collection("${table['user']}/${userActif['login']}/${table['ticket']}")
        .get()
        .then((querySnapshot) {
      List<Map> tickets = [];
      for (var result in querySnapshot.docs) {
        tickets.add(result.data());
      }
      actionAfter(tickets);
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error : $error');
      }
      actionAfter([]);
    });
  }
}
