import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BUTTON extends StatefulWidget {
  BUTTON(
      {Key? key,
      required this.text,
      this.size = 13,
      required this.action,
      this.type = 'NORMAL'})
      : super(key: key);

  String text;
  String type = 'NORMAL';
  double size = 13;
  Function action;
  IconData icon = Icons.add;
  Color color = Colors.white;
  Color colorBg = Colors.black;

  setText(String text) {
    text = text;
  }

  @override
  State<BUTTON> createState() => _BUTTONState();
}

class _BUTTONState extends State<BUTTON> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == 'BLEU') {
      widget.color = Colors.white;
      widget.colorBg = Colors.black;
    }
    return widget.type == 'TEXT'
        ? TextButton(
            onPressed: () {
              widget.action();
            },
            child: Text(widget.text, style: TextStyle(fontSize: widget.size)))
        : widget.type == 'FILL'
            ? InkWell(
                onTap: () {
                  widget.action();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.colorBg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.1),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  width: double.maxFinite,
                  height: 40,
                  child: Center(
                    child: Text(widget.text,
                        style: TextStyle(
                            fontSize: widget.size,
                            color: widget.color,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
              )
            : widget.type == 'ICON'
                ? SizedBox(
                    height: 40,
                    width: 40,
                    child: Material(
                        color: widget.colorBg,
                        borderRadius: BorderRadius.circular(5),
                        elevation: 0,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              widget.action();
                            },
                            child: Icon(widget.icon,
                                size: widget.size, color: widget.color))))
                : ElevatedButton(
                    onPressed: () {
                      widget.action();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          // if (states.contains(MaterialState.pressed)) {
                          //   return Colors.green;
                          // }
                          return widget.colorBg;
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Text(widget.text,
                        style: TextStyle(
                            fontSize: widget.size, color: widget.color)));
  }
}
