import 'package:amoi/component/button.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

class APROPOS extends StatefulWidget {
  const APROPOS({super.key});

  @override
  State<APROPOS> createState() => _APROPOSState();
}

class _APROPOSState extends State<APROPOS> {
  TextStyle h1 = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle p = const TextStyle(fontSize: 13);
  TextStyle pG = const TextStyle(fontSize: 13, color: Colors.grey);
  TextStyle pB = const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

  List<Widget> listContact = [];

  @override
  Widget build(BuildContext context) {
    listContact = [];
    administrator['contact'].forEach((key, value) {
      listContact.add(SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Icon(key == 'facebook'
                ? Icons.facebook
                : key == 'gmail'
                    ? Icons.mail
                    : key == 'whatsapp'
                        ? Icons.call
                        : Icons.message),
            const SizedBox(width: 10),
            BUTTON(
                text: value.toString(),
                action: () {
                  copieCodeToClip(value.toString());
                })
          ])));
    });

    return SingleChildScrollView(
        child: Column(children: [
      Image.asset("assets/pic2.png"),
      Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("☑️ Investissez sur chacune de votre action quotidienne 💲",
                style: p),
            Text("☑️ Devenir actionnaire 😯", style: p),
          ])),
      Image.asset("assets/pic1.png"),
      // Text("By", style: pG),
      const SizedBox(height: 30),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 40,
                width: 40,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset("assets/logo/logo-bo.png"),
                )),
            const SizedBox(width: 5),
            Text('BO STUDIO mg', style: pB)
          ])),
      // const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                "On est une équipe de jeunes entrepreneurs; le projet AMOI a été conçu & développé par notre équipe ✌️😊.",
                style: p),
            Text(
                "Nous sommes très ouverts aux suggestions, aux coopérations et aux commentaires 😊.",
                style: p)
          ])),
      const SizedBox(height: 10),
      Text("On reste joignable sur : ", style: pB),
      const SizedBox(height: 10),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: listContact),
      const SizedBox(height: 30)
    ]));
  }
}
