import 'package:amoi/component/label.dart';
import 'package:amoi/component/nav.dart';
import 'package:amoi/main.dart';
import 'package:amoi/panels/aide.dart';
import 'package:amoi/panels/new_notif.dart';
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
      'Acceuil': {
        'GROUPE': '',
        'TITLE': 'Présentation',
        'ICON': Icons.home,
        'ON-CLICK': () {},
        'PANEL': const PANE_ACCEUIL(),
      },
      'Dashboard': {
        'GROUPE': {
          'Boites': {
            'GROUPE': '',
            'TITLE': 'Les boites',
            'ICON': Icons.folder_shared,
            'ON-CLICK': () {},
            'PANEL': PANELBOITE(user: userActif, redraw: () => setState(() {})),
          },
          'Defie': {
            'GROUPE': '',
            'TITLE': 'Les défies',
            'ICON': Icons.generating_tokens_rounded,
            'ON-CLICK': () {},
            'PANEL': Center(child: LABEL(text: 'Prochainement ... '))
          },
          'Mes tickets': {
            'GROUPE': '',
            'TITLE': 'Mes tickets',
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
            'TITLE': 'Mon profile',
            'ICON': Icons.person,
            'ON-CLICK': () {},
            'PANEL':
                PANELPROFILE(user: userActif, redraw: () => setState(() {}))
          },
          'Porte feuille': {
            'GROUPE': '',
            'TITLE': 'Mon porte feuille',
            'ICON': Icons.wallet,
            'ON-CLICK': () {},
            'PANEL': PANELWALLET(user: userActif, redraw: () => setState(() {}))
          },
          'Childs': {
            'GROUPE': '',
            'TITLE': 'Mes childs directs',
            'ICON': Icons.groups,
            'ON-CLICK': () {},
            'PANEL': MYHYERARCHY()
          }
        }
      },
      'Aide': {
        'GROUPE': '',
        'TITLE': 'Amoi Groupe',
        'ICON': Icons.help_center,
        'PANEL': MANUEL()
      },
      'Déconnecter': {
        'GROUPE': '',
        'TITLE': 'Good bye 😉',
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
              current: 'Notification',
              currentIsInGroupe: false,
              navActifGroupe: {
                'GROUPE': '',
                'ICON': Icons.notifications,
                'ON-CLICK': () {},
                'PANEL': Expanded(
                    child: Center(child: LABEL(text: 'Notification & Nes '))),
              }),
        )));
  }
}
