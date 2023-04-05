import 'package:amoi/component/appbar.dart';
import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/panel.dart';
import 'package:amoi/functions/boite.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';
import 'package:amoi/panels/aide.dart';
import 'package:amoi/panels/profile.dart';
import 'package:amoi/panels/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DASHBOARD extends StatefulWidget {
  const DASHBOARD({super.key});

  @override
  State<DASHBOARD> createState() => _DASHBOARDState();
}

class _DASHBOARDState extends State<DASHBOARD> {
  bool isConstruct = true;
  PANEL panel =
      PANEL(tabs: const [], panels: const [], onTabChange: (index) {});
  BUTTON btNewBoite = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btSearch = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btRefrech = BUTTON(text: '', action: () {}, type: 'ICON');

  BOITE newBoite = BOITE({});
  BOITE searchBoite = BOITE({});

  int vuAction = 0;
  INPUT montant = INPUT(label: 'Montant (en ariary)');
  INPUT search = INPUT(label: 'Code parenage');
  BUTTON btValider = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btAnnuler = BUTTON(text: '', action: () {}, type: 'ICON');
  BUTTON btPast = BUTTON(text: '', action: () {}, type: 'ICON');

  List<Widget> vuBoites = [];
  List<Widget> vuTiket = [];

  reloadBoite(BuildContext context) {
    loading.show("Chargement des boites ...");
    base.select_Boite((boites) {
      List<BOITE> listB = [];

      for (var map in boites) {
        BOITE b = BOITE(map);
        b.redraw = () {
          setState(() => vuAction = 0);
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

  // -----------------------------------SELECT TICKET
  reloadTicket() {
    loading.show("Chargement des récus ...");

    base.select_Tickets((tickets) {
      setState(() => vuTiket = []);
      for (var ticket in tickets) {
        setState(() {
          vuTiket.add(Card(
              elevation: 8,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LABEL(text: 'AMOI', size: 25, isBold: true),
                            const SizedBox(height: 10),
                            LABEL(
                                text: "Réçu de : ${ticket['date']}",
                                color: Colors.grey),
                            LABEL(
                                text:
                                    "Raison : Sortant de la boite (${ticket['informations']['code boite']})",
                                color: Colors.grey),
                            const SizedBox(height: 10),
                            LABEL(
                                text:
                                    "Montant investi: ${ticket['informations']['montant']} ariary"),
                            DataTable(
                                dataRowHeight: 25,
                                horizontalMargin: 0,
                                columnSpacing: 20,
                                checkboxHorizontalMargin: 0,
                                columns: <DataColumn>[
                                  DataColumn(
                                      label: Expanded(
                                          child: LABEL(
                                              text: 'Description',
                                              isBold: true))),
                                  DataColumn(
                                      label: Expanded(
                                          child: LABEL(
                                              text: 'Prix', isBold: true))),
                                  DataColumn(
                                      label: Expanded(
                                          child: LABEL(
                                              text: 'Qté', isBold: true))),
                                  DataColumn(
                                      label: Expanded(
                                          child: LABEL(
                                              text: 'Montant', isBold: true)))
                                ],
                                rows: <DataRow>[
                                  DataRow(cells: <DataCell>[
                                    DataCell(LABEL(text: 'Côte child')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['cote child']}%')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['nb child']}')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['cote child'] * ticket['informations']['nb child']}%'))
                                  ]),
                                  DataRow(cells: <DataCell>[
                                    DataCell(LABEL(text: 'Côte etage')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['cote etage']}%')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['etage'] - 1}')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['cote etage'] * (ticket['informations']['etage'] - 1)}%'))
                                  ]),
                                  DataRow(cells: <DataCell>[
                                    DataCell(LABEL(text: 'Bonus sortant')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['bonus']}%')),
                                    DataCell(LABEL(text: '1')),
                                    DataCell(LABEL(
                                        text:
                                            '${ticket['informations']['bonus']}%'))
                                  ]),
                                ]),
                            const SizedBox(height: 10),
                            LABEL(
                                text:
                                    "Sub. Totale : ${ticket['informations']['cote child'] * ticket['informations']['nb child'] + ticket['informations']['cote etage'] * (ticket['informations']['etage'] - 1) + ticket['informations']['bonus']}%"),
                            LABEL(
                                text:
                                    "Frais de Sécu. : ${ticket['informations']['frais secu']}%"),
                            LABEL(
                                isBold: true,
                                text:
                                    "Grand totale : ${(ticket['informations']['cote child'] * ticket['informations']['nb child']) + (ticket['informations']['cote etage'] * (ticket['informations']['etage'] - 1)) + (ticket['informations']['bonus'] - ticket['informations']['frais secu'])}%"),
                            const SizedBox(height: 10),
                            LABEL(
                                size: 15,
                                text:
                                    "Net réçu : ${ticket['informations']['Net recu']} ariary"),
                          ])))));
        });
      }
      loading.hide();
    });
  }

  // -----------------------------------NEW BOITE
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
    List<String> searchers = search.getValue().split('-');
    setState(() {
      searchBoite.redraw = () {
        setState(() => vuAction = 0);
        reloadBoite(context);
      };
    });
    searchBoite.search(context, searchers, vuBoites.length);
  }

  paste() async {
    ClipboardData code;
    code = (await Clipboard.getData('text/plain'))!;
    search.setText(code.text.toString());
  }

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

    panel = PANEL(
        tabs: const [
          {'Dashboard': Icons.dashboard},
          {'Profile': Icons.photo_camera_front_sharp},
          {'Porte feuille': Icons.wallet},
          {'Mes tickets': Icons.receipt_rounded},
          {'Aide': Icons.help_center},
          {'Déconnecter': Icons.power_settings_new},
        ],
        panels: [
          //DASHBOARD
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: APPBAR(user: userActif),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    height: 1, width: double.maxFinite, color: Colors.black12),
                Expanded(
                  child: vuBoites.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              color: Colors.grey[300],
                              // width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(children: vuBoites),
                              )))
                      : Container(
                          color: Colors.grey[300],
                          child: Center(
                              child: LABEL(
                                  text: 'Aucune boite', color: Colors.black)),
                        ),
                ),
                // const SizedBox(height: 10),
                if (vuAction == 1) montant,
                if (vuAction == 2) search,
                Container(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            vuAction == 0 ? btNewBoite : btValider,
                            const SizedBox(width: 5),
                            vuAction == 0 ? btSearch : btAnnuler,
                            if (vuAction == 0 || vuAction == 2)
                              const SizedBox(width: 5),
                            if (vuAction == 0) btRefrech,
                            if (vuAction == 2) btPast,
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                  LABEL(
                                      text: 'Amoi Groupe', color: Colors.grey),
                                  LABEL(text: version, color: Colors.grey)
                                ]))
                          ]),
                    ),
                  ),
                )
              ]),

          // PROFILE
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            APPBAR(user: userActif),
                            const SizedBox(height: 10),
                            Container(
                                height: 1,
                                width: double.maxFinite,
                                color: Colors.black12),
                            const SizedBox(height: 10),
                            PANELPROFILE(
                                user: userActif, redraw: () => setState(() {}))
                          ])))),

          // WALLET
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    APPBAR(user: userActif),
                    const SizedBox(height: 10),
                    Container(
                        height: 1,
                        width: double.maxFinite,
                        color: Colors.black12),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: PANELWALLET(
                            user: userActif, redraw: () => setState(() {})),
                      ),
                    )
                  ])),

          // MES TOKEN
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    APPBAR(user: userActif),
                    const SizedBox(height: 10),
                    Container(
                        height: 1,
                        width: double.maxFinite,
                        color: Colors.black12),
                    const SizedBox(height: 10),
                    Expanded(
                        child: vuTiket.isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                    // width: MediaQuery.of(context).size.width,
                                    child: Row(children: vuTiket)))
                            : Center(
                                child: LABEL(
                                    text: 'Aucun ticket', color: Colors.grey)))
                  ])),

          // AIDE
          SingleChildScrollView(
              scrollDirection: Axis.vertical, child: MANUEL()),

          // DECONNXION
          const Text('Deconnexion ...')
        ],
        onTabChange: (index) {
          // reload liste boite
          if (index == 0) setState(() => reloadBoite(context));
          if (index == 0) setState(() => vuAction = 0);
          if (index == 3) setState(() => reloadTicket());
          if (index == 5) Navigator.of(context).pushNamed('SECONNECT');
        });

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushNamed('SECONNECT');
          return true;
        },
        child: SafeArea(child: Scaffold(body: panel)));
  }
}
