import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LABEL extends StatelessWidget {
  LABEL({
    Key? key,
    required this.text,
    this.size = 13,
    this.color = Colors.black,
    this.isBold = false,
  }) : super(key: key);

  String text;
  double size = 13;
  Color color = Colors.black;
  bool isBold = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
