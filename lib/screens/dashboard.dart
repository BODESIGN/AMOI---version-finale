
import 'package:amoi/component/panel.dart';
import 'package:amoi/main.dart';
import 'package:amoi/panels/aide.dart';
import 'package:amoi/panels/pane_boite.dart';
import 'package:amoi/panels/pane_hyerarchie.dart';
import 'package:amoi/panels/pane_ticket.dart';
import 'package:amoi/panels/profile.dart';
import 'package:flutter/material.dart';

class DASHBOARD extends StatefulWidget {
  const DASHBOARD({super.key});

  @override
  State<DASHBOARD> createState() => _DASHBOARDState();
}

class _DASHBOARDState extends State<DASHBOARD> {
  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    
    List<Map> tab = [
      {
        'title': 'Acceuil',
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
      {
        'title': 'Mon réseau',
        'panel': MYHYERARCHY(),
        'icon': Icons.groups
      },
      {
        'title': 'Aide',
        'panel': MANUEL(),
        'icon': Icons.help
      },
    ];

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushNamed('SECONNECT');
          return true;
        },
        child: SafeArea(child: PANEL(tab: tab)));
  }
}
