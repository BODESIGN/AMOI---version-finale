class CRYPTO {
  List encode = [
    '-',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'y',
    'z',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'Y',
    'Z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  List to = [
    'W',
    'Y',
    'Z',
    '0',
    '1',
    '2',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'y',
    'z',
    'A',
    'B',
    'C',
    'D',
    '-',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
  ];

  // ===========================================================
  crypte(String text) {
    String res = '';
    text.runes.forEach((int rune) {
      var character = String.fromCharCode(rune);
      String c = character;
      for (var i = 0; i < encode.length; i++) {
        if (character == encode[i]) c = to[i];
      }
      res = "$res$c";
    });

    return res;
  }

  // ===========================================================
  deCrypte(String text) {
    String res = '';
    text.runes.forEach((int rune) {
      var character = String.fromCharCode(rune);
      String c = character;
      for (var i = 0; i < to.length; i++) {
        if (character == to[i]) c = encode[i];
      }
      res = "$res$c";
    });
    return res;
  }
}
