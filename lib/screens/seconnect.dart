// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/functions/login.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class SECONNECT extends StatefulWidget {
  const SECONNECT({super.key});

  @override
  State<SECONNECT> createState() => _SECONNECTState();
}

class _SECONNECTState extends State<SECONNECT> {
  LABEL title = LABEL(text: 'Bienvenue sur Amoi Groupe', size: 15);
  INPUT login = INPUT(label: 'Login');
  INPUT mdp = INPUT(label: 'Mot de passe', isMotDePasse: true);
  BUTTON conn = BUTTON(text: 'Se connecter', action: () {}, type: 'BLEU');
  BUTTON newc = BUTTON(text: 'Créer un compte', action: () {}, type: 'BLEU');
  BUTTON prev = BUTTON(text: 'Retour', action: () {});
  BUTTON next = BUTTON(text: 'Suivant', action: () {}, type: 'BLEU');
  final METHODE $ = METHODE();
  bool isConstruct = true;
  late MODALE vuModalNewVersion;

  int etape = 1;
  bool isnew = false;
  _prev(BuildContext context) => setState(() => etape--);
  _next(BuildContext context) async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    if (administrator['version'] == null) await _getAdmin();
    if ($.isVersionValide() == false) return;

    if (isnew) {
      // new compte
      switch (etape) {
        case 1:
          $.checUserExist(login.getValue(), () {
            setState(() => etape++);
          });
          break;
        case 2:
          $.setMdp1(mdp.getValue(), () {
            setState(() => etape++);
            setState(() => mdp.setText(''));
          });
          break;
        case 3:
          $.setMdp2(mdp.getValue(), () {
            $.createCompte(login.getValue(), mdp.getValue(), (user) {
              userActif = user;
              bool isAdmin = $.isAdmin(user['login']);
              Navigator.of(context).pushNamed(isAdmin ? 'ADMIN' : 'DASHBOARD');
            });
          });
          break;
      }
    } else {
      // se connect
      switch (etape) {
        case 1:
          $.selectCompte(login.getValue(), () {
            setState(() => etape++);
          });
          break;
        case 2:
          $.seconnect(mdp.getValue(), (user) {
            userActif = user;
            bool isAdmin = $.isAdmin(user['login']);
            Navigator.of(context).pushNamed(isAdmin ? 'ADMIN' : 'DASHBOARD');
          });
          break;
      }
    }
  }

  _conn(BuildContext context) {
    setState(() => isnew = false);
    _next(context);
  }

  _newc(BuildContext context) async {
    setState(() => isnew = true);
    _next(context);
  }

  _getAdmin() async {
    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;
    // -- get ADMINISTRATOR
    loading.show("Verification de l'appliction ...");
    base.select(table['setting']!, table['admin']!, (result, value) {
      administrator = value.data() as Map<String, Object?>;
      cote = administrator['cote'];
      bonusSortant = administrator['bonusSortant'];
      loading.hide();

      // CHEC VERSION
      if (version == administrator['version']) return;
      if (!administrator['version-obli']) return;
      
      vuModalNewVersion = MODALE(context, 'Modale new version', '')
        ..type = 'PLEIN'
        ..child = modaleNewVersion(context);
      vuModalNewVersion.show();
    });
  }

  _downloadLastVersion() async {
    loading.show("Téléchargement ...");
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child("version/app.apk");
    String filePath = "/storage/emulated/0/Download/amoi.apk";
    final File file = File(filePath);

    final downloadTask = islandRef.writeToFile(file);

    downloadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          double percent =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          loading.showProgress(percent,
              "(${(percent * 100).round()}%) Téléchargement cours ...");
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          loading.hide();
          // TODO open directly APK
          // await File(filePath).readAsBytes();
          toast.show(
              "La dernière vesrion a été télécharger veuillez ovrire le fichier : amoi.apk dans votre dossier download");
          Navigator.pop(context);

          break;
        case TaskState.canceled:
          loading.hide();
          break;
        case TaskState.error:
          loading.hide();
          break;
      }
    });
  }

  _checPermission() async {
    var status = await Permission.storage.status;
    if (!status.isDenied) status = await Permission.accessMediaLocation.status;
    if (!status.isDenied) status = await Permission.manageExternalStorage.status;
    if (!status.isDenied) status = await Permission.mediaLibrary.status;
    if (!status.isDenied) status = await Permission.requestInstallPackages.status;

    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.accessMediaLocation,
        Permission.manageExternalStorage,
        Permission.mediaLibrary,
        Permission.requestInstallPackages,
      ].request();

      // print(" PERMIS : ${statuses[Permission.storage]}");
    }
  }

  @override
  void initState() {
    super.initState();
    // CHEC PERMISSION 
    _checPermission();
  }

  @override
  build(BuildContext context) {
    toast.init(context);
    setState(() {
      newc.action = () => _newc(context);
      conn.action = () => _conn(context);
      next.action = () => _next(context);
      prev.action = () => _prev(context);
    });
    if (isConstruct) {
      setState(() => isConstruct = false);
      // -- get ADMINISTRATOR
      _getAdmin();
    }

    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
                body: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          SizedBox(
                              width: double.maxFinite,
                              child: Row(children: [
                                Image.asset("assets/logo/logoblack.png",
                                    width: 30, height: 30),
                                const SizedBox(width: 5),
                                title
                              ])),
                          const SizedBox(height: 10),
                          etape == 1 ? login : mdp,
                          if (etape == 3)
                            SizedBox(
                                width: double.maxFinite,
                                child: LABEL(
                                    text:
                                        'Veuillez confirmer votre mot de passe')),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              etape == 1 ? newc : prev,
                              etape == 1 ? conn : next,
                            ],
                          )
                        ]))))),
        onWillPop: () async {
          if (Platform.isAndroid) SystemNavigator.pop();
          if (Platform.isIOS) exit(0);
          return false;
        });
  }

  Widget modaleNewVersion(BuildContext context)  {
    return Container(
        color: Colors.black87,
        height: double.maxFinite,
        width: double.maxFinite,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LABEL(
                text: "On a une nouvelle version de l'application",
                color: Colors.white,
                size: 18),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: Container(
                      color: Colors.white,
                      child: const Icon(Icons.phonelink_setup))),
            ),
            const SizedBox(height: 10),
            LABEL(
                text: "Voullez-vous le télécharger tout de suite ?",
                size: 14,
                isBold: true,
                color: Colors.white),
            LABEL(
                text: "(taille : ${administrator['version-size']})",
                size: 14,
                color: Colors.white60),
            const SizedBox(height: 10),
            BUTTON(
                text: 'TELECHARGER et Mettre a jour',
                type: 'BLEU',
                action: () => _downloadLastVersion()),
            BUTTON(
                text: 'QUITTER',
                action: () {
                  vuModalNewVersion.hide();
                  Platform.isIOS ? exit(0) : SystemNavigator.pop();
                }),
          ],
        )));
  }
}
