import 'package:flutter/material.dart';

class BUTTON extends StatefulWidget {
  BUTTON(
      {super.key,
      required this.text,
      this.size = 12,
      required this.action,
      this.type = 'NORMAL'});

  String text;
  String type = 'NORMAL';
  double size = 12;
  Function action;
  IconData icon = Icons.add;

  setText(String _text) {
    text = _text;
  }

  @override
  State<BUTTON> createState() => _BUTTONState();
}

class _BUTTONState extends State<BUTTON> {
  @override
  Widget build(BuildContext context) {
    return widget.type == 'TEXT'
        ? TextButton(
            onPressed: () {
              widget.action();
            },
            child: Text(widget.text, style: TextStyle(fontSize: widget.size)))
        : widget.type == 'ICON'
            ? SizedBox(
                height: 40,
                width: 40,
                child: Material(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    elevation: 2.0,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          widget.action();
                        },
                        child: Icon(widget.icon,
                            size: widget.size, color: Colors.white))))
            : widget.type == 'BLEU'
                ? ElevatedButton(
                    onPressed: () {
                      widget.action();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.blue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Text(widget.text,
                        style: TextStyle(
                            fontSize: widget.size, color: Colors.white)))
                : ElevatedButton(
                    onPressed: () {
                      widget.action();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Text(widget.text,
                        style: TextStyle(fontSize: widget.size)));
    ;
  }
}
