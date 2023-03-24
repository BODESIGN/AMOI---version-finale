import 'package:amoi/componantes/button.dart';
import 'package:amoi/componantes/input.dart';
import 'package:amoi/componantes/label.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

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

  BUTTON btCredit = BUTTON(text: 'Demander un crédit', action: () {});

  List<Widget> transactions = [];
  TRANSACTION $ = TRANSACTION();

  bool isConstruct = true;

  // ----------------------------------------------------------
  void _retirer() {
    if (mdp.getValue() != userActif['motdepasse']) toast.show('Mot de passe incorrect !');
    if (mdp.getValue() != userActif['motdepasse']) return;

    if (tel.getValue() == '') toast.show('Numéro obligatoire !');
    if (tel.getValue() == '') return;

    int m = 0;
    try {
      m = int.parse(montant.getValue());
    } catch (e) {
      toast.show('Veuillez verifier votre montant !');
      return;
    }
    
    if (m < 2000) toast.show('Montant trop bas');
    if (m < 2000) return;

    if (m > userActif['ariary']) toast.show("Votre sold n'est pas suffisant");
    if (m > userActif['ariary']) return;

    $.retrait(userActif['login'], tel.getValue(), m, () {
      toast.show('✅ Demande envoyée !');
      _getTransaction();
    });
  }

  // ----------------------------------------------------------
  void _depot() {
    if (tel2.getValue() == '') toast.show('Numéro obligatoire !');
    if (tel2.getValue() == '') return;

    int m = 0;
    try {
      m = int.parse(montant2.getValue());
    } catch (e) {
      toast.show('Veuillez verifier votre montant !');
      return;
    }

    if (m < 2000) toast.show('Montant trop bas');
    if (m < 2000) return;

    $.depot(userActif['login'], tel2.getValue(), m, () {
      toast.show('✅ Demande envoyée !');
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
      btCredit.action = widget.user['level'] < 3
          ? () => toast.show('Desolé, un crédit est disponible au niveau 3')
          : () => print('demande de credit');
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
          btCredit,
          const SizedBox(height: 20),
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
