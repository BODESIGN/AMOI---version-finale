// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:amoi/functions/exp.dart';
import 'package:amoi/main.dart';

class METHODE {
  String mdp1 = '';
  String tableUser = table['user']!;
  late Map<String, dynamic> user;

  // ---------------------------------------------------------------
  void checUserExist(String login, Function pass) {
    if (login == '') toast.show('Login obligatoire !');
    if (login == '') return;

    if (login == 'vide') toast.show('Login non valide !');
    if (login == 'vide') return;
    if (login == 'AMOI') toast.show('Login non valide !');
    if (login == 'AMOI') return;
    if (login == 'AMOI GROUPE') toast.show('Login non valide !');
    if (login == 'AMOI GROUPE') return;

    bool isAdmin = this.isAdmin(login);
    if (isAdmin) toast.show('Login déjà pris !');
    if (isAdmin) return;

    loading.show('Chec login ...');
    base.select(tableUser, login, (result, value) {
      if (result == 'error') loading.hide();
      if (result == 'error') pass();
      if (result == 'error') return;
      late Map<String, dynamic> user;
      user = value.data() as Map<String, Object?>;
      if (user['login'] == login) toast.show('Login déjà pris !');
      if (user['login'] == login) loading.hide();
      if (user['login'] == login) return;
      loading.hide();
      pass();
    });
  }

  // ---------------------------------------------------------------
  void setMdp1(String mdp, Function pass) {
    if (mdp == '') toast.show('Mot de passe obligatoire !');
    if (mdp == '') return;
    mdp1 = mdp;
    pass();
  }

  // ---------------------------------------------------------------
  void setMdp2(String mdp, Function pass) {
    if (mdp != mdp1) toast.show('Mot de passe incorrect !');
    if (mdp != mdp1) return;
    pass();
  }

  // ---------------------------------------------------------------
  void createCompte(String login, String mdp, Function pass) {
    loading.show('Chec login ...');
    user = {
      'fullname': login,
      'motdepasse': mdp,
      'login': login,
      'ariary': 0,
      'exp': 0,
      'level': 1,
      'urlPdp': '',
      'dateCreate': getDateNow(),
      'boites': []
    };
    base.insert(tableUser, login, user, (result, value) {
      if (result == 'error') toast.show('Une problème est survenue !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      loading.hide();
      pass(user);
    });
  }

  // ---------------------------------------------------------------
  void selectCompte(String login, Function pass) {
    if (login == '') toast.show('Login obligatoire');
    if (login == '') return;
    loading.show('Connexion ...');
    base.select(tableUser, login, (result, value) {
      if (result == 'error') toast.show('Compte inconnue !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;
      user = value.data() as Map<String, Object?>;

      // get & update LEVEL
      if (user['level'] < EXP().getLevelOf(user['exp'])) {
        user['level'] = EXP().getLevelOf(user['exp']);
        base.insert(tableUser, user['login'], user, (result, value) {
          if (user['login'] == login) loading.hide();
          if (user['login'] == login) pass();
        });
      } else {
        if (user['login'] == login) loading.hide();
        if (user['login'] == login) pass();
      }
    });
  }

  // ---------------------------------------------------------------
  void seconnect(String mdp, Function pass) {
    if (mdp == '') toast.show('Mot de passe obligatoire');
    if (mdp == '') return;
    if (mdp != user['motdepasse'].toString()) toast.show('Mot de passe incorrect');
    if (mdp != user['motdepasse'].toString()) return;
    pass(user);
  }

  // ---------------------------------------------------------------
  bool isAdmin(String userCode) {
    for (var code in administrator['admin']) {
      if (code.toString() == userCode) return true;
    }
    return false;
  }

  // ---------------------------------------------------------------
  bool isVersionValide() {
    if (administrator['version-obli'] == false) return true;
    return (administrator['version'] == version);
  }
}
