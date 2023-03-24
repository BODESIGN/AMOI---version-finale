class EXP {
  Map level = {
    1: 0,
    2: 1000, // + 1500
    3: 2500, // + 2000
    4: 4500, // + 2500
    5: 7000, // + 3000
    6: 10000, // + 4000
    7: 15000 // + 5000
  };

  int exp = 75;


  int getLevelOf(int _exp) {
    int niv = 1;
    bool b = false;
    if (_exp < level[2]) {
      niv = 1;
      b = true;
    }
    if ((_exp < level[3]) && !b) {
      niv = 2;
      b = true;
    }
    if ((_exp < level[4]) && !b) {
      niv = 3;
      b = true;
    }
    if ((_exp < level[5]) && !b) {
      niv = 4;
      b = true;
    }
    if ((_exp < level[6]) && !b) {
      niv = 5;
      b = true;
    }
    if ((_exp < level[7]) && !b) {
      niv = 6;
      b = true;
    }
    if (_exp >= level[7]) {
      niv = 7;
    }
    return niv;
  }

  // REFA :
  // _ mirejoindre boite
  // _ mis child mi rejoindre
}
