// ignore_for_file: camel_case_types

import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class PANE_ACCEUIL extends StatefulWidget {
  const PANE_ACCEUIL({super.key});

  @override
  State<PANE_ACCEUIL> createState() => _PANE_ACCEUILState();
}

class _PANE_ACCEUILState extends State<PANE_ACCEUIL> {
  Color c1 = const Color.fromRGBO(224, 169, 175, 1);
  Color c2 = const Color.fromRGBO(108, 99, 255, 1);
  Color c3 = const Color.fromRGBO(0, 191, 166, 1);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                color: c1,
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset('assets/design/mobile_amoi.png',
                                width: 100, height: 100),
                          ),
                          const SizedBox(width: 25),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LABEL(
                                    text: 'BIENVENUE',
                                    size: 25,
                                    isBold: true,
                                    color: c1),
                                LABEL(text: 'sur Amoi Groupe 😉')
                              ])
                        ])),
                    Center(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Stack(children: [
                            Image.asset('assets/design/draw_frends.png',
                                width: 200, height: 200),
                            Positioned(
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LABEL(text: "Avoir", color: c2, isBold: true),
                                  LABEL(
                                      text: "beaucoup d'amie 🤝",
                                      isBold: true,
                                      color: c2),
                                  LABEL(
                                      text: "en vaut bien le coup !",
                                      isBold: true,
                                      color: c2),
                                ],
                              ),
                            )
                          ])),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: c3, borderRadius: BorderRadius.circular(10)),
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/design/draw_man.png',
                                  width: double.maxFinite),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Chacun de votre effort est récompensé 💵",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LABEL(text: '--', color: Colors.grey),
                          LABEL(text: 'Version $version', color: Colors.grey),
                          LABEL(
                              text: 'by Bô Studio MADAGASCAR',
                              color: Colors.grey),
                        ],
                      ),
                    )
                  ]))),
    );
  }
}
