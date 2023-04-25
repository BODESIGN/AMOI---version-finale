import 'dart:io';

import 'package:amoi/component/panel.dart';
import 'package:amoi/main.dart';
import 'package:amoi/panels/aide.dart';
import 'package:amoi/panels/apropos.dart';
import 'package:amoi/panels/pane_boite.dart';
import 'package:amoi/panels/pane_hyerarchie.dart';
import 'package:amoi/panels/pane_ticket.dart';
import 'package:amoi/panels/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DASHBOARD extends StatefulWidget {
  const DASHBOARD({Key? key}) : super(key: key);

  @override
  State<DASHBOARD> createState() => _DASHBOARDState();
}

class _DASHBOARDState extends State<DASHBOARD> {
  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    List<Map> tab = [
      {
        'title': 'Accueil',
        'panel': PANELBOITE(user: userActif, redraw: () => setState(() {})),
        'icon': Icons.home
      },
      {
        'title': 'Profile',
        'panel': PANELPROFILE(user: userActif, redraw: () => setState(() {})),
        'icon': Icons.person
      },
      {
        'title': 'Mes tickets',
        'panel': PANELTICKET(user: userActif, redraw: () => setState(() {})),
        'icon': Icons.receipt_rounded
      },
      {'title': 'Mon réseau', 'panel': MYHYERARCHY(), 'icon': Icons.groups},
      {'title': 'A propos', 'panel': const APROPOS(), 'icon': Icons.help},
    ];

    return WillPopScope(
        onWillPop: () async {
          if (Platform.isAndroid) SystemNavigator.pop();
          if (Platform.isIOS) exit(0);
          return false;
        },
        child: SafeArea(child: PANEL(tab: tab)));
  }
}
