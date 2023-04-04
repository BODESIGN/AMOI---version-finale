// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class INPUT extends StatefulWidget {
  INPUT({super.key, this.isMotDePasse = false, required this.label});

  String label;
  String text = '';
  bool isMotDePasse;
  TextEditingController controller = TextEditingController();

  String getValue() {
    return controller.text;
  }

  void setText(String text) {
    controller.text = text;
  }

  @override
  State<INPUT> createState() => _boInput();
}

class _boInput extends State<INPUT> {
  bool isObscur = true;
  InputBorder inputborder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(5));

  void onChangeVuMpd() {
    setState(() => isObscur = !isObscur);
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        obscureText: widget.isMotDePasse ? isObscur : false,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            isDense: true,
            hintText: widget.label,
            hintStyle: const TextStyle(fontWeight: FontWeight.normal),
            alignLabelWithHint: false,
            enabledBorder: inputborder,
            focusedBorder: inputborder,
            suffixIcon: widget.isMotDePasse
                ? InkWell(
                    onTap: () {
                      onChangeVuMpd();
                    },
                    child: isObscur
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off))
                : null));
  }
}
