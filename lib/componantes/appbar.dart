import 'package:amoi/componantes/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class APPBAR extends StatefulWidget {
  APPBAR({super.key, required this.user});

  Map<String, dynamic> user;

  @override
  State<APPBAR> createState() => _APPBARState();
}

class _APPBARState extends State<APPBAR> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          SizedBox(
            height: 40,
            width: 40,
            child: pdp(widget.user['urlPdp'].toString(), () {}),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                LABEL(text: '${widget.user['ariary']}', size: 15, isBold: true),
                LABEL(text: ' ariary'),
                LABEL(text: ' (sold délivrable)', color: Colors.grey),
              ],
            ),
            LABEL(
                size: 15,
                text:
                    'Niv. ${widget.user['level']} / ${widget.user['fullname']}'),
            LABEL(text: '${widget.user['exp']} exp ', color: Colors.grey),
          ])
        ]));
  }
}
