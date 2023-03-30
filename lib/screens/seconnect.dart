// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/functions/login.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SECONNECT extends StatefulWidget {
  const SECONNECT({super.key});

  @override
  State<SECONNECT> createState() => _SECONNECTState();
}

class _SECONNECTState extends State<SECONNECT> {
  LABEL title = LABEL(text: 'Bienvenue sur Amoi Groupe', size: 15);
  INPUT login = INPUT(label: 'Login');
  INPUT mdp = INPUT(label: 'Mot de passe', isMotDePasse: true);
  BUTTON conn = BUTTON(text: 'Se connecter', action: () {}, type: 'BLEU');
  BUTTON newc = BUTTON(text: 'Créer un compte', action: () {}, type: 'BLEU');
  BUTTON prev = BUTTON(text: 'Retour', action: () {});
  BUTTON next = BUTTON(text: 'Suivant', action: () {}, type: 'BLEU');
  final METHODE $ = METHODE();
  bool isConstruct = true;

  int etape = 1;
  bool isnew = false;
  _prev(BuildContext context) => setState(() => etape--);
  _next(BuildContext context) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    if (administrator['version'] == null) await _getAdmin();
    if ($.isVersionValide() == false) return;

    if (isnew) {
      // new compte
      switch (etape) {
        case 1:
          $.checUserExist(login.getValue(), () {
            setState(() => etape++);
          });
          break;
        case 2:
          $.setMdp1(mdp.getValue(), () {
            setState(() => etape++);
            setState(() => mdp.setText(''));
          });
          break;
        case 3:
          $.setMdp2(mdp.getValue(), () {
            $.createCompte(login.getValue(), mdp.getValue(), (user) {
              userActif = user;
              bool isAdmin = $.isAdmin(user['login']);
              Navigator.of(context).pushNamed(isAdmin ? 'ADMIN' : 'DASHBOARD');
            });
          });
          break;
      }
    } else {
      // se connect
      switch (etape) {
        case 1:
          $.selectCompte(login.getValue(), () {
            setState(() => etape++);
          });
          break;
        case 2:
          $.seconnect(mdp.getValue(), (user) {
            userActif = user;
            bool isAdmin = $.isAdmin(user['login']);
            Navigator.of(context).pushNamed(isAdmin ? 'ADMIN' : 'DASHBOARD');
          });
          break;
      }
    }
  }

  _conn(BuildContext context) {
    setState(() => isnew = false);
    _next(context);
  }

  _newc(BuildContext context) async {
    setState(() => isnew = true);
    _next(context);
  }

  _getAdmin() async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;
    // -- get ADMINISTRATOR
    base.select(table['setting']!, table['admin']!, (result, value) {
      administrator = value.data() as Map<String, Object?>;
      cote = administrator['cote'];
      bonusSortant = administrator['bonusSortant'];
    });
  }

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    setState(() {
      newc.action = () => _newc(context);
      conn.action = () => _conn(context);
      next.action = () => _next(context);
      prev.action = () => _prev(context);
    });
    if (isConstruct) {
      setState(() => isConstruct = false);
      // -- get ADMINISTRATOR
      _getAdmin();
    }

    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
                body: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          SizedBox(
                              width: double.maxFinite,
                              child: Row(children: [
                                Image.asset("assets/logo/logoblack.png",
                                    width: 30, height: 30),
                                const SizedBox(width: 5),
                                title
                              ])),
                          const SizedBox(height: 10),
                          etape == 1 ? login : mdp,
                          if (etape == 3)
                            SizedBox(
                                width: double.maxFinite,
                                child: LABEL(
                                    text:
                                        'Veuillez confirmer votre mot de passe')),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              etape == 1 ? newc : prev,
                              etape == 1 ? conn : next,
                            ],
                          ),
                        ]))))),
        onWillPop: () async {
          if (Platform.isAndroid) SystemNavigator.pop();
          if (Platform.isIOS) exit(0);
          return false;
        });
  }
}
