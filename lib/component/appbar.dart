import 'package:amoi/component/label.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class APPBAR extends StatefulWidget {
  APPBAR({super.key, required this.user, this.isInInit = false});

  Map<String, dynamic> user;
  bool isInInit = false;

  @override
  State<APPBAR> createState() => _APPBARState();
}

class _APPBARState extends State<APPBAR> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.isInInit
            ? const EdgeInsets.all(0)
            : const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SizedBox(
            width: double.maxFinite,
            child: Card(
                surfaceTintColor: Colors.white,
                elevation: widget.isInInit ? 0 : 5,
                child: Padding(
                    padding: widget.isInInit
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(children: [
                                Image.asset("assets/logo/logowhite.png",
                                    width: 40, height: 40),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child:
                                      pdp(widget.user['urlPdp'].toString(), () {
                                    showProfile(context, widget.user);
                                  }),
                                ),
                                const SizedBox(width: 5)
                              ])),
                          const SizedBox(width: 10),
                          Expanded(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LABEL(
                                            text: '${widget.user['fullname']}',
                                            size: 18,
                                            isBold: true),
                                        if (!widget.isInInit)
                                          Row(children: [
                                            LABEL(
                                                text:
                                                    '${widget.user['ariary']}',
                                                size: 18,
                                                isBold: true),
                                            LABEL(text: 'ar', size: 18),
                                            LABEL(text: ' (sold délivrable)')
                                          ])
                                      ]))),
                          const SizedBox(width: 10),
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Stack(children: [
                                CircularProgressIndicator(
                                    value: (widget.user['exp']) /
                                        (EXP()
                                            .level[widget.user['level'] + 1])),
                                SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                        child: LABEL(
                                            text: '${widget.user['level']}',
                                            size: 13,
                                            isBold: true)))
                              ]))
                        ])))));
  }
}
