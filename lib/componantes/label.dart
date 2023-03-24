import 'package:flutter/material.dart';

class LABEL extends StatelessWidget {
  LABEL({
    super.key,
    required this.text,
    this.size = 12,
    this.color = Colors.black,
    this.isBold = false,
  });

  String text;
  double size = 12;
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
