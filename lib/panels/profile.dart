import 'dart:io';

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PANELPROFILE extends StatefulWidget {
  PANELPROFILE({super.key, required this.user, required this.redraw});

  Map<String, dynamic> user;
  Function redraw;

  @override
  State<PANELPROFILE> createState() => _PANELPROFILEState();
}

class _PANELPROFILEState extends State<PANELPROFILE> {
  INPUT fullname = INPUT(label: 'Nom prénom');
  BUTTON savename = BUTTON(text: 'Enregistrer', action: () {});
  BUTTON btUpdatePdp = BUTTON(text: '', type: 'ICON', size: 20, action: () {});

  INPUT mdp1 = INPUT(label: 'Nouveau mot de passe', isMotDePasse: true);
  INPUT mdp2 = INPUT(label: 'Nouveau mot de passe', isMotDePasse: true);
  INPUT mdp3 = INPUT(label: 'Ancien mot de passe', isMotDePasse: true);
  BUTTON savemdp = BUTTON(text: 'Enregistrer', action: () {});

  late MODALE modalChandePdp;

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
    loading.show('Téléversement de la photo');
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
      savename.action = () => _updateFullname();
      savemdp.action = () => _saveNewMdp();
      btUpdatePdp.icon = Icons.camera_alt;
      btUpdatePdp.action = () => _clickOnpdp();
    });

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [btUpdatePdp, const SizedBox(width: 10)]),
      const SizedBox(height: 10),
      const SizedBox(height: 10),
      LABEL(text: 'Modification Nom prénom', color: Colors.grey),
      fullname,
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [savename]),
      LABEL(text: 'Modification Mot de passe', color: Colors.grey),
      mdp3,
      const SizedBox(height: 5),
      mdp1,
      const SizedBox(height: 5),
      mdp2,
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [savemdp]),
    ]);
  }
}
