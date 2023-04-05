import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PANELWALLET extends StatefulWidget {
  PANELWALLET({super.key, required this.user, required this.redraw});

  Map<String, dynamic> user;
  Function redraw; 

  @override
  State<PANELWALLET> createState() => _PANELWALLETState();
}

class _PANELWALLETState extends State<PANELWALLET> {
  INPUT montant = INPUT(label: 'Montant');
  INPUT mdp = INPUT(label: 'Mot de passe', isMotDePasse: true);
  INPUT tel = INPUT(label: 'Numéro mobile money');
  BUTTON btRetrait = BUTTON(text: 'Retirer', action: () {}, type: 'BLEU');

  INPUT montant2 = INPUT(label: 'Montant');
  INPUT tel2 = INPUT(label: 'Numéro mobile money');
  BUTTON btDepot = BUTTON(text: 'Déposer', action: () {}, type: 'BLEU');

  List<Widget> transactions = [];
  TRANSACTION $ = TRANSACTION();

  bool isConstruct = true;


  // ----------------------------------------------------------
  void _retirer() {
    if (mdp.getValue() != userActif['motdepasse']) {
      toast.show('Mot de passe incorrect !');
    }
    if (mdp.getValue() != userActif['motdepasse']) return;

    if (tel.getValue() == '') {
      toast.show('Numéro obligatoire !');
      return;
    }

    int m = 0;
    try {
      m = int.parse(montant.getValue());
    } catch (e) {
      toast.show('Veuillez verifier votre montant !');
      return;
    }

    if (m < 2000) {
      toast.show('Montant trop bas');
      return;
    }

    if (m > userActif['ariary']) {
      toast.show("Votre sold n'est pas suffisant");
    }

    $.retrait(userActif['login'], tel.getValue(), m, () {
      toast.showNotyf('Demande envoyée !', 'SUCCES');
      _getTransaction();
    });
  }

  // ----------------------------------------------------------
  void _depot() {
    if (tel2.getValue() == '') {
      toast.show('Numéro obligatoire !');
      return;
    }

    int m = 0;
    try {
      m = int.parse(montant2.getValue());
    } catch (e) {
      toast.show('Veuillez verifier votre montant !');
      return;
    }

    if (m < 2000) {
      toast.show('Montant trop bas');
      return;
    }

    // - CHEC PRIVIL7GE
    if (!EXP().checPrivillege_SoldMax(userActif['level'], userActif['ariary'])) {
      toast.show(
          'Votre sold délivrable a attein son plafond, veuillez faire une retaire ! ');
      return;
    }

    $.depot(userActif['login'], tel2.getValue(), m, () {
      toast.showNotyf('Demande envoyée !', 'SUCCES');
      _getTransaction();
    });
  }

  // ----------------------------------------------------------
  void _getTransaction() {
    $.getTransaction(userActif['login'], (liste) {
      setState(() => transactions = []);
      for (var t in liste) {
        transactions.add(SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_month, size: 15),
                    LABEL(text: t['date'])
                  ]),
                  LABEL(text: t['description']),
                ],
              ),
            )));
      }
    });
  }

  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    setState(() {
      btRetrait.action = () => _retirer();
      btDepot.action = () => _depot();
    });
    if (isConstruct) {
      _getTransaction();
      setState(() => isConstruct = false);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          LABEL(text: "Effécter un retrait d'argent"),
          tel,
          const SizedBox(height: 5),
          montant,
          const SizedBox(height: 5),
          mdp,
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [btRetrait]),
          const SizedBox(height: 10),
          LABEL(text: "Effécter un dépot d'argent"),
          tel2,
          const SizedBox(height: 5),
          montant2,
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [btDepot]),
          const SizedBox(height: 10),
          LABEL(text: "Historique des transaction"),
          Container(height: 1, width: double.maxFinite, color: Colors.black12),
          const SizedBox(height: 10),
          LABEL(text: 'Date / Action', color: Colors.grey, isBold: true),
          const SizedBox(height: 10),
          Container(height: 1, width: double.maxFinite, color: Colors.black12),
          const SizedBox(height: 10),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: transactions)
        ]);
  }
}
