import 'dart:math';

import 'package:amoi/component/label.dart';
import 'package:amoi/component/modale.dart';
import 'package:amoi/functions/exp.dart';
import 'package:amoi/screens/admin.dart';
import 'package:amoi/screens/admin_boite_all.dart';
import 'package:amoi/screens/admin_dashboard.dart';
import 'package:amoi/screens/admin_inversti.dart';
import 'package:amoi/screens/admin_todo.dart';
import 'package:amoi/screens/admin_users_all.dart';
import 'package:amoi/screens/admin_users_tree.dart';
import 'package:amoi/screens/dashboard.dart';
import 'package:amoi/screens/defie_vu.dart';
import 'package:amoi/screens/defies.dart';
import 'package:amoi/screens/seconnect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';

import 'component/connectivite.dart';
import 'component/firebase.dart';
import 'component/loading.dart';
import 'component/toast.dart';

LOADING loading = LOADING();
TOAST toast = TOAST();
CONNECTIVITE connectivite = CONNECTIVITE();
FIREBASE base = FIREBASE();

PackageInfo? packageInfo;
String version = '';

// ==================================================================
late Map<String, dynamic> userActif;
Map<String, dynamic> administrator = {};
bool keyboardVisible = false;

// ==================================================================
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo!.version.toString();
  await initFirebase();
  loading.setConfig();
  runApp(const MAIN());
}

class MAIN extends StatelessWidget {
  const MAIN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amoi Groupe',
        theme: ThemeData(
            useMaterial3: true,
            // textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
            // textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
            // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            textTheme:
                GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder()
            }),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white, selectedItemColor: Colors.blue),
            primaryColor: Colors.black),
        builder: EasyLoading.init(),
        initialRoute: 'SECONNECT',
        routes: {
          'SECONNECT': (context) => const SECONNECT(),
          'DASHBOARD': (context) => const DASHBOARD(),
          'ADMIN': (context) => const ADMIN(),
          'ADMIN_DASHBOARD': (context) => const AdminDashboard(),
          'ADMIN_ALL_USER': (context) => const SCREEN_ALL_USERS(),
          'ADMIN_ALL_BOITE': (context) => const SCREEN_ALL_BOITE(),
          'ADMIN_TODO': (context) => const SCREEN_TODO(),
          'ADMIN_ALL_TREE': (context) => const SCREEN_ALL_TREE(),
          'ADMIN_ALL_INVESTI': (context) => const SCREEN_ALL_INVEST(),
          'ADMIN_DEFIE': (context) => const SCREEN_DEFIES_ADMIN(),
          'ADMIN_DEFIE_TRAITER': (context) => const SCREEN_TRAITE_DEFIE(),
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
  'todo': 'TODO',
  'histoBoite': 'Historiques',
  'ticket': 'Tickets',
};

// ==================================================================
setStatutBarTheme() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white));
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
showProfile(BuildContext context, Map<String, dynamic> u) {
  MODALE m = MODALE(context, 'Vu boites', '')
    ..type = 'PROFILE'
    ..child = Stack(children: [
      SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: Colors.white))),
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: MediaQuery.of(context).size.width - 50,
          height: 100),
      Positioned(
          left: 20,
          top: 20,
          child: SizedBox(
              height: 60,
              width: 60,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(width: 1, color: Colors.black)),
                  child: pdp(u['urlPdp'].toString(), () {})))),
      Positioned(
          left: 100,
          top: 20,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LABEL(text: "${u['fullname']}", color: Colors.black, size: 17),
            LABEL(text: "#${u['login']}", isBold: true, color: Colors.black),
            LABEL(
                text:
                    "⭐ Niv : ${u['level']} (${EXP().privilege['Niv. ${u['level']}']['nom']})",
                color: Colors.black)
          ]))
    ]);
  m.show();
}

// ==================================================================
copieCodeToClip(String text) async {
  toast.show('Copie dans le papier presse effectuée');
  await Clipboard.setData(ClipboardData(text: text));
}

// ==================================================================
String newCode(int len) {
  var r = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

// ==================================================================
Widget pdp(String uri, Function clickOnpdp,
    [double iconSize = 20, String src = 'NETWORK']) {
  return (uri != '' && uri != 'null')
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
                            color: Colors.amber,
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
          child: Icon(Icons.person, color: Colors.white, size: iconSize));
}
