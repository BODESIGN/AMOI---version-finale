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
      if (kDebugMode) {
        print("ERROR : $error");
      }
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
  newDefies(Map defies, Function actionAfter) {
    firestore
        .collection(table['setting']!)
        .doc(table['admin']!)
        .update({
          "defies": FieldValue.arrayUnion([defies])
        })
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  // ----------------------- > UPDATE ADMIN
  void updateParent(String parent, String login, Function actionAfter) {
    firestore
        .collection(table['user']!)
        .doc(parent)
        .update({
          "childs-direct": FieldValue.arrayUnion([login])
        })
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
            "net-sortie":
                FieldValue.increment(-administrator['sold de ce mois']),
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
    int limit = 5,
    bool haveOrder = false,
    String order = 'dateTimes',
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
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("HERE 345 : ${error.toString()}");
          print(stackTrace.toString());
        }
        actionAfter([]);
      });
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
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("HERE 346 : ${error.toString()}");
        }
        actionAfter([]);
      });
    } else if (haveLimit == true && haveOrder == false) {
      // LIMITE
      firestore.collection(table).limit(limit).get().then((querySnapshot) {
        List<Map> liste = [];
        for (var result in querySnapshot.docs) {
          liste.add(result.data());
        }
        actionAfter(liste);
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("HERE 347 : ${error.toString()}");
        }
        actionAfter([]);
      });
    } else {
      // NO LIMIT - NO ORDER
      firestore.collection(table).get().then((querySnapshot) {
        List<Map> liste = [];
        for (var result in querySnapshot.docs) {
          liste.add(result.data());
        }
        actionAfter(liste);
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("HERE 348 : ${error.toString()}");
        }
        actionAfter([]);
      });
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

  // ----------------------- > SELECT USERS
  selectListUsers(Function actionAfter) {
    // LIMITE
    firestore
        .collection(table['user']!)
        .orderBy('dateCreate', descending: true)
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
  void select_Boite(Function actionAfter,
      {bool isIamNotIn = false, bool getAll = false}) {
    firestore.collection(table['boite']!).get().then((querySnapshot) {
      List<Map> boites = [];
      List<Map> boitesImNotIn = [];
      List<Map> boitesAll = [];
      for (var result in querySnapshot.docs) {
        boitesAll.add(result.data());
        if (checIamInBoite(result.data())) {
          boites.add(result.data());
        } else {
          boitesImNotIn.add(result.data());
        }
      }
      actionAfter(isIamNotIn
          ? boitesImNotIn
          : getAll
              ? boitesAll
              : boites);
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

  // ----------------------- > DEFIE NEW
  void newDefieForUser(String login, String defieCode, Function actionAfter) {
    firestore.collection(table['user']!).doc(login).update({
      "defie-actif": {
        'code': defieCode,
        'date-start': Timestamp.now(),
        'progression': ''
      }
    }).then((value) {
      firestore.collection(table['setting']!).doc(table['admin']!).update(
        {
          "defie-en-cours": FieldValue.arrayUnion([
            {
              'defieCode': defieCode,
              'debut': Timestamp.now(),
              'userCode': login
            }
          ])
        },
      ).then((value) {
        actionAfter('succes');
      }).catchError((error) {
        actionAfter('error');
      });
    }).catchError((error) {
      if (kDebugMode) {
        print("Erreur de la mis a jour de la fiche");
      }
      actionAfter('error');
    });
  }

  // ----------------------- > DEFIE NEW
  void defieEndAttribut(
    String login,
    int argent,
    int exp,
    String defieCode,
    Function actionAfter,
  ) {
    firestore.collection(table['user']!).doc(login).update(
      {
        "exp": FieldValue.increment(exp),
        "ariary": FieldValue.increment(argent)
      },
    ).then((value) {
      String code = "AMOI-TK${newCode(3)}-${newCode(5)}";
      firestore
          .collection("${table['user']}/$login/${table['ticket']}")
          .doc(code)
          .set({
            'dateTime': Timestamp.now(),
            'login': login,
            'code': code,
            'vu': false,
            'type': 'DEFI',
            'description': "Ticket d'un défi ($defieCode)",
            'informations': {'ariary': argent, 'exp': exp}
          })
          .then((value) => actionAfter('succes'))
          .catchError((error) => actionAfter('error'));
    }).catchError((error) {
      actionAfter('error');
    });
  }

  // ----------------------- > DEFIE NEW
  void removeDefieForUser(String login, List rest_defie, Function actionAfter) {
    firestore
        .collection(table['user']!)
        .doc(login)
        .update({"defie-actif": {}}).then((value) {
      firestore
          .collection(table['setting']!)
          .doc(table['admin']!)
          .update({"defie-en-cours": rest_defie}).then((value) {
        actionAfter('succes');
      }).catchError((error) {
        actionAfter('error');
      });
    }).catchError((error) {
      if (kDebugMode) {
        print("Erreur de la mis a jour de la fiche");
      }
      actionAfter('error');
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
    await firestore.collection(table['user']!).doc(login).update({
      "boites": FieldValue.arrayUnion([newBoiteCode])
    }).then((value) async {
      await firestore
          .collection(table['user']!)
          .doc(login)
          .update({
            "boites": FieldValue.arrayRemove([boiteCode])
          })
          .then((value) => toast.show("User : $login a jour !"))
          .catchError((error) => toast.show(error.toString()));
    }).catchError((error) => toast.show(error.toString()));
  }

  // ----------------------- > QUIT BOITE
  quitBoiteToSortant(String login, String boiteOld, int montant) async {
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
  quitBoiteToSortantParent(String login, int montant) async {
    await firestore.collection(table['user']!).doc(login).get().then(
      (DocumentSnapshot documentSnapshot) async {
        Map<String, Object?> user =
            documentSnapshot.data() as Map<String, Object?>;
        String parent = user['parent'] as String;
        int lvl = user['level'] as int;

        if (lvl < 2) return;
        if (parent == 'root') return;

        await firestore
            .collection(table['user']!)
            .doc(parent)
            .update({"ariary": FieldValue.increment(montant)})
            .then((value) => {toast.show("User Parent : $login a jour !")})
            .catchError((error) => {toast.show(error.toString())});
      },
    );
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
  sendTiquetSortant(String login, String boiteOld, int montant,
      Map<String, dynamic> infos) async {
    String code = "AMOI-TK${newCode(3)}-${newCode(5)}";
    await firestore
        .collection("${table['user']}/$login/${table['ticket']}")
        .doc(code)
        .set({
          'dateTime': Timestamp.now(),
          'login': login,
          'code': code,
          'vu': false,
          'type': 'SORTANT',
          'description':
              'Ticket de sortant de la boite : $boiteOld, Montant : $montant ajouté dans votre solde 💵',
          'informations': infos
        })
        .then((value) => {toast.show("User : $login a jour !")})
        .catchError((error) => {toast.show(error.toString())});
  }

  // ----------------------- > QUIT BOITE
  sendTiquetSortantParent(String login, String boiteOld, int montant,
      Map<String, dynamic> infos) async {
    await firestore
        .collection(table['user']!)
        .doc(login)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      Map<String, Object?> user =
          documentSnapshot.data() as Map<String, Object?>;
      String parent = user['parent'] as String;
      int lvl = user['level'] as int;

      if (lvl < 2) return;
      if (parent == 'root') return;

      String code = "AMOI-TK${newCode(3)}-${newCode(5)}";

      await firestore
          .collection("${table['user']}/$parent/${table['ticket']}")
          .doc(code)
          .set({
            'dateTime': Timestamp.now(),
            'login': parent,
            'code': code,
            'vu': false,
            'type': 'CHILD DIRECT',
            'description':
                'Ticket de child direct (login child : $login , boite : $boiteOld), Montant : $montant ajouté dans votre solde 💵',
            'informations': infos
          })
          .then((value) => {toast.show("User : $login a jour !")})
          .catchError((error) => {toast.show(error.toString())});
    });
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
  select_Tickets(String login, Function actionAfter) {
    firestore
        .collection("${table['user']}/$login/${table['ticket']}")
        .orderBy('dateTime')
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

  // ----------------------- > SELECT TO DO
  selectListTODO(String order, Function actionAfter) {
    String here = "${table['setting']}/${table['admin']}/${table['todo']}";
    firestore
        .collection(here)
        .orderBy(order, descending: false)
        .get()
        .then((querySnapshot) {
      List<Map<String, dynamic>> liste = [];
      for (var result in querySnapshot.docs) {
        liste.add(result.data());
      }
      actionAfter(liste);
    }).onError((error, stackTrace) => actionAfter([]));
  }

  // ----------------------- > new TO DO
  newTODO(String todoCode, Map<String, dynamic> todo) {
    loading.show("Ajout dans la base ...");
    String here = "${table['setting']}/${table['admin']}/${table['todo']}";
    firestore.collection(here).doc(todoCode).set(todo).then((value) {
      loading.hide();
      toast.show("Insertion éffectuée ✅");
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      loading.hide();
    });
  }

  // ----------------------- > DALETE TO DO
  deleteTODO(String todoCode) async {
    String here = "${table['setting']}/${table['admin']}/${table['todo']}";
    loading.show("Suppression en cours ...");
    await firestore.collection(here).doc(todoCode).delete().then((value) {
      loading.hide();
      toast.show("TODO Supprimée !");
    }).catchError((error) => loading.hide());
  }

  // ----------------------- > UPDATE TO DO
  updateChecTODO(String todoCode, bool statut) async {
    String here = "${table['setting']}/${table['admin']}/${table['todo']}";
    loading.show("Mise a jour ...");
    await firestore.collection(here).doc(todoCode).update(
        {'traiter': statut, 'dateTraiter': Timestamp.now()}).then((value) {
      loading.hide();
      toast.show("TODO mis a jour !");
    }).catchError((error) => loading.hide());
  }
}
