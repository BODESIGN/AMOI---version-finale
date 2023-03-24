import 'package:flutter/material.dart';

class MANUEL extends StatelessWidget {
  const MANUEL({super.key});

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
                const Text('AMOI GROUPE')
              ])),
          const SizedBox(height: 10),
          // Text('HELP explain niv max > ACTIONNAIRE'),
          Text("Bienvenue sur l'application AMOI ☺️ "),

          const SizedBox(height: 10),
          Text(
              "📱 L'application est une application de parinage direct, qui consiste a recomonssé chaque personne de son effort dans un goupe (Boite)."),

          const SizedBox(height: 10),
          Text(
              "🚹 Chaque utilisateur a son propre compte est a le pouvoir d'augementé son sold par grace aux actions."),
          Text("Les actions : Boite, Revenue actionnaire, etc..."),

          const SizedBox(height: 10),
          Text(
              "📦 Boite :  C'est une page qui contient une groupe de personne affins de donnée une pouvoir de parainnage au sortnat."),
          Text("C'est une de la base de cette application."),
          Text(
              "Chaque boite est composer par : des places qui sont éparpiée dans des etages "),
          const SizedBox(height: 10),
          Text("[Image 1]"),
          const SizedBox(height: 10),
          Text(
              "📈 Les etages porte chaqui un numéro de 1 vers la hauteur de la boite, comme dans l'image si-dessus. Chaque etage possède au mois 2 places (pour la dernière etage) et se multupli par 2 vers la 1er etage"),
          const SizedBox(height: 10),
          Text(
              "⏺️ Les places sont les points definnie dans chaque etage, chaque place peuve ètre occupé par une personne."),
          const SizedBox(height: 10),
          Text("Fonctionnement d'une boites "),
          Text(
              "Une personne peuvent créer ou rejoindre une boite, si il possède assez de fond pour payé le montant d'investisement (MI) de la boite ;"),
          Text(
              "Chaque personne qui rejoind une boite prend une place dans la 1er etage de la boite;"),
          Text(
              "Si les places dans la 1er etage sont plein la personne entre et declanche la monté d'etage (Explication dans l'image ci-dessous)"),
          const SizedBox(height: 10),
          Text("[Image 2 : new Boites > monté des personne]"),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Text("[Image 3 : boite plein > créer 2 boite]"),
          const SizedBox(height: 10),
          Text("💲 Ganger de l'argent dans une boite."),
          Text(
              "Chaque boite possède un montant d'investissement (MI) definie par celui qui a créer la boite, dont chaque personne qui entre dans la boite doit payer afaint de le multipliée en sorntant de la boite."),
          Text("Les Frais sont : "),
          Text("Frais d'inscription : -4% de MI (deduit au moment de l'entré)"),
          Text(
              "Entré d'un child : +55%  de MI par child (reçu au moment de l'entré de la child)"),
          Text(
              "Monté d'étage : +55% de MI /etage (reçu en dans la sorti en tant que sortant de la denière etage.)"),

          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Text("👨‍👧‍👧 Child"),
          Text(
              "C'est une personne qui est entré dans la boite grace a votre code de parainage, Une personne que vous avez inveté a rejoindre la boite."),

          const SizedBox(height: 10),
          Text("🔖 Le niveau (Niv.)"),
          Text(
              "Vous pouvez voir votre niveau a coté de votre nom dans l'entète de l'application."),

          const SizedBox(height: 10),
          Text("[Image 4 / img de la header est encadre le niveau]"),
          const SizedBox(height: 10),

          Text(
              "Le niveau augement grace a votre éxerience (exp), Vous pouvez gagner des experiences en entrant dans une boite, en sortant (en tant que sortant) en invitant des childs, etc..."),

          const SizedBox(height: 10),
          Text("Chaque niveau a sont privilège, Comme : "),
          Text("Niv. 1 : Membre junior "),
          Text(
              "   Boite maximum : 5, Monant  maximum dans la portefuille : 100.000 Ariary, Frais de retrait -5%."),
          Text("Niv. 2 : Membre senior "),
          Text(
              "   Boite maximum : 10, Monant maximum dans la portefuille : 500.000 Ariary, Frais de retrait -2%."),
          Text("Niv. 3 : Collaborateur junior "),
          Text(
              "   Boite maximum : illimité, Monant maximum dans la portefuille : 500.000 Ariary, Frais de retrait -1%."),
          Text("Niv. 4 : Collaborateur senio "),
          Text(
              "   Boite maximum : illimité, Monant maximum dans la portefuille : illimité, Frais de retrait -1%."),
          Text("Niv. 5 : pré-actionnaire "),
          Text(
              "   Boite maximum : illimité, Monant maximum dans la portefuille : illimité, Frais de retrait 0%."),
          Text("Niv. 6 : actionnaire junior "),
          Text(
              "   Revenue actionnaire : 10% de la valeur nèt de l'application divisé par le nombre des actionnaires."),
          Text("Niv. 7 : actionnaire senior "),
          Text(
              "   Revenue actionnaire : 17% de la valeur nèt de l'application divisé par le nombre des actionnaires."),

          const SizedBox(height: 10),
          const SizedBox(height: 10),
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
                const Text('BO STUDIO')
              ])),
          const SizedBox(height: 10),
          // Text('HELP explain niv max > ACTIONNAIRE'),
          Text("A propos de nous "),

          const SizedBox(height: 10),
          Text("Cette applicaiton a été dévéloppé par Bô Studio MG"),
          Text("Equipe des jeunes developpeur réalisatuer de tout type d'application web, mobile et autre ..."),
          Text("Vous pouvez nou cantacter si besoin sur bodesign1998@gmail.com on est overte tout proposition 😊😉"),
          Text("a améliore est a corriget , a ajouter plus de contacte , ECT...")
        ],
      ),
    );
  }
}
