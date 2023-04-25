// ignore_for_file: must_be_immutable

import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ==================================================================================
// ==================================================================================
// ==================================================================================

class TICKET extends StatelessWidget {
  TICKET(
      {Key? key,
      required this.ticket,
      this.forAdmin = false,
      this.isLigne = false})
      : super(key: key);

  Map ticket;
  bool forAdmin = false;
  bool isLigne = false;

  Widget vuChildDirect(BuildContext context) {
    return isLigne
        ? InkWell(
            onTap: () {
              MODALE m = MODALE(context, '', '')
                ..type = 'CUSTOM'
                ..child = TICKET(ticket: ticket);
              m.show();
            },
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LABEL(
                                    text: "Sortant (👨‍👦)",
                                    isBold: true,
                                    size: 12),
                                LABEL(
                                    text: DateFormat('dd/MM/yyyy HH:mm')
                                        .format(ticket['dateTime'].toDate())
                                        .toString(),
                                    color: Colors.grey)
                              ]),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 3, color: Colors.orangeAccent))),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LABEL(
                                        text:
                                            "M.I : ${ticket['informations']['montant'].toString()} MGA",
                                        color: Colors.grey),
                                    LABEL(
                                        text:
                                            "+${ticket['informations']['Net recu'].toString()} MGA",
                                        isBold: true,
                                        color: Colors.green,
                                        size: 12)
                                  ]),
                            ),
                          )
                        ]))))
        : SingleChildScrollView(
            child: Card(
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
                              if (!forAdmin)
                                LABEL(text: 'AMOI', size: 25, isBold: true),
                              if (!forAdmin) const SizedBox(height: 10),
                              LABEL(
                                  text: "Code : ${ticket['code']}",
                                  color: Colors.grey),
                              LABEL(
                                  text:
                                      "Raison : réseau direct en sortant (Boite : ${ticket['informations']['code boite']})",
                                  color: Colors.grey),
                              const SizedBox(height: 10),
                              LABEL(
                                  text:
                                      "Montant investi: ${ticket['informations']['montant']} MGA"),
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
                                      DataCell(LABEL(text: 'Bonus')),
                                      DataCell(LABEL(
                                          text:
                                              '${ticket['informations']['cote']}%')),
                                      DataCell(LABEL(text: '1')),
                                      DataCell(LABEL(
                                          text:
                                              '${ticket['informations']['cote']}%'))
                                    ]),
                                  ]),
                              const SizedBox(height: 10),
                              LABEL(
                                  size: 15,
                                  text:
                                      "Net réçu : ${ticket['informations']['Net recu']} MGA"),
                            ])))),
          );
  }

  Widget vuTokenDefi(BuildContext context) {
    return isLigne
        ? InkWell(
            onTap: () {
              MODALE m = MODALE(context, '', '')
                ..type = 'CUSTOM'
                ..child = TICKET(ticket: ticket);
              m.show();
            },
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LABEL(text: "☑️  Défi", isBold: true, size: 12),
                                LABEL(
                                    text: DateFormat('dd/MM/yyyy HH:mm')
                                        .format(ticket['dateTime'].toDate())
                                        .toString(),
                                    color: Colors.grey)
                              ]),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 3, color: Colors.blue))),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LABEL(
                                        text:
                                            "+${ticket['informations']['ariary'].toString()} MGA",
                                        isBold: true,
                                        color: Colors.green,
                                        size: 12),
                                    LABEL(
                                        text:
                                            "+${ticket['informations']['exp'].toString()} exp",
                                        isBold: true,
                                        color: Colors.green,
                                        size: 12)
                                  ]),
                            ),
                          )
                        ]))))
        : SingleChildScrollView(
            child: Card(
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
                              if (!forAdmin)
                                LABEL(text: 'AMOI', size: 25, isBold: true),
                              if (!forAdmin) const SizedBox(height: 10),
                              LABEL(
                                  text: "Code : ${ticket['code']}",
                                  color: Colors.grey),
                              LABEL(
                                  text: "Raison : ${ticket['description']}",
                                  color: Colors.grey),
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
                                                text: 'Valeur', isBold: true)))
                                  ],
                                  rows: <DataRow>[
                                    DataRow(cells: <DataCell>[
                                      DataCell(LABEL(text: 'Argent')),
                                      DataCell(LABEL(
                                          text:
                                              '${ticket['informations']['ariary']} MGA'))
                                    ]),
                                    DataRow(cells: <DataCell>[
                                      DataCell(LABEL(text: 'Expérience')),
                                      DataCell(LABEL(
                                          text:
                                              '${ticket['informations']['exp']} exp'))
                                    ])
                                  ]),
                              const SizedBox(height: 10),
                              LABEL(
                                  size: 15,
                                  text:
                                      "Valeur réçu : ${ticket['informations']['ariary']} MGA + ${ticket['informations']['exp']} exp"),
                            ])))),
          );
  }

  Widget vuTokenSortant(BuildContext context) {
    return isLigne
        ? InkWell(
            onTap: () {
              MODALE m = MODALE(context, 'Vu boites', '')
                ..type = 'CUSTOM'
                ..child = TICKET(ticket: ticket);
              m.show();
            },
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LABEL(
                                    text: "Sortant (👤)",
                                    isBold: true,
                                    size: 12),
                                LABEL(
                                    text: DateFormat('dd/MM/yyyy HH:mm')
                                        .format(ticket['dateTime'].toDate())
                                        .toString(),
                                    color: Colors.grey)
                              ]),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 3,
                                        color: ticket['informations']
                                                    ['montant'] <
                                                ticket['informations']
                                                    ['Net recu']
                                            ? Colors.green
                                            : Colors.red))),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LABEL(
                                        text:
                                            "M.I : - ${ticket['informations']['montant']} MGA",
                                        color: Colors.grey),
                                    LABEL(
                                        text:
                                            "+${((ticket['informations']['cote child'] * ticket['informations']['nb child']) + (ticket['informations']['cote etage'] * 2) + ticket['informations']['bonus']) - 100} %",
                                        isBold: true,
                                        color: Colors.green,
                                        size: 12),
                                    LABEL(
                                        text:
                                            "-${ticket['informations']['frais secu']} %",
                                        isBold: true,
                                        color: Colors.red,
                                        size: 12),
                                    LABEL(
                                        text:
                                            "+${ticket['informations']['Net recu']} MGA",
                                        isBold: true,
                                        color: Colors.green,
                                        size: 12)
                                  ]),
                            ),
                          )
                        ]))))
        : SingleChildScrollView(
            child: Card(
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
                              if (!forAdmin)
                                LABEL(text: 'AMOI', size: 25, isBold: true),
                              if (!forAdmin) const SizedBox(height: 10),
                              LABEL(
                                  text: "Code : ${ticket['code']}",
                                  color: Colors.grey),
                              LABEL(
                                  text:
                                      "Raison : Sortant (Boite : ${ticket['informations']['code boite']})",
                                  color: Colors.grey),
                              const SizedBox(height: 10),
                              LABEL(
                                  text:
                                      "Montant investi: ${ticket['informations']['montant']} MGA"),
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
                                      "Grand Totale : ${ticket['informations']['cote child'] * ticket['informations']['nb child'] + ticket['informations']['cote etage'] * (ticket['informations']['etage'] - 1) + ticket['informations']['bonus']}%"),
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
                                      "Net réçu : ${ticket['informations']['Net recu']} MGA"),
                            ])))),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ticket['type'].toString() == 'CHILD DIRECT'
        ? vuChildDirect(context)
        : ticket['type'].toString() == 'DEFI'
            ? vuTokenDefi(context)
            : vuTokenSortant(context);
  }
}

// ==================================================================================
// ==================================================================================
// ==================================================================================

// ignore: must_be_immutable
class PANELTICKET extends StatefulWidget {
  PANELTICKET({Key? key, required this.user, required this.redraw})
      : super(key: key);

  Map<String, dynamic> user;
  Function redraw;

  @override
  State<PANELTICKET> createState() => _PANELTICKETState();
}

class _PANELTICKETState extends State<PANELTICKET> {
  bool isConstruct = true;
  List<Widget> vuTiket = [];

  // -----------------------------------SELECT TICKET
  reloadTicket() {
    loading.show("Chargement des reçus ...");

    base.select_Tickets(userActif['login'], (tickets) {
      setState(() => vuTiket = []);
      for (var ticket in tickets) {
        setState(() {
          vuTiket.add(TICKET(ticket: ticket, isLigne: true));
        });
      }
      loading.hide();
    });
  }

  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (isConstruct) {
      reloadTicket();
      setState(() => isConstruct = false);
    }

    return SizedBox(
        width: double.maxFinite,
        child: vuTiket.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: vuTiket))
            : Center(child: LABEL(text: 'Aucun ticket', color: Colors.grey)));
  }
}
