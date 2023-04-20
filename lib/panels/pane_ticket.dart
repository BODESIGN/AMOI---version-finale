// ignore_for_file: must_be_immutable

import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// ==================================================================================
// ==================================================================================
// ==================================================================================

class TICKET extends StatelessWidget {
  TICKET({Key? key, required this.ticket, this.forAdmin = false})
      : super(key: key);

  Map ticket;
  bool forAdmin = false;

  Widget vuChildDirect() {
    return SingleChildScrollView(
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
                            text: "Ticket de : ${ticket['date']}",
                            color: Colors.grey),
                        LABEL(
                            text:
                                "Raison : Child direct en sortant (Boite : ${ticket['informations']['code boite']})",
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
                                          text: 'Description', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          LABEL(text: 'Prix', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child: LABEL(text: 'Qté', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          LABEL(text: 'Montant', isBold: true)))
                            ],
                            rows: <DataRow>[
                              DataRow(cells: <DataCell>[
                                DataCell(LABEL(text: 'Bonus')),
                                DataCell(LABEL(
                                    text:
                                        '${ticket['informations']['cote']}%')),
                                DataCell(LABEL(text: '1')),
                                DataCell(LABEL(
                                    text: '${ticket['informations']['cote']}%'))
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

  Widget vuTokenDefi() {
    return SingleChildScrollView(
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
                            text: "Ticket de : ${ticket['date']}",
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
                                          text: 'Description', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          LABEL(text: 'Valeur', isBold: true)))
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

  Widget vuTokenSortant() {
    return SingleChildScrollView(
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
                            text: "Ticket de : ${ticket['date']}",
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
                                          text: 'Description', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          LABEL(text: 'Prix', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child: LABEL(text: 'Qté', isBold: true))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          LABEL(text: 'Montant', isBold: true)))
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
                                "Net réçu : ${ticket['informations']['Net recu']} MGA"),
                      ])))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ticket['type'].toString() == 'CHILD DIRECT'
        ? vuChildDirect()
        : ticket['type'].toString() == 'DEFI'
            ? vuTokenDefi()
            : vuTokenSortant();
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
    loading.show("Chargement des récus ...");

    base.select_Tickets(userActif['login'], (tickets) {
      setState(() => vuTiket = []);
      for (var ticket in tickets) {
        setState(() {
          vuTiket.add(Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
            child: TICKET(ticket: ticket),
          ));
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

    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: vuTiket.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                              // width: MediaQuery.of(context).size.width,
                              child: Row(children: vuTiket)))
                      : Center(
                          child:
                              LABEL(text: 'Aucun ticket', color: Colors.grey)))
            ]));
  }
}
