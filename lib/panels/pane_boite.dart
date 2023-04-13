import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/functions/boite.dart';
import 'package:amoi/functions/crypto.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PANELBOITE extends StatefulWidget {
  PANELBOITE({super.key, required this.user, required this.redraw});

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
  INPUT montant = INPUT(label: 'Montant (en ariary)');
  INPUT search = INPUT(label: 'Code parenage');

  BUTTON btValider = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btAnnuler = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btPast = BUTTON(text: '', action: () {}, type: 'ICON');

  BOITE newBoite = BOITE({});
  BOITE searchBoite = BOITE({});

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
              vuBoites.add(b.vu(context));
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

    if (m < 1000) toast.show("Montant minimum : 1.000 ariary");
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
  paste() async {
    ClipboardData code;
    code = (await Clipboard.getData('text/plain'))!;
    search.setText(code.text.toString());
  }

  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    setState(() {
      btNewBoite.action = () => setState(() => vuAction = 1);
      btSearch.icon = Icons.search;
      btSearch.action = () => setState(() => vuAction = 2);
      btRefrech.icon = Icons.refresh;
      btRefrech.action = () => reloadBoite(context);
      btPast.icon = Icons.paste;
      btPast.action = () => paste();
      btValider.icon = Icons.check;
      btValider.action = () {
        if (vuAction == 1) _newBoite(context);
        if (vuAction == 2) _searchBoite(context);
      };
      btAnnuler.icon = Icons.close;
      btAnnuler.action = () => setState(() => vuAction = 0);
    });

    if (isConstruct) {
      reloadBoite(context);
      setState(() => isConstruct = false);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: vuBoites.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 0, 15),
                      child: Row(children: vuBoites),
                    ))
                : Center(
                    child: LABEL(text: 'Aucune boite', color: Colors.black)),
          ),
          // const SizedBox(height: 10),
          if (vuAction == 1)
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: montant),
          if (vuAction == 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: search,
            ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                      mainAxisAlignment: vuBoites.isNotEmpty
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.start,
                      children: [
                        vuAction == 0 ? btNewBoite : btValider,
                        const SizedBox(width: 5),
                        vuAction == 0 ? btSearch : btAnnuler,
                        if (vuAction == 0 || vuAction == 2)
                          const SizedBox(width: 5),
                        if (vuAction == 0) btRefrech,
                        if (vuAction == 2) btPast,
                        if (vuBoites.isNotEmpty)
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                LABEL(
                                    text: 'Nb. boite : ${vuBoites.length}',
                                    color: Colors.grey)
                              ]))
                      ])))
        ]);
  }
}
