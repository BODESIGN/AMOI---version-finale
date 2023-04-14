// ignore_for_file: must_be_immutable

import 'package:amoi/component/appbar.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class NAVIGATION extends StatefulWidget {
  NAVIGATION(
      {super.key,
      required this.nav,
      required this.current,
      required this.currentIsInGroupe,
      required this.navActifGroupe});

  Map nav;
  String current;
  bool currentIsInGroupe;
  Map navActifGroupe;

  @override
  State<NAVIGATION> createState() => _NAVIGATIONState();
}

class _NAVIGATIONState extends State<NAVIGATION> {
  bool isConstruct = true;
  late Map navActif;
  bool isExpanded = false;
  String title = 'titre';
  String curr = '';

  List<Widget> tabsExpand = [];
  List<Widget> tabsNotExpand = [];

  late bool isVuInGroupe;
  late Map navActifGroupe;

  @override
  Widget build(BuildContext context) {
    if (isConstruct) {
      setState(() {
        isVuInGroupe = widget.currentIsInGroupe;
        navActifGroupe = widget.navActifGroupe;
        curr = widget.current;
        isConstruct = false;
      });
    }
    setState(() {
      navActif = isVuInGroupe ? navActifGroupe : widget.nav[curr];
      tabsExpand = [];
      tabsNotExpand = [];

      widget.nav.forEach((k, v) {
        Widget w = Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: InkWell(
                    onTap: (() {
                      setState(() => curr = k.toString());
                      setState(() => isVuInGroupe = false);
                      v['ON-CLICK']();
                    }),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(
                              color: k.toString() == curr
                                  ? Colors.amber
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(v['ICON'],
                                  color: k.toString() == curr
                                      ? Colors.black
                                      : Colors.white54))),
                      const SizedBox(width: 10),
                      LABEL(
                          text: k.toString(),
                          isBold: k.toString() == curr,
                          size: 13,
                          color: k.toString() == curr
                              ? Colors.white
                              : Colors.white54)
                    ]))));
        Widget w_notExpand = Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    onTap: (() {
                      setState(() => curr = k.toString());
                      setState(() => isVuInGroupe = false);
                      v['ON-CLICK']();
                    }),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(
                              color: k.toString() == curr
                                  ? Colors.amber
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(v['ICON'],
                                  color: k.toString() == curr
                                      ? Colors.black
                                      : Colors.white54)))
                    ]))));
        if (!(v['GROUPE'] == '')) {
          List<Widget> childs = [];
          bool isCurrent = false;

          v['GROUPE'].forEach((ck, cv) {
            if (!isCurrent) isCurrent = ck.toString() == curr;
            Widget cw = Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: InkWell(
                    onTap: (() {
                      setState(() => curr = ck.toString());
                      setState(() => isVuInGroupe = true);
                      setState(() => navActifGroupe = cv);
                      cv['ON-CLICK']();
                    }),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(
                              color: ck.toString() == curr
                                  ? Colors.amber
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(cv['ICON'],
                                  color: ck.toString() == curr
                                      ? Colors.black
                                      : Colors.white54))),
                      const SizedBox(width: 10),
                      LABEL(
                          text: ck.toString(),
                          isBold: ck.toString() == curr,
                          size: 13,
                          color: ck.toString() == curr
                              ? Colors.white
                              : Colors.white54)
                    ])));
            childs.add(cw);
          });

          List<Widget> childs_c = [];
          bool isCurrent_c = false;

          v['GROUPE'].forEach((ck, cv) {
            if (!isCurrent_c) isCurrent_c = ck.toString() == curr;
            Widget cw_c = Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    onTap: (() {
                      setState(() => curr = ck.toString());
                      setState(() => isVuInGroupe = true);
                      setState(() => navActifGroupe = cv);
                      cv['ON-CLICK']();
                    }),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(
                              color: ck.toString() == curr
                                  ? Colors.amber
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(cv['ICON'],
                                  color: ck.toString() == curr
                                      ? Colors.black
                                      : Colors.white54)))
                    ])));
            childs_c.add(cw_c);
          });

          // ==
          w = Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LABEL(
                            text: k.toString(),
                            isBold: isCurrent,
                            size: 13,
                            color: isCurrent ? Colors.white : Colors.white54),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: childs))
                      ])));
          w_notExpand = Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.20),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white.withOpacity(.20))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: childs_c));
        }
        tabsExpand.add(w);
        tabsNotExpand.add(w_notExpand);
      });
    });

    title = navActif['TITLE'];

    return Container(
        color: Colors.black,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          APPBAR(user: userActif),
          Expanded(
              child: Row(children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                // decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // header
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: isExpanded ? tabsExpand : tabsNotExpand),
                      )),

                      // footer
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                              padding: isExpanded
                                  ? const EdgeInsets.fromLTRB(15, 10, 15, 10)
                                  : const EdgeInsets.all(10),
                              child: InkWell(
                                  onTap: () =>
                                      setState(() => isExpanded = !isExpanded),
                                  child: Icon(
                                      isExpanded
                                          ? Icons.arrow_left_outlined
                                          : Icons.arrow_right_outlined,
                                      color: Colors.white))))
                    ])),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: LABEL(text: title, color: Colors.white, isBold: true),
                ),
                Expanded(
                  child: Card(
                      elevation: 10,
                      margin: const EdgeInsets.all(10),
                      surfaceTintColor: Colors.white,
                      child: Container(child: navActif['PANEL'])),
                ),
              ],
            ))
          ]))
        ]));
  }
}
