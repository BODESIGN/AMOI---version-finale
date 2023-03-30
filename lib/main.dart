import 'dart:math';

import 'package:amoi/screens/admin.dart';
import 'package:amoi/screens/admin_dashboard.dart';
import 'package:amoi/screens/dashboard.dart';
import 'package:amoi/screens/seconnect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'component/connectivite.dart';
import 'component/firebase.dart';
import 'component/loading.dart';
import 'component/toast.dart';

LOADING loading = LOADING();
TOAST toast = TOAST();
CONNECTIVITE connectivite = CONNECTIVITE();
FIREBASE base = FIREBASE();

const String version = 'v1.0';

// ==================================================================
late Map<String, dynamic> userActif;
Map<String, dynamic> administrator = {'version': null};

// ==================================================================
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  loading.setConfig();
  runApp(const MAIN());
}

class MAIN extends StatelessWidget {
  const MAIN({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amoi Groupe',
        theme: ThemeData(
            useMaterial3: true,
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder()
            }),
            primaryColor: Colors.black),
        builder: EasyLoading.init(),
        initialRoute: 'SECONNECT',
        routes: {
          'SECONNECT': (context) => const SECONNECT(),
          'DASHBOARD': (context) => const DASHBOARD(),
          'ADMIN': (context) => const ADMIN(),
          'ADMIN_DASHBOARD': (context) => const AdminDashboard(),
        });
  }
}

// ==================================================================
Map<String, String> table = {
  'user': 'Users',
  'boite': 'Boites',
  'demande': 'Demande',
  'transaction': 'Transactions',
  'setting': 'Setting',
  'admin': 'Administrator',
  'histoMoney': 'Historiques-Money',
  'histoBoite': 'Historiques',
  'ticket': 'Tickets',
};

// ==================================================================
String getDateNow() {
  return DateFormat('dd-MM-yyyy H:m:s')
      .format(DateTime.now().toUtc().add(const Duration(hours: 3)))
      .toString();
}

// ==================================================================
bool checIamInBoite(Map<String, dynamic> boite) {
  bool iamIn = false;
  userActif['boites'].forEach((element) {
    if (element.toString() == boite['code'].toString()) iamIn = true;
  });
  return iamIn;
}

// ==================================================================
bool checParentIsInBoite(String parent, List inBoite) {
  bool isIn = false;
  for (var code in inBoite) {
    if (code.toString() == parent) isIn = true;
  }
  return isIn;
}

// ==================================================================
copieCodeToClip(String text) async {
  toast.show('Copie dans le papier presse effectuée');
  await Clipboard.setData(ClipboardData(text: text));
}

// ==================================================================
String newCode() {
  int len = 7;
  var r = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

// ==================================================================
Widget pdp(String uri, Function clickOnpdp,
    [double iconSize = 20, String src = 'NETWORK']) {
  return uri != ''
      ? src == 'NETWORK'
          ? ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: (() {
                    clickOnpdp();
                  }),
                  child: Image.network(uri, fit: BoxFit.cover, scale: 1.0,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null));
                  })))
          : Image.asset(uri, fit: BoxFit.cover, scale: 1.0)
      : InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (() {
            clickOnpdp();
          }),
          child: Icon(Icons.person, color: Colors.black, size: iconSize));
}
