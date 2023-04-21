import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/boite.dart';
import 'package:amoi/functions/crypto.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';
import 'package:amoi/screens/defies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PANELBOITE extends StatefulWidget {
  PANELBOITE({Key? key, required this.user, required this.redraw})
      : super(key: key);

  Map<String, dynamic> user;
  Function redraw;

  @override
  State<PANELBOITE> createState() => _PANELBOITEState();
}

class _PANELBOITEState extends State<PANELBOITE> {
  bool isConstruct = true;

  List<Widget> vuBoites = [];
  BUTTON btNewBoite = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btSearch = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btRefrech = BUTTON(text: '', action: () {}, type: 'ICON');
  int vuAction = 0;
  INPUT montant = INPUT(label: 'Montant (en MGA)',isNumber: true);
  INPUT search = INPUT(label: 'Code parenage');

  BUTTON btValider = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btAnnuler = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btPast = BUTTON(text: '', action: () {}, type: 'ICON');

  BOITE newBoite = BOITE({});
  BOITE searchBoite = BOITE({});

  List<Widget> vuDefies = [];
  bool haveDefieEnCours = false;

  // ----------------------------------------------------------
  reloadBoite(BuildContext context) {
    loading.show("Chargement des boites ...");
    base.select_Boite((boites) {
      List<BOITE> listB = [];

      for (var map in boites) {
        BOITE b = BOITE(map);
        b.redraw = () {
          setState(() => vuAction = 0);
          widget.redraw();
          reloadBoite(context);
        };
        b.getHistorique((histos) {
          b.histoList = [];
          for (var histo in histos) {
            b.histoList.add(histo);
          }
          listB.add(b);

          setState(() {
            vuBoites = [];
            for (var b in listB) {
              vuBoites.add(b.vu(context, isCarousel: true));
            }
          });

          loading.hide();
        });
      }

      if (!(boites.length > 0)) loading.hide();
    });
  }

  // ----------------------------------------------------------
  _newBoite(BuildContext context) {
    int m = 0;
    try {
      m = int.parse(montant.getValue());
    } catch (e) {
      toast.show("Veuillez verifier le montant");
      return;
    }

    if (m < 1000) toast.show("Montant minimum : 1.000 MGA");
    if (m < 1000) return;

    if (m > userActif['ariary']) toast.show("Votre sold est insuffisant");
    if (m > userActif['ariary']) return;

    if (!EXP().checPrivillege_NbBoiteMaxe(userActif['level'], vuBoites.length))
      // ignore: curly_braces_in_flow_control_structures
      toast.show(
          "Vous avez déjà attein le nombre maximum de votre boite en cours !");
    if (!EXP().checPrivillege_NbBoiteMaxe(userActif['level'], vuBoites.length))
      return;

    setState(() {
      newBoite.redraw = () {
        setState(() => vuAction = 0);
        widget.redraw();
        reloadBoite(context);
      };
      newBoite.initValueNew(m, userActif['login']);
      newBoite.initModaleNew(context);
    });
    loading.show("Chargement ...");
    Future.delayed(const Duration(milliseconds: 200), () {
      newBoite.vuModaleNew.show();
      loading.hide();
    });
  }

  // ----------------------------------- SEARCH BOITE
  _searchBoite(BuildContext context) {
    if (search.getValue() == '') return;
    String code = CRYPTO().deCrypte(search.getValue());
    List<String> searchers = code.split('-');
    setState(() {
      searchBoite.redraw = () {
        setState(() => vuAction = 0);
        widget.redraw();
        reloadBoite(context);
      };
    });
    searchBoite.search(context, searchers, vuBoites.length);
  }

  // ----------------------------------------------------------
  reloadDefie() {
    loading.show("Chargement ...");

    base.select(table['setting']!, table['admin']!, (result, value) {
      setState(() {
        administrator = value.data() as Map<String, Object?>;
        vuDefies = [];

        // -> INFO Gll
        for (var defie in administrator['defies']) {
          List<Widget> taches = [];
          for (var t in defie['Tache']) {
            taches.add(LABEL(text: "_ $t"));
          }
          //
          if (haveDefieEnCours == false) {
            haveDefieEnCours =
                userActif['defie-actif']['code'] == defie['code'];
          }
          //
          vuDefies.add(Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  if (haveDefieEnCours) {
                    toast.show("Vous avez déjà un défie en cours ...");
                    return;
                  }

                  MODALE m;
                  m = MODALE(context, '${defie['recomponse']} 🎁',
                      "Délai : ${defie['delai']}")
                    ..labelButton1 = 'Choisir'
                    ..action1 = () {
                      DEFIE().newDefieForUser(userActif['login'], defie['code'],
                          () {
                        Navigator.pop(context);
                        toast.showNotyf("Nouvelle défie lancée ...", 'SUCCES');
                        setState(() {
                          userActif["defie-actif"] = {
                            'code': defie['code'],
                            'date-start': Timestamp.now(),
                            'progression': ''
                          };
                        });
                        reloadDefie();
                      });
                    }
                    ..labelButton3 = 'Annuler'
                    ..action3 = () {
                      Navigator.pop(context);
                    }
                    ..hideBt2 = true;
                  m.show();
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userActif['defie-actif']['code'] ==
                                  defie['code'])
                                LABEL(
                                    text:
                                        'En cours ${userActif['defie-actif']['progression']} (${DateTime.now().difference(userActif['defie-actif']['date-start'].toDate())})',
                                    color: Colors.green),
                              if (userActif['defie-actif']['code'] ==
                                  defie['code'])
                                const SizedBox(height: 5),
                              LABEL(
                                  text: '${defie['recomponse']} 🎁',
                                  color: Colors.green,
                                  isBold: true),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  LABEL(text: '⏱️ Delai : ', isBold: true),
                                  LABEL(text: '${defie['delai']}'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              LABEL(text: '☑️ Tache : ', isBold: true),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: taches)
                            ]))),
              )));
        }
      });

      loading.hide();
    });
  }

  // ----------------------------------------------------------
  paste() async {
    ClipboardData code;
    code = (await Clipboard.getData('text/plain'))!;
    search.setText(code.text.toString());
  }

  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    setState(() {
      btNewBoite.icon = Icons.add;
      btNewBoite.colorBg = Colors.green;
      btNewBoite.action = () => setState(() => vuAction = 1);
      btSearch.icon = Icons.search;
      btSearch.colorBg = Colors.green;
      btSearch.action = () => setState(() => vuAction = 2);
      btRefrech.icon = Icons.refresh;
      btRefrech.colorBg = Colors.green;
      btRefrech.action = () => reloadBoite(context);
      btPast.icon = Icons.paste;
      btPast.colorBg = Colors.green;
      btPast.action = () => paste();
      btValider.icon = Icons.check;
      btValider.colorBg = Colors.green;
      btValider.action = () {
        if (vuAction == 1) _newBoite(context);
        if (vuAction == 2) _searchBoite(context);
      };
      btAnnuler.icon = Icons.close;
      btAnnuler.colorBg = Colors.red;
      btAnnuler.action = () => setState(() => vuAction = 0);
    });

    if (isConstruct) {
      reloadBoite(context);
      reloadDefie();
      setState(() => isConstruct = false);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                    mainAxisAlignment: vuBoites.isNotEmpty
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: LABEL(
                              text: 'Mes boites : ${vuBoites.length}',
                              color: Colors.black)),
                      if (vuAction == 2) btPast,
                      if (vuAction == 2) const SizedBox(width: 5),
                      vuAction == 0 ? btNewBoite : btValider,
                      const SizedBox(width: 5),
                      vuAction == 0 ? btSearch : btAnnuler,
                      if (vuAction == 0 || vuAction == 2)
                        const SizedBox(width: 5),
                      if (vuAction == 0) btRefrech
                    ])),

            // const SizedBox(height: 10),
            if (vuAction == 1)
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: montant),
            if (vuAction == 2)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: search,
              ),
            vuBoites.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                      child: Row(children: vuBoites),
                    ))
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(100),
                      child: LABEL(text: 'Aucune boite', color: Colors.black),
                    )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LABEL(
                      text:
                          'Défies : ${vuDefies.length} (${haveDefieEnCours ? 'En cours 1' : 'Aucune en cours'})',
                      color: Colors.black),
                  BUTTON(
                      text: '⚠️',
                      type: 'ICON',
                      action: () {
                        MODALE m = MODALE(context, 'Vu boites', '')
                          ..type = 'CUSTOM'
                          ..child = SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LABEL(
                                      text:
                                          "Vous pous choisir une défie a reléver dans la liste si-dessous 😊",
                                      isBold: true),
                                  LABEL(text: "Attention ⚠️ : "),
                                  LABEL(
                                      text:
                                          "   Vous ne pouvez pas changer de defie en cours, "),
                                  LABEL(
                                      text:
                                          "   il faut attendre que le delais de ceci soit finie ⏱️"),
                                  LABEL(text: "   pour choisir une nouvelle"),
                                ],
                              ),
                            ),
                          );
                        m.show();
                      })
                    ..icon = Icons.help_center
                    ..colorBg = Colors.green
                    ..size = 20
                ],
              ),
            ),
            vuDefies.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: vuDefies),
                    ))
                : Center(
                    child: LABEL(
                        text: 'Aucune défie disponible', color: Colors.black)),
          ]),
    );
  }
}
