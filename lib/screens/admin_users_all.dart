// ignore_for_file: camel_case_types

import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class SCREEN_ALL_USERS extends StatefulWidget {
  const SCREEN_ALL_USERS({Key? key}) : super(key: key);

  @override
  State<SCREEN_ALL_USERS> createState() => _SCREEN_ALL_USERSState();
}

class _SCREEN_ALL_USERSState extends State<SCREEN_ALL_USERS> {
  List<Widget> vuUsers = [];
  bool isConstruct = true;

  List<Widget> transactions = [];
  TRANSACTION $ = TRANSACTION();
  late MODALE vuTransaction;

// =====================================================
  void _getTransaction(user, Function pass) {
    loading.show("Chargemnt de la liste ...");
    $.getTransaction(user['login'], (liste) {
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
      loading.hide();
      pass();
    });
  }

// =====================================================
  Widget vu(Map user) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
                onTap: () {
                  // get Transaction
                  _getTransaction(user, () {
                    loading.show("Chargement ...");
                    setState(() {
                      vuTransaction = MODALE(context, 'Vu transaction', '')
                        ..type = 'CUSTOM'
                        ..child = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: transactions);
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      vuTransaction.show();
                      loading.hide();
                    });
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20)),
                                child: pdp(user['urlPdp'].toString(), () {})),
                          ),
                          const SizedBox(width: 10),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  LABEL(
                                      size: 15,
                                      text: '${user['fullname']} | ',
                                      isBold: true),
                                  LABEL(text: '${user['ariary']}'),
                                  LABEL(text: ' MGA')
                                ]),
                                Row(children: [
                                  LABEL(text: 'login : '),
                                  LABEL(text: '${user['login']}', isBold: true)
                                ]),
                                Row(children: [
                                  LABEL(text: 'mot de passe : '),
                                  LABEL(
                                      text: '${user['motdepasse']}',
                                      isBold: true)
                                ]),
                                LABEL(
                                    text:
                                        'Niv. ${user['level']} / ${user['exp']} exp / ${user['dateCreate']}',
                                    color: Colors.grey),
                                Row(children: [
                                  LABEL(text: 'parent : '),
                                  LABEL(text: '${user['parent']}', isBold: true)
                                ]),
                                LABEL(text: '-'),
                                LABEL(
                                    text:
                                        '(${user['boites'].length}) Boite en cours : '),
                                LABEL(text: '${user['boites']}'),
                              ])
                        ])))));
  }

  getList() {
    loading.show("Chargement de fiche ...");
    base.selectListUsers((list) {
      setState(() {
        vuUsers = [];
        for (var user in list) {
          vuUsers.add(vu(user));
        }
      });
      loading.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    if (isConstruct) {
      getList();
      setState(() {
        isConstruct = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Liste des utilisateurs (${vuUsers.length} 👤)'),
          titleTextStyle: const TextStyle(
              fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          foregroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: BUTTON(text: '', action: () => getList(), type: 'ICON')
                ..icon = Icons.refresh,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: vuUsers)),
        ));
  }
}
