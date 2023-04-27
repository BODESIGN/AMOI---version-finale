import 'dart:io';

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/functions/transaction.dart';
import 'package:amoi/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PANELPROFILE extends StatefulWidget {
  PANELPROFILE({Key? key, required this.user, required this.redraw})
      : super(key: key);

  Map<String, dynamic> user;
  Function redraw;

  @override
  State<PANELPROFILE> createState() => _PANELPROFILEState();
}

class _PANELPROFILEState extends State<PANELPROFILE> {
  INPUT fullname = INPUT(label: 'Nom prénom');
  INPUT contact = INPUT(label: 'Contact');

  INPUT mdp1 = INPUT(label: 'Nouveau mot de passe', isMotDePasse: true);
  INPUT mdp2 = INPUT(label: 'Nouveau mot de passe', isMotDePasse: true);
  INPUT mdp3 = INPUT(label: 'Ancien mot de passe', isMotDePasse: true);
  late MODALE modalChandePdp;

  INPUT montant = INPUT(label: 'Montant (Min : 2.000ar)', isNumber: true);
  INPUT mdp = INPUT(label: 'Mot de passe', isMotDePasse: true);
  INPUT tel = INPUT(label: 'Numéro mobile money');

  INPUT montant2 = INPUT(label: 'Montant (Min : 2.000ar)', isNumber: true);
  INPUT tel2 = INPUT(label: 'Numéro mobile money');

  List<DataRow> transactions = [];
  TRANSACTION $ = TRANSACTION();

  bool isConstruct = true;

  bool isShowModifName = false;
  bool isShowModifMdp = false;
  bool isShowRetrait = false;
  bool isShowDepot = false;

  Map<String, dynamic> userParent = {'urlPdp': '', 'fullname': ''};

  // ----------------------------------------------------------
  void _retirer() {
    if (mdp.getValue() != userActif['motdepasse']) {
      toast.show('Mot de passe incorrect !');
    }
    if (mdp.getValue() != userActif['motdepasse']) return;

    if (tel.getValue() == '') {
      toast.show('Numéro obligatoire !');
      return;
    }

    int m = 0;
    try {
      m = int.parse(montant.getValue());
    } catch (e) {
      toast.show('Veuillez vérifier votre montant !');
      return;
    }

    if (m < 2000) {
      toast.show('Montant trop bas');
      return;
    }

    if (m > userActif['ariary']) {
      toast.show("Votre solde n'est pas suffisante !");
      return;
    }

    $.retrait(userActif['login'], tel.getValue(), m, () {
      toast.showNotyf(
          "Demande envoyée ! L'argent sera envoyé après validation du responsable ",
          'SUCCES');
      _getTransaction();
    });
  }

  // ----------------------------------------------------------
  void _depot() {
    if (tel2.getValue() == '') {
      toast.show('Numéro obligatoire !');
      return;
    }

    int m = 0;
    try {
      m = int.parse(montant2.getValue());
    } catch (e) {
      toast.show('Veuillez vérifier le montant !');
      return;
    }

    if (m < 2000) {
      toast.show('Montant trop bas');
      return;
    }

    // - CHEC PRIVIL7GE
    if (!EXP()
        .checPrivillege_SoldMax(userActif['level'], userActif['ariary'])) {
      toast.show(
          'Votre solde délivrable a atteint son plafond, veuillez faire un retait ! ');
      return;
    }

    $.depot(userActif['login'], tel2.getValue(), m, () {
      toast.showNotyf(
          "Demande envoyée ! Le responsable va vous contacter après vérification",
          'SUCCES');
      _getTransaction();
    });
  }

  // ----------------------------------------------------------
  void _getTransaction() {
    $.getTransaction(userActif['login'], (liste) {
      setState(() => transactions = []);
      for (var t in liste) {
        transactions.add(DataRow(cells: <DataCell>[
          DataCell(Text(
              DateFormat('dd/MM/yyyy HH:mm')
                  .format(t['dateTimes'].toDate())
                  .toString(),
              style: const TextStyle(fontSize: 13))),
          DataCell(Text(t['description'], style: const TextStyle(fontSize: 13)))
        ]));
      }
    });
  }

  // ----------------------------------------------------------
  void _getParent() {
    loading.show("Chargement du parent ...");
    setState(() {
      userParent = {'urlPdp': '', 'fullname': ''};
    });

    base.select(table['user']!, userActif['parent'], (result, value) {
      if (result == 'error') {
        loading.hide();
        return;
      }
      setState(() {
        userParent = value.data() as Map<String, Object?>;
      });
      loading.hide();
    });
  }

  // ----------------------------------------------------------

  // --------------------------------------------------------------
  _saveNewMdp() {
    if (mdp3.getValue() != userActif['motdepasse']) {
      toast.show('Ancien mot de passe incorrect !');
    }
    if (mdp3.getValue() != userActif['motdepasse']) return;

    if (mdp1.getValue() == '') toast.show('Mot de passe Obligatoire');
    if (mdp1.getValue() == '') return;

    if (mdp1.getValue() != mdp2.getValue()) {
      toast.show('Nouveaux mot de passe non correspondant !');
    }
    if (mdp1.getValue() != mdp2.getValue()) return;

    setState(() {
      widget.user['motdepasse'] = mdp1.getValue();
      userActif['motdepasse'] = mdp1.getValue();
    });
    _update('motdepasse', mdp1.getValue());
  }

  // --------------------------------------------------------------
  _updateFullname() {
    if (fullname.getValue() == '') toast.show('Nom Obligatoire');
    if (fullname.getValue() == '') return;
    setState(() {
      widget.user['fullname'] = fullname.getValue();
      userActif['fullname'] = fullname.getValue();
    });
    _update('fullname', fullname.getValue());
  }

  // --------------------------------------------------------------
  _updateContact() {
    setState(() {
      widget.user['tel'] = contact.getValue();
      userActif['tel'] = contact.getValue();
    });
    _update('tel', contact.getValue());
  }

  // --------------------------------------------------------------
  _update(String column, String value) {
    widget.redraw();
    loading.show('Mise à jour ...');
    base.update_fiche(table['user']!, userActif['login'], value, column,
        (result, value) {
      toast.show(result == 'error'
          ? 'Erreur de Mise à jour'
          : 'Modification enrégistrée');
      loading.hide();
    });
  }

  // --------------------------------------------------------------
  _clickOnpdp() {
    modalChandePdp.show();
  }

  // ===========================================================
  late File imgFile;
  final imgPicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void openCamera() async {
    // ignore: deprecated_member_use
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
    });
    uploadProfileImage();
  }

  void openGallery() async {
    // ignore: deprecated_member_use
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    uploadProfileImage();
  }

  uploadProfileImage() async {
    loading.show('Téléversement');
    Reference reference =
        FirebaseStorage.instance.ref().child('Pdp/${userActif['login']}');
    UploadTask uploadTask = reference.putFile(imgFile);
    TaskSnapshot snapshot = await uploadTask;
    userActif['urlPdp'] = await snapshot.ref.getDownloadURL();

    // firebase
    base.insert(table['user']!, userActif['login'], userActif, (result, value) {
      loading.hide();
      toast.show('Mise à jour éffectuée !');
      widget.redraw();
    });
  }

  // ===============================================

  @override
  Widget build(BuildContext context) {
    if (isConstruct) {
      _getTransaction();
      _getParent();
      setState(() => isConstruct = false);
    }

    modalChandePdp = MODALE(
        context, "Modifier profile", "Mise à jour de la photo de profile")
      ..labelButton1 = 'Camera'
      ..icon1 = Icons.camera_alt
      ..action1 = () {
        modalChandePdp.hide();
        openCamera();
      }
      ..labelButton2 = 'Galerie'
      ..icon2 = Icons.folder_open
      ..action2 = () {
        modalChandePdp.hide();
        openGallery();
      }
      ..labelButton3 = 'Annuler'
      ..action3 = () {
        modalChandePdp.hide();
      };

    setState(() {
      fullname.setText(widget.user['fullname'].toString());
      if (widget.user['tel'] != null)
        contact.setText(widget.user['tel'].toString());
    });

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LABEL(
                        text: "Mon parent", size: 15, color: Colors.green),
                  ),
                  Row(children: [
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: pdp(userParent['urlPdp'].toString(), () {
                        showProfile(context, userParent);
                      }),
                    ),
                    const SizedBox(width: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LABEL(text: userParent['fullname'].toString()),
                          LABEL(
                              text:
                                  "Niv. ${userParent['level']} ${EXP().privilege['Niv. ${userParent['level'] ?? 1}']['nom']}")
                        ])
                  ]),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: LABEL(
                          text: "Pérsonnel", size: 15, color: Colors.green)),
                  BUTTON(
                      text: 'Mon profile',
                      type: 'FILL',
                      action: () => showProfile(context, userActif))
                    ..color = Colors.black
                    ..colorBg = Colors.white,
                  const SizedBox(height: 10),
                  BUTTON(
                      text: 'Changer ma photo',
                      type: 'FILL',
                      action: () => _clickOnpdp())
                    ..color = Colors.black
                    ..colorBg = Colors.white,
                  const SizedBox(height: 10),
                  if (!isShowModifName)
                    BUTTON(
                        text: 'Modifier Nom prénom / Contact',
                        type: 'FILL',
                        action: () =>
                            setState(() => isShowModifName = !isShowModifName))
                      ..color = Colors.black
                      ..colorBg = Colors.white,
                  if (isShowModifName)
                    LABEL(
                        text: 'Modification Nom prénom / Contact',
                        color: Colors.black87,
                        isBold: true),
                  if (isShowModifName) const SizedBox(height: 5),
                  if (isShowModifName)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Expanded(child: fullname),
                      const SizedBox(width: 5),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () => _updateFullname())
                        ..color = Colors.white
                        ..colorBg = Colors.green
                        ..icon = Icons.save,
                    ]),
                  if (isShowModifName) const SizedBox(height: 5),
                  if (isShowModifName)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Expanded(child: contact),
                      const SizedBox(width: 5),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () => setState(
                              () => isShowModifName = !isShowModifName))
                        ..color = Colors.white
                        ..colorBg = Colors.grey
                        ..icon = Icons.unfold_less,
                      const SizedBox(width: 5),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () => _updateContact())
                        ..color = Colors.white
                        ..colorBg = Colors.green
                        ..icon = Icons.save,
                    ]),
                  const SizedBox(height: 10),
                  if (!isShowModifMdp)
                    BUTTON(
                        text: 'Modifier mot de passe',
                        type: 'FILL',
                        action: () =>
                            setState(() => isShowModifMdp = !isShowModifMdp))
                      ..color = Colors.black
                      ..colorBg = Colors.white,
                  if (isShowModifMdp)
                    LABEL(
                        text: 'Modification Mot de passe',
                        color: Colors.black87,
                        isBold: true),
                  if (isShowModifMdp) const SizedBox(height: 5),
                  if (isShowModifMdp)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mdp1,
                          const SizedBox(height: 5),
                          mdp2,
                          const SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(child: mdp3),
                                const SizedBox(width: 5),
                                BUTTON(
                                    text: '',
                                    type: 'ICON',
                                    action: () => setState(
                                        () => isShowModifMdp = !isShowModifMdp))
                                  ..color = Colors.white
                                  ..colorBg = Colors.grey
                                  ..icon = Icons.unfold_less,
                                const SizedBox(width: 5),
                                BUTTON(
                                    text: '',
                                    type: 'ICON',
                                    action: () => _saveNewMdp())
                                  ..color = Colors.white
                                  ..colorBg = Colors.green
                                  ..icon = Icons.save,
                              ]),
                        ],
                      )),
                    ]),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LABEL(
                        text: "Porte feuille", size: 15, color: Colors.green),
                  ),
                  if (!isShowDepot)
                    BUTTON(
                        text: "Dépôt d'argent",
                        type: 'FILL',
                        action: () =>
                            setState(() => isShowDepot = !isShowDepot))
                      ..color = Colors.black
                      ..colorBg = Colors.white,
                  if (isShowDepot)
                    LABEL(text: "Effectuer un dépôt d'argent", isBold: true),
                  if (isShowDepot) const SizedBox(height: 5),
                  if (isShowDepot)
                    Row(
                      children: [
                        Expanded(child: tel2),
                        const SizedBox(width: 5),
                        BUTTON(
                            text: '',
                            type: 'ICON',
                            action: () =>
                                setState(() => tel2.setText(userActif['tel'])))
                          ..color = Colors.white
                          ..colorBg = Colors.grey
                          ..icon = Icons.quick_contacts_dialer,
                      ],
                    ),
                  if (isShowDepot) const SizedBox(height: 5),
                  if (isShowDepot)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Expanded(child: montant2),
                      const SizedBox(width: 5),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () =>
                              setState(() => isShowDepot = !isShowDepot))
                        ..color = Colors.white
                        ..colorBg = Colors.grey
                        ..icon = Icons.unfold_less,
                      const SizedBox(width: 5),
                      BUTTON(text: '', type: 'ICON', action: () => _depot())
                        ..color = Colors.white
                        ..colorBg = Colors.green
                        ..icon = Icons.send,
                    ]),
                  const SizedBox(height: 10),
                  if (!isShowRetrait)
                    BUTTON(
                        text: "Retrait d'argent",
                        type: 'FILL',
                        action: () =>
                            setState(() => isShowRetrait = !isShowRetrait))
                      ..color = Colors.black
                      ..colorBg = Colors.white,
                  if (isShowRetrait)
                    LABEL(text: "Effectuer un retrait d'argent", isBold: true),
                  if (isShowRetrait) const SizedBox(height: 5),
                  if (isShowRetrait) mdp,
                  if (isShowRetrait) const SizedBox(height: 5),
                  if (isShowRetrait)
                    Row(children: [
                      Expanded(child: tel),
                      const SizedBox(width: 5),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () =>
                              setState(() => tel.setText(userActif['tel'])))
                        ..color = Colors.white
                        ..colorBg = Colors.grey
                        ..icon = Icons.quick_contacts_dialer
                    ]),
                  if (isShowRetrait) const SizedBox(height: 5),
                  if (isShowRetrait)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Expanded(child: montant),
                      const SizedBox(width: 5),
                      BUTTON(
                          text: '',
                          type: 'ICON',
                          action: () =>
                              setState(() => isShowRetrait = !isShowRetrait))
                        ..color = Colors.white
                        ..colorBg = Colors.grey
                        ..icon = Icons.unfold_less,
                      const SizedBox(width: 5),
                      BUTTON(text: '', type: 'ICON', action: () => _retirer())
                        ..color = Colors.white
                        ..colorBg = Colors.green
                        ..icon = Icons.send,
                    ]),
                  DataTable(
                      dataRowHeight: 40,
                      horizontalMargin: 0,
                      columnSpacing: 20,
                      checkboxHorizontalMargin: 0,
                      columns: <DataColumn>[
                        DataColumn(
                            label: Expanded(
                                child:
                                    LABEL(text: 'Date', color: Colors.green))),
                        DataColumn(
                            label: Expanded(
                                child: LABEL(
                                    text: 'Transactions', color: Colors.green)))
                      ],
                      rows: transactions),
                  if (transactions.length < 5) const SizedBox(height: 100)
                ])));
  }
}
