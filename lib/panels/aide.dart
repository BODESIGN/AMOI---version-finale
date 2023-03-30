import 'package:amoi/component/button.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MANUEL extends StatelessWidget {
  MANUEL({super.key});

  TextStyle h1 = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle p = const TextStyle(fontSize: 13);
  TextStyle pG = const TextStyle(fontSize: 13, color: Colors.grey);
  TextStyle pB = const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    height: 30,
                    width: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset("assets/logo/logowhite.png"),
                    )),
                const SizedBox(width: 5),
                Text('AMOI GROUPE', style: h1)
              ])),
          const SizedBox(height: 10),
          // Text('HELP explain niv max > ACTIONNAIRE'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Text("Bienvenue sur l'application", style: p),
              Text(" AMOI ☺️ ", style: pB)
            ]),
          ),

          const SizedBox(height: 10),
          Text(
              "📱C'est une application de parrainage direct qui consiste à récompenser chaque personne de son effort dans un groupe (Boîte).",
              style: p),

          const SizedBox(height: 10),
          Text(
              "🚹 Chacun à son propre compte est a le pouvoir d'augmenter son plancher à travers des actions.",
              style: p),
          Text("(Exemple des actions : Boîte, revenue actionnaire, etc...)",
              style: p),

          const SizedBox(height: 10),
          Text('📦 Une Boîte', style: pB),
          Text(
              "C'est une page qui contient un groupe de gens, elle consiste à donner une puissance de parainnage au sortant.",
              style: p),
          Text("C'est une de la base de cette application.", style: p),
          Text(
              "Chaque boîte est composée par : des places qui sont éparpillées dans des étages.",
              style: p),
          const SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  color: Colors.black12,
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset("assets/pic1.jpg"),
                  ))),
          const SizedBox(height: 10),
          Text('📈 Les etages', style: pB),
          Text(
              "Elle porte chacun un numéro de 1 vers la hauteur de la boîte, comme dans l'image ci-dessus.",
              style: p),
          Text(
              "Chaque étage possède au mois 2 places et se multiple par 2 vers le 1er étage",
              style: p),
          const SizedBox(height: 10),
          Text('⏺️ Les places', style: pB),
          Text(
              "Ce sont des points définis dans chaque étage, chaque place peut être occupée par une personne.",
              style: p),
          const SizedBox(height: 10),
          Text("Fonctionnement d'une Boîtes", style: pB),
          Text(
              "Une personne peut créer ou rejoindre une boîte, s'il possède assez de fond pour payer le montant d'investissement (MI) de la boîte.",
              style: p),
          Text(
              "Chaque personne qui rejoint une Boîte prend une place dans le 1er étage de la boîte.",
              style: p),
          Text(
              "Si les places dans le 1er étage sont pleines la personne entre et déclenchent la montée d'étage (Explication dans l'image ci-dessous)",
              style: p),
          const SizedBox(height: 10),
          Text("💵 Gagner de l'argent dans une Boîte.", style: pB),
          Text(
              "Chaque boîte comporte un montant d'investissement (IM) défini par la personne qui a créé la boîte, que chaque personne qui entre la boîte doit payer.",
              style: p),
          Text("Récompense par child : +$cote%  de MI."),
          Text("Récompense par étage : +$cote%  de MI."),
          Text(
              "Bonus : +$bonusSortant%  de MI. (si le sortant possède au moins 2 child)"),

          const SizedBox(height: 10),
          Text("👨‍👧‍👧 Child", style: pB),
          Text(
              "(exemple) votre child c'est une personne que vous avez invitée, est à rejoindre la Boîte ; une personne qui a rejoint la Boîte grâce à votre code de parrainage",
              style: p),

          const SizedBox(height: 10),
          Text("🔖 Le niveau (Niv.)", style: pB),
          Text(
              "C'est l'ensemble des expériences et des progressions qu'une personne a faites.",
              style: p),
          Text(
              "Les expériences sont gagnées graces à l'entrée dans une boîte et l'entrer d'un child dans une boîte.",
              style: p),

          const SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  color: Colors.black12,
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset("assets/pic2.jpg"),
                  ))),
          const SizedBox(height: 10),

          Text("〽️ Privilège de chaque niveau", style: pB),
          const SizedBox(height: 10),
          Text("Niv. 1 : Membre junior ", style: pB),
          Text(
              "Boîte maximum : 5, Montant maximum dans le portefeuille : 100.000 ariary.",
              style: p),
          Text("Niv. 2 : Membre sénior ", style: pB),
          Text(
              "Boîte maximum : 10, Montant maximum dans le portefeuille : 500.000 ariary.",
              style: p),
          Text("Niv. 3 : Collaborateur junior ", style: pB),
          Text(
              "Boîte maximum : illimité, Montant maximum dans le portefeuille : 500.000 ariary.",
              style: p),
          Text("Niv. 4 : Collaborateur sénior ", style: pB),
          Text(
              "Boîte maximum : illimité, Montant maximum dans le portefeuille : illimité.",
              style: p),
          Text("Niv. 5 : Pré-actionnaire ", style: pB),
          Text(
              "Boîte maximum : illimité, Montant maximum dans le portefeuille : illimité, revenue actionnaire : 1% du sold de l'application.",
              style: p),
          Text("Niv. 6 : Actionnaire junior", style: pB),
          Text(
              "Boîte maximum : illimité, Montant maximum dans le portefeuille : illimité, revenue actionnaire : 3% du sold de l'application.",
              style: p),
          Text("Niv. 7 : Actionnaire sénior", style: pB),
          Text(
              "Boîte maximum : illimité, Montant maximum dans le portefeuille : illimité, revenue actionnaire : 7% du sold de l'application.",
              style: p),

          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Text("À propos de nous", style: pG),
          const SizedBox(height: 10),

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
          const SizedBox(height: 10),
          Text(
              "On est une équipe de jeunes entrepreneurs; le projet AMOI a été conçu par notre équipe et cette application a été dévéloppé par notre équipe de développeurs avec notre propre moyen ✌️😊.",
              style: p),
          Text(
              "Nous sommes très ouverts aux suggestions, aux coopérations et aux commentaires 😊.",
              style: p),
          Text("On rest joignable sur : ", style: p),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                const Icon(Icons.mail),
                BUTTON(
                    text: "bodesign1998@gmail.com",
                    action: () {
                      copieCodeToClip("bodesign1998@gmail.com");
                    },
                    type: 'TEXT')
              ])),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                const Icon(Icons.whatsapp),
                BUTTON(
                    text: "+261344974196",
                    action: () {
                      copieCodeToClip("+261344974196");
                    },
                    type: 'TEXT')
              ])),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                const Icon(Icons.facebook),
                BUTTON(
                    text: "Bô design",
                    action: () {
                      // copieCodeToClip("https://www.facebook.com/bo.belle.32/");
                      copieCodeToClip("Bô design");
                    },
                    type: 'TEXT')
              ])),
        ],
      ),
    );
  }
}
