// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:amoi/component/appbar.dart';
import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/boitePlein.dart';
import 'package:amoi/functions/login.dart';
import 'package:amoi/main.dart';
import 'package:amoi/screens/contrat.dart';
import 'package:app_installer/app_installer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SECONNECT extends StatefulWidget {
  const SECONNECT({Key? key}) : super(key: key);

  @override
  State<SECONNECT> createState() => _SECONNECTState();
}

class _SECONNECTState extends State<SECONNECT> {
  INPUT login = INPUT(label: 'Login (Aucun espace)');
  INPUT parent = INPUT(label: 'Parent (login / Aucun espace)');
  INPUT mdp = INPUT(label: 'Mot de passe', isMotDePasse: true);
  BUTTON conn = BUTTON(text: 'Se connecter', action: () {});
  BUTTON newc = BUTTON(text: 'Créer un compte', action: () {});
  BUTTON prev = BUTTON(text: 'Retour', action: () {});
  BUTTON next = BUTTON(text: 'Suivant', action: () {});
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

    if (isnew) {
      // new compte
      switch (etape) {
        case 1:
          $.checUserExist(login.getValue(), () {
            setState(() => etape++);
            $.user = {
              'fullname': login.getValue(),
              'motdepasse': '',
              'parent': '',
              'login': login.getValue(),
              'ariary': 0,
              'exp': 0,
              'level': 1,
              'urlPdp': '',
              'dateCreate': Timestamp.now(),
              'boites': []
            };
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
            setState(() => etape++);
          });
          break;
        case 4:
          // ignore: use_build_context_synchronously
          MODALE m = MODALE(context, '', '')
            ..type = 'CUSTOM'
            ..child = CONTRAT(
                login: login.getValue(),
                pass: () {
                  $.createCompte(
                      login.getValue(), mdp.getValue(), parent.getValue(),
                      (user) {
                    userActif = user;
                    bool isAdmin = $.isAdmin(user['login']);
                    Navigator.of(context)
                        .pushNamed(isAdmin ? 'ADMIN' : 'DASHBOARD');
                  });
                });
          m.show();
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
    loading.show("Vérification de l'application ...");
    base.select(table['setting']!, table['admin']!, (result, value) async {
      administrator = value.data() as Map<String, Object?>;
      cote = administrator['cote'];
      bonusSortant = administrator['bonusSortant'];
      loading.hide();
      if (version == administrator['version']) return;
      if (!administrator['version-obli']) return;

      vuModalNewVersion = MODALE(context, '', '')
        ..type = 'PLEIN'
        ..child = modaleNewVersion(context);
      vuModalNewVersion.show();
    });
  }

  // _launchFile(BuildContext context, String filePath) async {
  //   final file = File(filePath);
  //   final contentUri = await getUriForFile(context, file);
  //   try {
  //     await launchUrl(contentUri);
  //   } on PlatformException catch (e) {}
  // }

  Future<Uri> getUriForFile(BuildContext context, File file) async {
    // final directory = await getExternalStorageDirectory();
    // final path = '${directory?.path}';
    // final newPath = '$path/${file.path.split('/').last}';
    // final newFile = await file.copy(newPath);
    final contentUri = Uri.parse(
        'content://${packageInfo?.packageName}.fileprovider/my_files/${file.path.split('/').last}');
    return contentUri;
  }

  _downloadLastVersion() async {
    loading.show("Téléchargement ...");
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child("version/app.apk");
    final Directory? directory = await getExternalStorageDirectory();
    final String filePath = '${directory?.path}/app.apk';
    final File file = File(filePath);

    final downloadTask = islandRef.writeToFile(file);

    downloadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          double percent =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          loading.showProgress(percent,
              "(${(percent * 100).round()}%) Téléchargement en cours ...");
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          loading.hide();
          try {
            AppInstaller.installApk(filePath);
          } catch (e) {
            if (kDebugMode) {
              // print(e);
            }
          }

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
    if (!status.isDenied) {
      status = await Permission.manageExternalStorage.status;
    }
    if (!status.isDenied) status = await Permission.mediaLibrary.status;
    if (!status.isDenied) {
      status = await Permission.requestInstallPackages.status;
    }

    if (status.isDenied) {
      // You can request multiple permissions at once.
      try {
        // Map<Permission, PermissionStatus> statuses =
        await [
          Permission.storage,
          Permission.accessMediaLocation,
          Permission.manageExternalStorage,
          Permission.mediaLibrary,
          Permission.requestInstallPackages,
        ].request();
        // ignore: empty_catches
      } catch (e) {}

      // print(" PERMIS : ${statuses[Permission.storage]}");
    }
  }

  @override
  build(BuildContext context) {
    setStatutBarTheme();
    toast.init(context);
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    setState(() {
      newc.action = () => _newc(context);
      conn.action = () => _conn(context);
      next.action = () => _next(context);
      prev.action = () => _prev(context);

      newc.color = Colors.white;
      newc.colorBg = Colors.black;
      conn.color = Colors.white;
      conn.colorBg = Colors.black;
      next.color = Colors.white;
      next.colorBg = Colors.black;
      prev.color = Colors.white;
      prev.colorBg = Colors.black;

      mdp.isMotDePasse = true;
      login.onChangeVal = () {
        login.getValue().runes.forEach((int rune) {
          var character = String.fromCharCode(rune);
          if (character == ' ') login.setText(login.getValue().trim());
        });
      };
    });
    if (isConstruct) {
      setState(() => isConstruct = false);
      // -- get ADMINISTRATOR
      _getAdmin();
    }

    return FutureBuilder(
      future: _checPermission(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return WillPopScope(
            child: SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              etape == 1
                                  ? SizedBox(
                                      width: double.maxFinite,
                                      child: Row(children: [
                                        Image.asset("assets/logo/logoblack.png",
                                            width: 40, height: 40),
                                        const SizedBox(width: 5),
                                        LABEL(
                                            text: 'Bienvenue sur Amoi Groupe',
                                            size: 15)
                                      ]))
                                  : isnew
                                      ? SizedBox(
                                          width: double.maxFinite,
                                          child: Row(children: [
                                            Image.asset(
                                                "assets/logo/logoblack.png",
                                                width: 40,
                                                height: 40),
                                            const SizedBox(width: 5),
                                            LABEL(
                                                text:
                                                    'Nouveau compte (login : ${$.user['login']})',
                                                size: 15)
                                          ]))
                                      : APPBAR(user: $.user, isInInit: true),
                              const SizedBox(height: 10),
                              etape == 1
                                  ? login
                                  : etape == 4
                                      ? parent
                                      : mdp,
                              if (etape == 3)
                                SizedBox(
                                    width: double.maxFinite,
                                    child: LABEL(
                                        text:
                                            'Veuillez confirmer votre mot de passe')),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
      },
    );
  }

  Widget modaleNewVersion(BuildContext context) {
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
                text: "Une nouvelle version de l'app est disponible",
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
                text: "voulez-vous le télécharger tout de suite ?",
                size: 14,
                isBold: true,
                color: Colors.white),
            LABEL(
                text: "(taille : ${administrator['version-size']})",
                size: 14,
                color: Colors.white60),
            const SizedBox(height: 10),
            BUTTON(
                text: 'Télécharger et Mettre à jour',
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
