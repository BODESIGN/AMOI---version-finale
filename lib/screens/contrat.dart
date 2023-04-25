// ignore_for_file: must_be_immutable

import 'package:amoi/component/button.dart';
import 'package:amoi/component/label.dart';
import 'package:flutter/material.dart';

class CONTRAT extends StatefulWidget {
  CONTRAT({super.key, required this.login, required this.pass});

  String login;
  Function pass;

  /*

Contrat d'utilisation de l'argent sans obligation

Entre [Nom de l'utilisateur (Mon login)], et AMOI GROUPE, il est convenu ce qui suit :

J'accepte d'utiliser mon argent sans obligation de le rembourser.
J'accepte de ne pas tricher ni de tenter une forme de piratage sur l'application.
J'accepte tous les frais existants dans l'application liés à l'utilisation du service.

  */

  @override
  State<CONTRAT> createState() => _CONTRATState();
}

class _CONTRATState extends State<CONTRAT> {
  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LABEL(text: "Contrat d'utilisation", isBold: true, size: 16),
                LABEL(text: "---", size: 16),
                LABEL(
                    text: "Entre : AMOI et Moi ${widget.login} (mon login)",
                    isBold: true,
                    size: 14),
                LABEL(
                    text: "il est convenu ce qui suit :",
                    isBold: true,
                    size: 14),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LABEL(
                        text:
                            "_ J'accepte d'utiliser mon argent sans obligation.",
                        size: 14),
                    LABEL(
                        text: "_ J'accepte de ne pas tricher ni de tenter",
                        size: 14),
                    LABEL(
                        text: "  une forme de piratage sur l'application.",
                        size: 14),
                    LABEL(
                        text: "_ J'accepte tous les frais existants", size: 14),
                    LABEL(
                        text:
                            "  dans l'application liés à l'utilisation du service.",
                        size: 14),
                  ],
                ),
                const SizedBox(height: 10),
                BUTTON(
                    text: accept ? "✅ Contrat accepté" : "Oui, J'accepte",
                    action: () => setState(() => accept = !accept))
                  ..colorBg = accept ? Colors.green : Colors.black
                  ..color = accept ? Colors.white : Colors.white,
                LABEL(text: "---", size: 16),
                accept
                    ? BUTTON(
                        text: 'Créer mon compte',
                        action: () {
                          widget.pass();
                        })
                    : const Text('✍️')
              ],
            )));
  }
}
