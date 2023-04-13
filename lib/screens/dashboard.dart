import 'package:amoi/component/nav.dart';
import 'package:amoi/main.dart';
import 'package:amoi/panels/aide.dart';
import 'package:amoi/panels/pane_boite.dart';
import 'package:amoi/panels/pane_hyerarchie.dart';
import 'package:amoi/panels/pane_ticket.dart';
import 'package:amoi/panels/profile.dart';
import 'package:amoi/panels/wallet.dart';
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

    Map nav = {
      'Dashboard': {
        'GROUPE': {
          'Boites': {
            'GROUPE': '',
            'ICON': Icons.folder_shared,
            'ON-CLICK': () {},
            'PANEL': PANELBOITE(user: userActif, redraw: () => setState(() {})),
          },
          'Mes tickets': {
            'GROUPE': '',
            'ICON': Icons.receipt_rounded,
            'ON-CLICK': () {},
            'PANEL': PANELTICKET(user: userActif, redraw: () => setState(() {}))
          },
        }
      },
      'Mes informations': {
        'GROUPE': {
          'Profile': {
            'GROUPE': '',
            'ICON': Icons.person,
            'ON-CLICK': () {},
            'PANEL':
                PANELPROFILE(user: userActif, redraw: () => setState(() {}))
          },
          'Porte feuille': {
            'NOM': 'Porte feuille',
            'GROUPE': '',
            'ICON': Icons.wallet,
            'ON-CLICK': () {},
            'PANEL': PANELWALLET(user: userActif, redraw: () => setState(() {}))
          },
          'Childs': {
            'GROUPE': '',
            'ICON': Icons.groups,
            'ON-CLICK': () {},
            'PANEL': Expanded(
                child: SizedBox(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [MYHYERARCHY()])))
          }
        }
      },
      'Aide': {'GROUPE': '', 'ICON': Icons.help_center, 'PANEL': MANUEL()},
      'Déconnecter': {
        'GROUPE': '',
        'ICON': Icons.power_settings_new,
        'ON-CLICK': () => Navigator.of(context).pushNamed('SECONNECT'),
        'PANEL': Center(
            child:
                Image.asset("assets/logo/logoblack.png", width: 30, height: 30))
      }
    };

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushNamed('SECONNECT');
          return true;
        },
        child: SafeArea(
            child: Scaffold(
          // body: panel,
          body: NAVIGATION(
              nav: nav,
              current: 'Boites',
              currentIsInGroupe: true,
              navActifGroupe: nav['Dashboard']['GROUPE']['Boites']),
        )));
  }
}
