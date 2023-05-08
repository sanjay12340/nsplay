import 'dart:developer';

import '../double_pana_list.dart';
import '../single_pana_list.dart';

class GenrateMotorNumber {
  static List<String> _arrageNumber(String number) {
    String s = number;
    final myNumbers = s.split("");
    myNumbers.sort((a, b) => a.compareTo(b));
    final uniqueNumbers = myNumbers.toSet().toList();
    if (uniqueNumbers.first == "0") {
      uniqueNumbers.removeAt(0);
      uniqueNumbers.add("0");
    }
    log(uniqueNumbers.toString(), name: "_arrageNumber");
    return uniqueNumbers;
  }

  static List<String> spMotor(String number) {
    _arrageNumber(number);
    log(number, name: "SPMOTOR");
    var u = _arrageNumber(number);
    int l = u.length;
    List<String> a = [];

    if (l == 4) {
      a.add(u[0] + "" + u[1] + "" + u[2]);
      a.add(u[0] + "" + u[1] + "" + u[3]);
      a.add(u[0] + "" + u[2] + "" + u[3]);
      a.add(u[1] + "" + u[2] + "" + u[3]);
    }

    if (l == 5) {
      a.add(u[0] + "" + u[1] + "" + u[2]);
      a.add(u[0] + "" + u[1] + "" + u[3]);
      a.add(u[0] + "" + u[1] + "" + u[4]);

      a.add(u[0] + "" + u[2] + "" + u[3]);
      a.add(u[0] + "" + u[2] + "" + u[4]);

      a.add(u[0] + "" + u[3] + "" + u[4]);

      a.add(u[1] + "" + u[2] + "" + u[3]);
      a.add(u[1] + "" + u[2] + "" + u[4]);

      a.add(u[1] + "" + u[3] + "" + u[4]);

      a.add(u[2] + "" + u[3] + "" + u[4]);
    }

    if (l == 6) {
      a.add(u[0] + "" + u[1] + "" + u[2]);
      a.add(u[0] + "" + u[1] + "" + u[3]);
      a.add(u[0] + "" + u[1] + "" + u[4]);
      a.add(u[0] + "" + u[1] + "" + u[5]);

      a.add(u[0] + "" + u[2] + "" + u[3]);
      a.add(u[0] + "" + u[2] + "" + u[4]);
      a.add(u[0] + "" + u[2] + "" + u[5]);

      a.add(u[0] + "" + u[3] + "" + u[4]);
      a.add(u[0] + "" + u[3] + "" + u[5]);

      a.add(u[0] + "" + u[4] + "" + u[5]);

      a.add(u[1] + "" + u[2] + "" + u[3]);
      a.add(u[1] + "" + u[2] + "" + u[4]);
      a.add(u[1] + "" + u[2] + "" + u[5]);

      a.add(u[1] + "" + u[3] + "" + u[4]);
      a.add(u[1] + "" + u[3] + "" + u[5]);

      a.add(u[1] + "" + u[4] + "" + u[5]);

      a.add(u[2] + "" + u[3] + "" + u[4]);
      a.add(u[2] + "" + u[3] + "" + u[5]);

      a.add(u[2] + "" + u[4] + "" + u[5]);

      a.add(u[3] + "" + u[4] + "" + u[5]);
    }

    if (l == 7) {
      a.add(u[0] + "" + u[1] + "" + u[2]);
      a.add(u[0] + "" + u[1] + "" + u[3]);
      a.add(u[0] + "" + u[1] + "" + u[4]);
      a.add(u[0] + "" + u[1] + "" + u[5]);
      a.add(u[0] + "" + u[1] + "" + u[6]);

      a.add(u[0] + "" + u[2] + "" + u[3]);
      a.add(u[0] + "" + u[2] + "" + u[4]);
      a.add(u[0] + "" + u[2] + "" + u[5]);
      a.add(u[0] + "" + u[2] + "" + u[6]);

      a.add(u[0] + "" + u[3] + "" + u[4]);
      a.add(u[0] + "" + u[3] + "" + u[5]);
      a.add(u[0] + "" + u[3] + "" + u[6]);

      a.add(u[0] + "" + u[4] + "" + u[5]);
      a.add(u[0] + "" + u[4] + "" + u[6]);

      a.add(u[0] + "" + u[5] + "" + u[6]);

      a.add(u[1] + "" + u[2] + "" + u[3]);
      a.add(u[1] + "" + u[2] + "" + u[4]);
      a.add(u[1] + "" + u[2] + "" + u[5]);
      a.add(u[1] + "" + u[2] + "" + u[6]);

      a.add(u[1] + "" + u[3] + "" + u[4]);
      a.add(u[1] + "" + u[3] + "" + u[5]);
      a.add(u[1] + "" + u[3] + "" + u[6]);

      a.add(u[1] + "" + u[4] + "" + u[5]);
      a.add(u[1] + "" + u[4] + "" + u[6]);

      a.add(u[1] + "" + u[5] + "" + u[6]);

      a.add(u[2] + "" + u[3] + "" + u[4]);
      a.add(u[2] + "" + u[3] + "" + u[5]);
      a.add(u[2] + "" + u[3] + "" + u[6]);

      a.add(u[2] + "" + u[4] + "" + u[5]);
      a.add(u[2] + "" + u[4] + "" + u[6]);

      a.add(u[2] + "" + u[5] + "" + u[6]);

      a.add(u[3] + "" + u[4] + "" + u[5]);
      a.add(u[3] + "" + u[4] + "" + u[6]);

      a.add(u[3] + "" + u[5] + "" + u[6]);

      a.add(u[4] + "" + u[5] + "" + u[6]);
    }
    if (l == 8) {
      a.add(u[0] + "" + u[1] + "" + u[2]);
      a.add(u[0] + "" + u[1] + "" + u[3]);
      a.add(u[0] + "" + u[1] + "" + u[4]);
      a.add(u[0] + "" + u[1] + "" + u[5]);
      a.add(u[0] + "" + u[1] + "" + u[6]);
      a.add(u[0] + "" + u[1] + "" + u[7]);

      a.add(u[0] + "" + u[2] + "" + u[3]);
      a.add(u[0] + "" + u[2] + "" + u[4]);
      a.add(u[0] + "" + u[2] + "" + u[5]);
      a.add(u[0] + "" + u[2] + "" + u[6]);
      a.add(u[0] + "" + u[2] + "" + u[7]);

      a.add(u[0] + "" + u[3] + "" + u[4]);
      a.add(u[0] + "" + u[3] + "" + u[5]);
      a.add(u[0] + "" + u[3] + "" + u[6]);
      a.add(u[0] + "" + u[3] + "" + u[7]);

      a.add(u[0] + "" + u[4] + "" + u[5]);
      a.add(u[0] + "" + u[4] + "" + u[6]);
      a.add(u[0] + "" + u[4] + "" + u[7]);

      a.add(u[0] + "" + u[5] + "" + u[6]);
      a.add(u[0] + "" + u[5] + "" + u[7]);

      a.add(u[0] + "" + u[6] + "" + u[7]);

      a.add(u[1] + "" + u[2] + "" + u[3]);
      a.add(u[1] + "" + u[2] + "" + u[4]);
      a.add(u[1] + "" + u[2] + "" + u[5]);
      a.add(u[1] + "" + u[2] + "" + u[6]);
      a.add(u[1] + "" + u[2] + "" + u[7]);

      a.add(u[1] + "" + u[3] + "" + u[4]);
      a.add(u[1] + "" + u[3] + "" + u[5]);
      a.add(u[1] + "" + u[3] + "" + u[6]);
      a.add(u[1] + "" + u[3] + "" + u[7]);

      a.add(u[1] + "" + u[4] + "" + u[5]);
      a.add(u[1] + "" + u[4] + "" + u[6]);
      a.add(u[1] + "" + u[4] + "" + u[7]);

      a.add(u[1] + "" + u[5] + "" + u[6]);
      a.add(u[1] + "" + u[5] + "" + u[7]);

      a.add(u[1] + "" + u[6] + "" + u[7]);

      a.add(u[2] + "" + u[3] + "" + u[4]);
      a.add(u[2] + "" + u[3] + "" + u[5]);
      a.add(u[2] + "" + u[3] + "" + u[6]);
      a.add(u[2] + "" + u[3] + "" + u[7]);

      a.add(u[2] + "" + u[4] + "" + u[5]);
      a.add(u[2] + "" + u[4] + "" + u[6]);
      a.add(u[2] + "" + u[4] + "" + u[7]);

      a.add(u[2] + "" + u[5] + "" + u[6]);
      a.add(u[2] + "" + u[5] + "" + u[7]);

      a.add(u[2] + "" + u[6] + "" + u[7]);

      a.add(u[3] + "" + u[4] + "" + u[5]);
      a.add(u[3] + "" + u[4] + "" + u[6]);
      a.add(u[3] + "" + u[4] + "" + u[7]);

      a.add(u[3] + "" + u[5] + "" + u[6]);
      a.add(u[3] + "" + u[5] + "" + u[7]);

      a.add(u[3] + "" + u[6] + "" + u[7]);

      a.add(u[4] + "" + u[5] + "" + u[6]);
      a.add(u[4] + "" + u[5] + "" + u[7]);

      a.add(u[4] + "" + u[6] + "" + u[7]);

      a.add(u[5] + "" + u[6] + "" + u[7]);
    }
    if (l == 9) {
      a.add(u[0] + "" + u[1] + "" + u[2]);
      a.add(u[0] + "" + u[1] + "" + u[3]);
      a.add(u[0] + "" + u[1] + "" + u[4]);
      a.add(u[0] + "" + u[1] + "" + u[5]);
      a.add(u[0] + "" + u[1] + "" + u[6]);
      a.add(u[0] + "" + u[1] + "" + u[7]);
      a.add(u[0] + "" + u[1] + "" + u[8]);

      a.add(u[0] + "" + u[2] + "" + u[3]);
      a.add(u[0] + "" + u[2] + "" + u[4]);
      a.add(u[0] + "" + u[2] + "" + u[5]);
      a.add(u[0] + "" + u[2] + "" + u[6]);
      a.add(u[0] + "" + u[2] + "" + u[7]);
      a.add(u[0] + "" + u[2] + "" + u[8]);

      a.add(u[0] + "" + u[3] + "" + u[4]);
      a.add(u[0] + "" + u[3] + "" + u[5]);
      a.add(u[0] + "" + u[3] + "" + u[6]);
      a.add(u[0] + "" + u[3] + "" + u[7]);
      a.add(u[0] + "" + u[3] + "" + u[8]);

      a.add(u[0] + "" + u[4] + "" + u[5]);
      a.add(u[0] + "" + u[4] + "" + u[6]);
      a.add(u[0] + "" + u[4] + "" + u[7]);
      a.add(u[0] + "" + u[4] + "" + u[8]);

      a.add(u[0] + "" + u[5] + "" + u[6]);
      a.add(u[0] + "" + u[5] + "" + u[7]);
      a.add(u[0] + "" + u[5] + "" + u[8]);

      a.add(u[0] + "" + u[6] + "" + u[7]);
      a.add(u[0] + "" + u[6] + "" + u[8]);

      a.add(u[0] + "" + u[7] + "" + u[8]);

      a.add(u[1] + "" + u[2] + "" + u[3]);
      a.add(u[1] + "" + u[2] + "" + u[4]);
      a.add(u[1] + "" + u[2] + "" + u[5]);
      a.add(u[1] + "" + u[2] + "" + u[6]);
      a.add(u[1] + "" + u[2] + "" + u[7]);
      a.add(u[1] + "" + u[2] + "" + u[8]);

      a.add(u[1] + "" + u[3] + "" + u[4]);
      a.add(u[1] + "" + u[3] + "" + u[5]);
      a.add(u[1] + "" + u[3] + "" + u[6]);
      a.add(u[1] + "" + u[3] + "" + u[7]);
      a.add(u[1] + "" + u[3] + "" + u[8]);

      a.add(u[1] + "" + u[4] + "" + u[5]);
      a.add(u[1] + "" + u[4] + "" + u[6]);
      a.add(u[1] + "" + u[4] + "" + u[7]);
      a.add(u[1] + "" + u[4] + "" + u[8]);

      a.add(u[1] + "" + u[5] + "" + u[6]);
      a.add(u[1] + "" + u[5] + "" + u[7]);
      a.add(u[1] + "" + u[5] + "" + u[8]);

      a.add(u[1] + "" + u[6] + "" + u[7]);
      a.add(u[1] + "" + u[6] + "" + u[8]);

      a.add(u[1] + "" + u[7] + "" + u[8]);

      a.add(u[2] + "" + u[3] + "" + u[4]);
      a.add(u[2] + "" + u[3] + "" + u[5]);
      a.add(u[2] + "" + u[3] + "" + u[6]);
      a.add(u[2] + "" + u[3] + "" + u[7]);
      a.add(u[2] + "" + u[3] + "" + u[8]);

      a.add(u[2] + "" + u[4] + "" + u[5]);
      a.add(u[2] + "" + u[4] + "" + u[6]);
      a.add(u[2] + "" + u[4] + "" + u[7]);
      a.add(u[2] + "" + u[4] + "" + u[8]);

      a.add(u[2] + "" + u[5] + "" + u[6]);
      a.add(u[2] + "" + u[5] + "" + u[7]);
      a.add(u[2] + "" + u[5] + "" + u[8]);

      a.add(u[2] + "" + u[6] + "" + u[7]);
      a.add(u[2] + "" + u[6] + "" + u[8]);

      a.add(u[2] + "" + u[7] + "" + u[8]);

      a.add(u[3] + "" + u[4] + "" + u[5]);
      a.add(u[3] + "" + u[4] + "" + u[6]);
      a.add(u[3] + "" + u[4] + "" + u[7]);
      a.add(u[3] + "" + u[4] + "" + u[8]);

      a.add(u[3] + "" + u[5] + "" + u[6]);
      a.add(u[3] + "" + u[5] + "" + u[7]);
      a.add(u[3] + "" + u[5] + "" + u[8]);

      a.add(u[3] + "" + u[6] + "" + u[7]);
      a.add(u[3] + "" + u[6] + "" + u[8]);

      a.add(u[3] + "" + u[7] + "" + u[8]);

      a.add(u[4] + "" + u[5] + "" + u[6]);
      a.add(u[4] + "" + u[5] + "" + u[7]);
      a.add(u[4] + "" + u[5] + "" + u[8]);

      a.add(u[4] + "" + u[6] + "" + u[7]);
      a.add(u[4] + "" + u[6] + "" + u[8]);

      a.add(u[4] + "" + u[7] + "" + u[8]);

      a.add(u[5] + "" + u[6] + "" + u[7]);
      a.add(u[5] + "" + u[6] + "" + u[8]);

      a.add(u[5] + "" + u[7] + "" + u[8]);

      a.add(u[6] + "" + u[7] + "" + u[8]);
    }
    if (l >= 10) {
      listSinglePana.forEach((element) {
        if (99 < int.parse(element['pana']!) &&
            int.parse(element['pana']!) < 1000) {
          a.add(element['pana']!);
        }
      });
    }
    log(a.toString(), name: "SPMOTOR");
    a.sort((a, b) => a.compareTo(b));
    return a;
  }

  static List<String> dpMotor(String number) {
    _arrageNumber(number);
    log(number, name: "DPMOTOR");
    var list = _arrageNumber(number);
    List<String> a = [];
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length; j++) {
        a.add("${list.elementAt(i)}${list.elementAt(i)}${list.elementAt(j)}");
        a.add("${list.elementAt(i)}${list.elementAt(j)}${list.elementAt(j)}");
      }
    }

    a.sort((a, b) => a.compareTo(b));
    return a;
  }

  static List<Map<String, String>> spDpTpMotor(String number,
      {bool sp = false, bool dp = false, bool tp = false}) {
    List<Map<String, String>> a = [];

    if (sp) {
      if (number == "0") {
        a += [
          {"game_type": "SinglePana", "pana": "127"},
          {"game_type": "SinglePana", "pana": "136"},
          {"game_type": "SinglePana", "pana": "145"},
          {"game_type": "SinglePana", "pana": "190"},
          {"game_type": "SinglePana", "pana": "235"},
          {"game_type": "SinglePana", "pana": "280"},
          {"game_type": "SinglePana", "pana": "370"},
          {"game_type": "SinglePana", "pana": "479"},
          {"game_type": "SinglePana", "pana": "460"},
          {"game_type": "SinglePana", "pana": "569"},
          {"game_type": "SinglePana", "pana": "389"},
          {"game_type": "SinglePana", "pana": "578"}
        ];
      }
      if (number == "1") {
        a += [
          {"game_type": "SinglePana", "pana": "128"},
          {"game_type": "SinglePana", "pana": "137"},
          {"game_type": "SinglePana", "pana": "146"},
          {"game_type": "SinglePana", "pana": "236"},
          {"game_type": "SinglePana", "pana": "245"},
          {"game_type": "SinglePana", "pana": "290"},
          {"game_type": "SinglePana", "pana": "380"},
          {"game_type": "SinglePana", "pana": "470"},
          {"game_type": "SinglePana", "pana": "489"},
          {"game_type": "SinglePana", "pana": "560"},
          {"game_type": "SinglePana", "pana": "678"},
          {"game_type": "SinglePana", "pana": "579"}
        ];
      }
      if (number == "2") {
        a += [
          {"game_type": "SinglePana", "pana": "129"},
          {"game_type": "SinglePana", "pana": "138"},
          {"game_type": "SinglePana", "pana": "147"},
          {"game_type": "SinglePana", "pana": "156"},
          {"game_type": "SinglePana", "pana": "237"},
          {"game_type": "SinglePana", "pana": "246"},
          {"game_type": "SinglePana", "pana": "345"},
          {"game_type": "SinglePana", "pana": "390"},
          {"game_type": "SinglePana", "pana": "480"},
          {"game_type": "SinglePana", "pana": "570"},
          {"game_type": "SinglePana", "pana": "589"},
          {"game_type": "SinglePana", "pana": "679"}
        ];
      }
      if (number == "3") {
        a += [
          {"game_type": "SinglePana", "pana": "120"},
          {"game_type": "SinglePana", "pana": "139"},
          {"game_type": "SinglePana", "pana": "148"},
          {"game_type": "SinglePana", "pana": "157"},
          {"game_type": "SinglePana", "pana": "238"},
          {"game_type": "SinglePana", "pana": "247"},
          {"game_type": "SinglePana", "pana": "256"},
          {"game_type": "SinglePana", "pana": "346"},
          {"game_type": "SinglePana", "pana": "490"},
          {"game_type": "SinglePana", "pana": "580"},
          {"game_type": "SinglePana", "pana": "670"},
          {"game_type": "SinglePana", "pana": "689"}
        ];
      }
      if (number == "4") {
        a += [
          {"game_type": "SinglePana", "pana": "130"},
          {"game_type": "SinglePana", "pana": "149"},
          {"game_type": "SinglePana", "pana": "158"},
          {"game_type": "SinglePana", "pana": "167"},
          {"game_type": "SinglePana", "pana": "239"},
          {"game_type": "SinglePana", "pana": "248"},
          {"game_type": "SinglePana", "pana": "257"},
          {"game_type": "SinglePana", "pana": "347"},
          {"game_type": "SinglePana", "pana": "356"},
          {"game_type": "SinglePana", "pana": "590"},
          {"game_type": "SinglePana", "pana": "680"},
          {"game_type": "SinglePana", "pana": "789"}
        ];
      }
      if (number == "5") {
        a += [
          {"game_type": "SinglePana", "pana": "140"},
          {"game_type": "SinglePana", "pana": "159"},
          {"game_type": "SinglePana", "pana": "168"},
          {"game_type": "SinglePana", "pana": "230"},
          {"game_type": "SinglePana", "pana": "249"},
          {"game_type": "SinglePana", "pana": "258"},
          {"game_type": "SinglePana", "pana": "267"},
          {"game_type": "SinglePana", "pana": "348"},
          {"game_type": "SinglePana", "pana": "357"},
          {"game_type": "SinglePana", "pana": "456"},
          {"game_type": "SinglePana", "pana": "690"},
          {"game_type": "SinglePana", "pana": "780"}
        ];
      }
      if (number == "6") {
        a += [
          {"game_type": "SinglePana", "pana": "123"},
          {"game_type": "SinglePana", "pana": "150"},
          {"game_type": "SinglePana", "pana": "169"},
          {"game_type": "SinglePana", "pana": "178"},
          {"game_type": "SinglePana", "pana": "240"},
          {"game_type": "SinglePana", "pana": "259"},
          {"game_type": "SinglePana", "pana": "268"},
          {"game_type": "SinglePana", "pana": "349"},
          {"game_type": "SinglePana", "pana": "358"},
          {"game_type": "SinglePana", "pana": "457"},
          {"game_type": "SinglePana", "pana": "367"},
          {"game_type": "SinglePana", "pana": "790"}
        ];
      }
      if (number == "7") {
        a += [
          {"game_type": "SinglePana", "pana": "124"},
          {"game_type": "SinglePana", "pana": "160"},
          {"game_type": "SinglePana", "pana": "179"},
          {"game_type": "SinglePana", "pana": "250"},
          {"game_type": "SinglePana", "pana": "269"},
          {"game_type": "SinglePana", "pana": "278"},
          {"game_type": "SinglePana", "pana": "340"},
          {"game_type": "SinglePana", "pana": "359"},
          {"game_type": "SinglePana", "pana": "368"},
          {"game_type": "SinglePana", "pana": "458"},
          {"game_type": "SinglePana", "pana": "467"},
          {"game_type": "SinglePana", "pana": "890"}
        ];
      }
      if (number == "8") {
        a += [
          {"game_type": "SinglePana", "pana": "125"},
          {"game_type": "SinglePana", "pana": "134"},
          {"game_type": "SinglePana", "pana": "170"},
          {"game_type": "SinglePana", "pana": "189"},
          {"game_type": "SinglePana", "pana": "260"},
          {"game_type": "SinglePana", "pana": "279"},
          {"game_type": "SinglePana", "pana": "350"},
          {"game_type": "SinglePana", "pana": "369"},
          {"game_type": "SinglePana", "pana": "378"},
          {"game_type": "SinglePana", "pana": "459"},
          {"game_type": "SinglePana", "pana": "567"},
          {"game_type": "SinglePana", "pana": "468"}
        ];
      }
      if (number == "9") {
        a += [
          {"game_type": "SinglePana", "pana": "126"},
          {"game_type": "SinglePana", "pana": "135"},
          {"game_type": "SinglePana", "pana": "180"},
          {"game_type": "SinglePana", "pana": "234"},
          {"game_type": "SinglePana", "pana": "270"},
          {"game_type": "SinglePana", "pana": "289"},
          {"game_type": "SinglePana", "pana": "360"},
          {"game_type": "SinglePana", "pana": "379"},
          {"game_type": "SinglePana", "pana": "450"},
          {"game_type": "SinglePana", "pana": "469"},
          {"game_type": "SinglePana", "pana": "478"},
          {"game_type": "SinglePana", "pana": "568"}
        ];
      }
    }
    if (dp) {
      if (number == "0") {
        a += [
          {"game_type": "DoublePana", "pana": "550"},
          {"game_type": "DoublePana", "pana": "668"},
          {"game_type": "DoublePana", "pana": "244"},
          {"game_type": "DoublePana", "pana": "299"},
          {"game_type": "DoublePana", "pana": "226"},
          {"game_type": "DoublePana", "pana": "488"},
          {"game_type": "DoublePana", "pana": "677"},
          {"game_type": "DoublePana", "pana": "118"},
          {"game_type": "DoublePana", "pana": "334"}
        ];
      }
      if (number == "1") {
        a += [
          {"game_type": "DoublePana", "pana": "100"},
          {"game_type": "DoublePana", "pana": "119"},
          {"game_type": "DoublePana", "pana": "155"},
          {"game_type": "DoublePana", "pana": "227"},
          {"game_type": "DoublePana", "pana": "335"},
          {"game_type": "DoublePana", "pana": "344"},
          {"game_type": "DoublePana", "pana": "399"},
          {"game_type": "DoublePana", "pana": "588"},
          {"game_type": "DoublePana", "pana": "669"}
        ];
      }
      if (number == "2") {
        a += [
          {"game_type": "DoublePana", "pana": "200"},
          {"game_type": "DoublePana", "pana": "110"},
          {"game_type": "DoublePana", "pana": "228"},
          {"game_type": "DoublePana", "pana": "255"},
          {"game_type": "DoublePana", "pana": "336"},
          {"game_type": "DoublePana", "pana": "499"},
          {"game_type": "DoublePana", "pana": "660"},
          {"game_type": "DoublePana", "pana": "688"},
          {"game_type": "DoublePana", "pana": "778"}
        ];
      }
      if (number == "3") {
        a += [
          {"game_type": "DoublePana", "pana": "300"},
          {"game_type": "DoublePana", "pana": "166"},
          {"game_type": "DoublePana", "pana": "229"},
          {"game_type": "DoublePana", "pana": "337"},
          {"game_type": "DoublePana", "pana": "355"},
          {"game_type": "DoublePana", "pana": "445"},
          {"game_type": "DoublePana", "pana": "599"},
          {"game_type": "DoublePana", "pana": "779"},
          {"game_type": "DoublePana", "pana": "788"}
        ];
      }
      if (number == "4") {
        a += [
          {"game_type": "DoublePana", "pana": "400"},
          {"game_type": "DoublePana", "pana": "112"},
          {"game_type": "DoublePana", "pana": "220"},
          {"game_type": "DoublePana", "pana": "266"},
          {"game_type": "DoublePana", "pana": "338"},
          {"game_type": "DoublePana", "pana": "446"},
          {"game_type": "DoublePana", "pana": "455"},
          {"game_type": "DoublePana", "pana": "699"},
          {"game_type": "DoublePana", "pana": "770"}
        ];
      }
      if (number == "5") {
        a += [
          {"game_type": "DoublePana", "pana": "500"},
          {"game_type": "DoublePana", "pana": "113"},
          {"game_type": "DoublePana", "pana": "122"},
          {"game_type": "DoublePana", "pana": "177"},
          {"game_type": "DoublePana", "pana": "339"},
          {"game_type": "DoublePana", "pana": "366"},
          {"game_type": "DoublePana", "pana": "447"},
          {"game_type": "DoublePana", "pana": "799"},
          {"game_type": "DoublePana", "pana": "889"}
        ];
      }
      if (number == "6") {
        a += [
          {"game_type": "DoublePana", "pana": "600"},
          {"game_type": "DoublePana", "pana": "114"},
          {"game_type": "DoublePana", "pana": "277"},
          {"game_type": "DoublePana", "pana": "330"},
          {"game_type": "DoublePana", "pana": "448"},
          {"game_type": "DoublePana", "pana": "466"},
          {"game_type": "DoublePana", "pana": "556"},
          {"game_type": "DoublePana", "pana": "880"},
          {"game_type": "DoublePana", "pana": "899"}
        ];
      }
      if (number == "7") {
        a += [
          {"game_type": "DoublePana", "pana": "700"},
          {"game_type": "DoublePana", "pana": "115"},
          {"game_type": "DoublePana", "pana": "133"},
          {"game_type": "DoublePana", "pana": "188"},
          {"game_type": "DoublePana", "pana": "223"},
          {"game_type": "DoublePana", "pana": "377"},
          {"game_type": "DoublePana", "pana": "449"},
          {"game_type": "DoublePana", "pana": "557"},
          {"game_type": "DoublePana", "pana": "566"}
        ];
      }
      if (number == "8") {
        a += [
          {"game_type": "DoublePana", "pana": "800"},
          {"game_type": "DoublePana", "pana": "116"},
          {"game_type": "DoublePana", "pana": "224"},
          {"game_type": "DoublePana", "pana": "233"},
          {"game_type": "DoublePana", "pana": "288"},
          {"game_type": "DoublePana", "pana": "440"},
          {"game_type": "DoublePana", "pana": "477"},
          {"game_type": "DoublePana", "pana": "558"},
          {"game_type": "DoublePana", "pana": "990"}
        ];
      }
      if (number == "9") {
        a += [
          {"game_type": "DoublePana", "pana": "900"},
          {"game_type": "DoublePana", "pana": "117"},
          {"game_type": "DoublePana", "pana": "144"},
          {"game_type": "DoublePana", "pana": "199"},
          {"game_type": "DoublePana", "pana": "225"},
          {"game_type": "DoublePana", "pana": "388"},
          {"game_type": "DoublePana", "pana": "559"},
          {"game_type": "DoublePana", "pana": "577"},
          {"game_type": "DoublePana", "pana": "667"}
        ];
      }
    }
    if (tp) {
      if (number == "0") {
        a += [
          {"game_type": "TripalPana", "pana": "000"}
        ];
      }
      if (number == "1") {
        a += [
          {"game_type": "TripalPana", "pana": "777"}
        ];
      }
      if (number == "2") {
        a += [
          {"game_type": "TripalPana", "pana": "444"}
        ];
      }
      if (number == "3") {
        a += [
          {"game_type": "TripalPana", "pana": "111"}
        ];
      }
      if (number == "4") {
        a += [
          {"game_type": "TripalPana", "pana": "888"}
        ];
      }
      if (number == "5") {
        a += [
          {"game_type": "TripalPana", "pana": "555"}
        ];
      }
      if (number == "6") {
        a += [
          {"game_type": "TripalPana", "pana": "222"}
        ];
      }
      if (number == "7") {
        a += [
          {"game_type": "TripalPana", "pana": "999"}
        ];
      }
      if (number == "8") {
        a += [
          {"game_type": "TripalPana", "pana": "666"}
        ];
      }
      if (number == "9") {
        a += [
          {"game_type": "TripalPana", "pana": "333"}
        ];
      }
    }

    log(a.toString(), name: "SPDPTP MOTOR");
    a.sort((a, b) => a['pana']!.compareTo(b['pana']!));
    return a;
  }

  static List<String> jodiFamily(String number) {
    List<String> a = [];

    if ("11 16 61 66".contains(number)) {
      a = ["11", "16", "61", "66"];
    }

    if ("12, 21, 17, 71, 26, 62, 67, 76".contains(number)) {
      a = ["12", "21", "17", "71", "26", "62", "67", "76"];
    }
    if ("13, 31, 18, 81, 36, 63, 68, 86".contains(number)) {
      a = ["13", "31", "18", "81", "36", "63", "68", "86"];
    }
    if ("25, 52, 20, 02, 57, 75, 70, 07".contains(number)) {
      a = ["25", "52", "20", "02", "57", "75", "70", "07"];
    }

    if ("14, 41, 19, 91, 46, 64, 69, 96".contains(number)) {
      a = ["14", "41", "19", "91", "46", "64", "69", "96"];
    }

    if ("15, 51, 10, 01, 56, 65, 60, 06".contains(number)) {
      a = ["15", "51", "10", "01", "56", "65", "60", "06"];
    }

    if ("22, 27, 72, 77".contains(number)) {
      a = ["22", "27", "72", "77"];
    }

    if ("23, 32, 28, 82, 37, 73, 78, 87".contains(number)) {
      a = ["23", "32", "28", "82", "37", "73", "78", "87"];
    }
    if ("24, 42, 29, 92, 47, 74, 79, 97".contains(number)) {
      a = ["24", "42", "29", "92", "47", "74", "79", "97"];
    }
    if ("33, 38, 83, 88".contains(number)) {
      a = ["33", "38", "83", "88"];
    }
    if ("34, 43, 39, 93, 48, 84, 89, 98".contains(number)) {
      a = ["34", "43", "39", "93", "48", "84", "89", "98"];
    }
    if ("35, 53, 30, 03, 58, 85, 80, 08".contains(number)) {
      a = ["35", "53", "30", "03", "58", "85", "80", "08"];
    }
    if ("44, 49, 94, 99".contains(number)) {
      a = ["44", "49", "94", "99"];
    }
    if ("45, 54, 40, 04, 59, 95, 90, 09".contains(number)) {
      a = ["45", "54", "40", "04", "59", "95", "90", "09"];
    }
    if ("55, 50, 05, 00".contains(number)) {
      a = ["55", "50", "05", "00"];
    }

    log(a.toString(), name: "DPMOTOR");
    a.sort((a, b) => a.compareTo(b));
    return a;
  }

  static List<Map<String, String>> panaFamily(String number) {
    List<Map<String, String>> a = [];

    if ("111, 116, 666, 166".contains(number)) {
      a = [
        {"game_type": "TripalPana", "pana": "111"},
        {"game_type": "DoublePana", "pana": "116"},
        {"game_type": "TripalPana", "pana": "666"},
        {"game_type": "DoublePana", "pana": "166"}
      ];
    }

    if ("112,117,167,667,266,126".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "112"},
        {"game_type": "DoublePana", "pana": "117"},
        {"game_type": "SinglePana", "pana": "167"},
        {"game_type": "DoublePana", "pana": "667"},
        {"game_type": "DoublePana", "pana": "266"},
        {"game_type": "SinglePana", "pana": "126"}
      ];
    }
    if ("334,339,348,389,488,889".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "334"},
        {"game_type": "DoublePana", "pana": "339"},
        {"game_type": "SinglePana", "pana": "348"},
        {"game_type": "SinglePana", "pana": "389"},
        {"game_type": "DoublePana", "pana": "488"},
        {"game_type": "DoublePana", "pana": "889"}
      ];
    }
    if ("330,335,358,380,588,880".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "330"},
        {"game_type": "DoublePana", "pana": "335"},
        {"game_type": "SinglePana", "pana": "358"},
        {"game_type": "SinglePana", "pana": "380"},
        {"game_type": "DoublePana", "pana": "588"},
        {"game_type": "DoublePana", "pana": "880"}
      ];
    }
    if ("113,118,136,168,668,366".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "113"},
        {"game_type": "DoublePana", "pana": "118"},
        {"game_type": "SinglePana", "pana": "136"},
        {"game_type": "SinglePana", "pana": "168"},
        {"game_type": "DoublePana", "pana": "668"},
        {"game_type": "DoublePana", "pana": "366"}
      ];
    }

    if ("114,119,466,669,146,169".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "114"},
        {"game_type": "DoublePana", "pana": "119"},
        {"game_type": "DoublePana", "pana": "466"},
        {"game_type": "DoublePana", "pana": "669"},
        {"game_type": "SinglePana", "pana": "146"},
        {"game_type": "SinglePana", "pana": "169"}
      ];
    }
    if ("235,280,578,370,230,357,258,780".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "235"},
        {"game_type": "SinglePana", "pana": "280"},
        {"game_type": "SinglePana", "pana": "578"},
        {"game_type": "SinglePana", "pana": "370"},
        {"game_type": "SinglePana", "pana": "230"},
        {"game_type": "SinglePana", "pana": "357"},
        {"game_type": "SinglePana", "pana": "258"},
        {"game_type": "SinglePana", "pana": "780"}
      ];
    }

    if ("115,110,156,660,566,160".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "115"},
        {"game_type": "DoublePana", "pana": "110"},
        {"game_type": "SinglePana", "pana": "156"},
        {"game_type": "DoublePana", "pana": "660"},
        {"game_type": "DoublePana", "pana": "566"},
        {"game_type": "SinglePana", "pana": "160"}
      ];
    }

    if ("123,128,137,178,236,367,678,268".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "123"},
        {"game_type": "SinglePana", "pana": "128"},
        {"game_type": "SinglePana", "pana": "137"},
        {"game_type": "SinglePana", "pana": "178"},
        {"game_type": "SinglePana", "pana": "236"},
        {"game_type": "SinglePana", "pana": "367"},
        {"game_type": "SinglePana", "pana": "678"},
        {"game_type": "SinglePana", "pana": "268"}
      ];
    }

    if ("122,177,127,226,677,267".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "122"},
        {"game_type": "DoublePana", "pana": "177"},
        {"game_type": "SinglePana", "pana": "127"},
        {"game_type": "DoublePana", "pana": "226"},
        {"game_type": "DoublePana", "pana": "677"},
        {"game_type": "SinglePana", "pana": "267"}
      ];
    }
    if ("124,129,147,179,269,246,467,679".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "124"},
        {"game_type": "SinglePana", "pana": "129"},
        {"game_type": "SinglePana", "pana": "147"},
        {"game_type": "SinglePana", "pana": "179"},
        {"game_type": "SinglePana", "pana": "269"},
        {"game_type": "SinglePana", "pana": "246"},
        {"game_type": "SinglePana", "pana": "467"},
        {"game_type": "SinglePana", "pana": "679"}
      ];
    }
    if ("125,120,260,256,567,670,157,170".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "125"},
        {"game_type": "SinglePana", "pana": "120"},
        {"game_type": "SinglePana", "pana": "260"},
        {"game_type": "SinglePana", "pana": "256"},
        {"game_type": "SinglePana", "pana": "567"},
        {"game_type": "SinglePana", "pana": "670"},
        {"game_type": "SinglePana", "pana": "157"},
        {"game_type": "SinglePana", "pana": "170"}
      ];
    }
    if ("133,188,138,336,368,688".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "133"},
        {"game_type": "DoublePana", "pana": "188"},
        {"game_type": "SinglePana", "pana": "138"},
        {"game_type": "DoublePana", "pana": "336"},
        {"game_type": "SinglePana", "pana": "368"},
        {"game_type": "DoublePana", "pana": "688"}
      ];
    }
    if ("134, 139, 148, 689, 189, 369, 468, 346".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "134"},
        {"game_type": "SinglePana", "pana": "139"},
        {"game_type": "SinglePana", "pana": "148"},
        {"game_type": "SinglePana", "pana": "689"},
        {"game_type": "SinglePana", "pana": "189"},
        {"game_type": "SinglePana", "pana": "369"},
        {"game_type": "SinglePana", "pana": "468"},
        {"game_type": "SinglePana", "pana": "346"}
      ];
    }
    if ("135, 130, 356, 680, 158, 180, 360, 568".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "135"},
        {"game_type": "SinglePana", "pana": "130"},
        {"game_type": "SinglePana", "pana": "356"},
        {"game_type": "SinglePana", "pana": "680"},
        {"game_type": "SinglePana", "pana": "158"},
        {"game_type": "SinglePana", "pana": "180"},
        {"game_type": "SinglePana", "pana": "360"},
        {"game_type": "SinglePana", "pana": "568"}
      ];
    }
    if ("144, 149, 699, 199, 469, 446".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "144"},
        {"game_type": "SinglePana", "pana": "149"},
        {"game_type": "DoublePana", "pana": "699"},
        {"game_type": "DoublePana", "pana": "199"},
        {"game_type": "SinglePana", "pana": "469"},
        {"game_type": "DoublePana", "pana": "446"}
      ];
    }
    if ("145, 140, 456, 690, 159, 190, 569, 460".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "145"},
        {"game_type": "SinglePana", "pana": "140"},
        {"game_type": "SinglePana", "pana": "456"},
        {"game_type": "SinglePana", "pana": "690"},
        {"game_type": "SinglePana", "pana": "159"},
        {"game_type": "SinglePana", "pana": "190"},
        {"game_type": "SinglePana", "pana": "569"},
        {"game_type": "SinglePana", "pana": "460"}
      ];
    }
    if ("155, 560, 100, 556, 600, 150".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "155"},
        {"game_type": "SinglePana", "pana": "560"},
        {"game_type": "DoublePana", "pana": "100"},
        {"game_type": "DoublePana", "pana": "556"},
        {"game_type": "DoublePana", "pana": "600"},
        {"game_type": "SinglePana", "pana": "150"}
      ];
    }
    if ("222, 227, 777, 277".contains(number)) {
      a = [
        {"game_type": "TripalPana", "pana": "222"},
        {"game_type": "DoublePana", "pana": "227"},
        {"game_type": "TripalPana", "pana": "777"},
        {"game_type": "DoublePana", "pana": "277"}
      ];
    }
    if ("223 ,278 ,377 ,237 ,228 ,778".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "223"},
        {"game_type": "SinglePana", "pana": "278"},
        {"game_type": "DoublePana", "pana": "377"},
        {"game_type": "SinglePana", "pana": "237"},
        {"game_type": "DoublePana", "pana": "228"},
        {"game_type": "DoublePana", "pana": "778"}
      ];
    }
    if ("224 ,779 ,229 ,247 ,279 ,477".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "224"},
        {"game_type": "DoublePana", "pana": "779"},
        {"game_type": "DoublePana", "pana": "229"},
        {"game_type": "SinglePana", "pana": "247"},
        {"game_type": "SinglePana", "pana": "279"},
        {"game_type": "DoublePana", "pana": "477"}
      ];
    }
    if ("225,270,577,257,770,220".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "225"},
        {"game_type": "SinglePana", "pana": "270"},
        {"game_type": "DoublePana", "pana": "577"},
        {"game_type": "SinglePana", "pana": "257"},
        {"game_type": "DoublePana", "pana": "770"},
        {"game_type": "DoublePana", "pana": "220"}
      ];
    }
    if ("233 ,288 ,378 ,238 ,337 ,788".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "233"},
        {"game_type": "DoublePana", "pana": "288"},
        {"game_type": "SinglePana", "pana": "378"},
        {"game_type": "SinglePana", "pana": "238"},
        {"game_type": "DoublePana", "pana": "337"},
        {"game_type": "DoublePana", "pana": "788"}
      ];
    }
    if ("234 ,379 ,289 ,478 ,789 ,248 ,347 ,239".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "234"},
        {"game_type": "SinglePana", "pana": "379"},
        {"game_type": "SinglePana", "pana": "289"},
        {"game_type": "SinglePana", "pana": "478"},
        {"game_type": "SinglePana", "pana": "789"},
        {"game_type": "SinglePana", "pana": "248"},
        {"game_type": "SinglePana", "pana": "347"},
        {"game_type": "SinglePana", "pana": "239"}
      ];
    }
    if ("235 ,280 ,578 ,370 ,230 ,357 ,258 ,780".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "235"},
        {"game_type": "SinglePana", "pana": "280"},
        {"game_type": "SinglePana", "pana": "578"},
        {"game_type": "SinglePana", "pana": "370"},
        {"game_type": "SinglePana", "pana": "230"},
        {"game_type": "SinglePana", "pana": "357"},
        {"game_type": "SinglePana", "pana": "258"},
        {"game_type": "SinglePana", "pana": "780"}
      ];
    }
    if ("244,299,479,447,249,799".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "244"},
        {"game_type": "DoublePana", "pana": "299"},
        {"game_type": "SinglePana", "pana": "479"},
        {"game_type": "DoublePana", "pana": "447"},
        {"game_type": "SinglePana", "pana": "249"},
        {"game_type": "DoublePana", "pana": "799"}
      ];
    }
    if ("245, 290, 470, 579, 240, 790, 259, 457".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "245"},
        {"game_type": "SinglePana", "pana": "290"},
        {"game_type": "SinglePana", "pana": "470"},
        {"game_type": "SinglePana", "pana": "579"},
        {"game_type": "SinglePana", "pana": "240"},
        {"game_type": "SinglePana", "pana": "790"},
        {"game_type": "SinglePana", "pana": "259"},
        {"game_type": "SinglePana", "pana": "457"}
      ];
    }
    if ("255, 200, 570, 250, 700, 557".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "255"},
        {"game_type": "DoublePana", "pana": "200"},
        {"game_type": "SinglePana", "pana": "570"},
        {"game_type": "SinglePana", "pana": "250"},
        {"game_type": "DoublePana", "pana": "700"},
        {"game_type": "DoublePana", "pana": "557"}
      ];
    }
    if ("333, 338, 888, 388".contains(number)) {
      a = [
        {"game_type": "TripalPana", "pana": "333"},
        {"game_type": "DoublePana", "pana": "338"},
        {"game_type": "TripalPana", "pana": "888"},
        {"game_type": "DoublePana", "pana": "388"}
      ];
    }
    if ("344, 489, 399, 899, 349, 448".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "344"},
        {"game_type": "SinglePana", "pana": "489"},
        {"game_type": "DoublePana", "pana": "399"},
        {"game_type": "DoublePana", "pana": "899"},
        {"game_type": "SinglePana", "pana": "349"},
        {"game_type": "DoublePana", "pana": "448"}
      ];
    }
    if ("345, 390, 480, 589, 890, 340, 458, 359".contains(number)) {
      a = [
        {"game_type": "SinglePana", "pana": "345"},
        {"game_type": "SinglePana", "pana": "390"},
        {"game_type": "SinglePana", "pana": "480"},
        {"game_type": "SinglePana", "pana": "589"},
        {"game_type": "SinglePana", "pana": "890"},
        {"game_type": "SinglePana", "pana": "340"},
        {"game_type": "SinglePana", "pana": "458"},
        {"game_type": "SinglePana", "pana": "359"}
      ];
    }
    if ("355, 300, 580, 558, 800, 350".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "355"},
        {"game_type": "DoublePana", "pana": "300"},
        {"game_type": "SinglePana", "pana": "580"},
        {"game_type": "DoublePana", "pana": "558"},
        {"game_type": "DoublePana", "pana": "800"},
        {"game_type": "SinglePana", "pana": "350"}
      ];
    }
    if ("444, 449, 999, 499".contains(number)) {
      a = [
        {"game_type": "TripalPana", "pana": "444"},
        {"game_type": "DoublePana", "pana": "449"},
        {"game_type": "TripalPana", "pana": "999"},
        {"game_type": "DoublePana", "pana": "499"}
      ];
    }
    if ("445, 490, 599, 459, 990, 440".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "445"},
        {"game_type": "SinglePana", "pana": "490"},
        {"game_type": "DoublePana", "pana": "599"},
        {"game_type": "SinglePana", "pana": "459"},
        {"game_type": "DoublePana", "pana": "990"},
        {"game_type": "DoublePana", "pana": "440"}
      ];
    }
    if ("455, 400, 590, 559, 900, 450".contains(number)) {
      a = [
        {"game_type": "DoublePana", "pana": "455"},
        {"game_type": "DoublePana", "pana": "400"},
        {"game_type": "SinglePana", "pana": "590"},
        {"game_type": "DoublePana", "pana": "559"},
        {"game_type": "DoublePana", "pana": "900"},
        {"game_type": "SinglePana", "pana": "450"}
      ];
    }
    if ("555, 500, 550, 000".contains(number)) {
      a = [
        {"game_type": "TripalPana", "pana": "555"},
        {"game_type": "DoublePana", "pana": "500"},
        {"game_type": "DoublePana", "pana": "550"},
        {"game_type": "TripalPana", "pana": "000"}
      ];
    }

    log(a.toString(), name: "Pana Family");
    a.sort((a, b) => a["pana"]!.compareTo(b['pana']!));
    return a;
  }

  static List<Map<String, String>> cyclePatti(String number) {
    List<String> u = number.split("");
    log(u.toString(), name: "Check Cpatti number");
    List<Map<String, String>> a = [];

    List<Map<String, String>> b = [
      {"game_type": "SinglePana", "pana": "127"},
      {"game_type": "SinglePana", "pana": "136"},
      {"game_type": "SinglePana", "pana": "145"},
      {"game_type": "SinglePana", "pana": "190"},
      {"game_type": "SinglePana", "pana": "235"},
      {"game_type": "SinglePana", "pana": "280"},
      {"game_type": "SinglePana", "pana": "370"},
      {"game_type": "SinglePana", "pana": "479"},
      {"game_type": "DoublePana", "pana": "334"},
      {"game_type": "SinglePana", "pana": "460"},
      {"game_type": "SinglePana", "pana": "569"},
      {"game_type": "SinglePana", "pana": "389"},
      {"game_type": "SinglePana", "pana": "578"},
      {"game_type": "SinglePana", "pana": "128"},
      {"game_type": "SinglePana", "pana": "137"},
      {"game_type": "SinglePana", "pana": "146"},
      {"game_type": "SinglePana", "pana": "236"},
      {"game_type": "SinglePana", "pana": "245"},
      {"game_type": "SinglePana", "pana": "290"},
      {"game_type": "SinglePana", "pana": "380"},
      {"game_type": "SinglePana", "pana": "470"},
      {"game_type": "SinglePana", "pana": "489"},
      {"game_type": "SinglePana", "pana": "560"},
      {"game_type": "SinglePana", "pana": "678"},
      {"game_type": "SinglePana", "pana": "579"},
      {"game_type": "SinglePana", "pana": "129"},
      {"game_type": "SinglePana", "pana": "138"},
      {"game_type": "SinglePana", "pana": "147"},
      {"game_type": "SinglePana", "pana": "156"},
      {"game_type": "SinglePana", "pana": "237"},
      {"game_type": "SinglePana", "pana": "246"},
      {"game_type": "SinglePana", "pana": "345"},
      {"game_type": "SinglePana", "pana": "390"},
      {"game_type": "SinglePana", "pana": "480"},
      {"game_type": "SinglePana", "pana": "570"},
      {"game_type": "SinglePana", "pana": "589"},
      {"game_type": "SinglePana", "pana": "679"},
      {"game_type": "SinglePana", "pana": "120"},
      {"game_type": "SinglePana", "pana": "139"},
      {"game_type": "SinglePana", "pana": "148"},
      {"game_type": "SinglePana", "pana": "157"},
      {"game_type": "SinglePana", "pana": "238"},
      {"game_type": "SinglePana", "pana": "247"},
      {"game_type": "SinglePana", "pana": "256"},
      {"game_type": "SinglePana", "pana": "346"},
      {"game_type": "SinglePana", "pana": "490"},
      {"game_type": "SinglePana", "pana": "580"},
      {"game_type": "SinglePana", "pana": "670"},
      {"game_type": "SinglePana", "pana": "689"},
      {"game_type": "SinglePana", "pana": "130"},
      {"game_type": "SinglePana", "pana": "149"},
      {"game_type": "SinglePana", "pana": "158"},
      {"game_type": "SinglePana", "pana": "167"},
      {"game_type": "SinglePana", "pana": "239"},
      {"game_type": "SinglePana", "pana": "248"},
      {"game_type": "SinglePana", "pana": "257"},
      {"game_type": "SinglePana", "pana": "347"},
      {"game_type": "SinglePana", "pana": "356"},
      {"game_type": "SinglePana", "pana": "590"},
      {"game_type": "SinglePana", "pana": "680"},
      {"game_type": "SinglePana", "pana": "789"},
      {"game_type": "SinglePana", "pana": "140"},
      {"game_type": "SinglePana", "pana": "159"},
      {"game_type": "SinglePana", "pana": "168"},
      {"game_type": "SinglePana", "pana": "230"},
      {"game_type": "SinglePana", "pana": "249"},
      {"game_type": "SinglePana", "pana": "258"},
      {"game_type": "SinglePana", "pana": "267"},
      {"game_type": "SinglePana", "pana": "348"},
      {"game_type": "SinglePana", "pana": "357"},
      {"game_type": "SinglePana", "pana": "456"},
      {"game_type": "SinglePana", "pana": "690"},
      {"game_type": "SinglePana", "pana": "780"},
      {"game_type": "SinglePana", "pana": "123"},
      {"game_type": "SinglePana", "pana": "150"},
      {"game_type": "SinglePana", "pana": "169"},
      {"game_type": "SinglePana", "pana": "178"},
      {"game_type": "SinglePana", "pana": "240"},
      {"game_type": "SinglePana", "pana": "259"},
      {"game_type": "SinglePana", "pana": "268"},
      {"game_type": "SinglePana", "pana": "349"},
      {"game_type": "SinglePana", "pana": "358"},
      {"game_type": "SinglePana", "pana": "457"},
      {"game_type": "SinglePana", "pana": "367"},
      {"game_type": "SinglePana", "pana": "790"},
      {"game_type": "SinglePana", "pana": "124"},
      {"game_type": "SinglePana", "pana": "160"},
      {"game_type": "SinglePana", "pana": "179"},
      {"game_type": "SinglePana", "pana": "250"},
      {"game_type": "SinglePana", "pana": "269"},
      {"game_type": "SinglePana", "pana": "278"},
      {"game_type": "SinglePana", "pana": "340"},
      {"game_type": "SinglePana", "pana": "359"},
      {"game_type": "SinglePana", "pana": "368"},
      {"game_type": "SinglePana", "pana": "458"},
      {"game_type": "SinglePana", "pana": "467"},
      {"game_type": "SinglePana", "pana": "890"},
      {"game_type": "SinglePana", "pana": "125"},
      {"game_type": "SinglePana", "pana": "134"},
      {"game_type": "SinglePana", "pana": "170"},
      {"game_type": "SinglePana", "pana": "189"},
      {"game_type": "SinglePana", "pana": "260"},
      {"game_type": "SinglePana", "pana": "279"},
      {"game_type": "SinglePana", "pana": "350"},
      {"game_type": "SinglePana", "pana": "369"},
      {"game_type": "SinglePana", "pana": "378"},
      {"game_type": "SinglePana", "pana": "459"},
      {"game_type": "SinglePana", "pana": "567"},
      {"game_type": "SinglePana", "pana": "468"},
      {"game_type": "SinglePana", "pana": "126"},
      {"game_type": "SinglePana", "pana": "135"},
      {"game_type": "SinglePana", "pana": "180"},
      {"game_type": "SinglePana", "pana": "234"},
      {"game_type": "SinglePana", "pana": "270"},
      {"game_type": "SinglePana", "pana": "289"},
      {"game_type": "SinglePana", "pana": "360"},
      {"game_type": "SinglePana", "pana": "379"},
      {"game_type": "SinglePana", "pana": "450"},
      {"game_type": "SinglePana", "pana": "469"},
      {"game_type": "SinglePana", "pana": "478"},
      {"game_type": "SinglePana", "pana": "568"},
      {"game_type": "DoublePana", "pana": "550"},
      {"game_type": "DoublePana", "pana": "668"},
      {"game_type": "DoublePana", "pana": "244"},
      {"game_type": "DoublePana", "pana": "299"},
      {"game_type": "DoublePana", "pana": "226"},
      {"game_type": "DoublePana", "pana": "488"},
      {"game_type": "DoublePana", "pana": "677"},
      {"game_type": "DoublePana", "pana": "118"},
      {"game_type": "DoublePana", "pana": "100"},
      {"game_type": "DoublePana", "pana": "119"},
      {"game_type": "DoublePana", "pana": "155"},
      {"game_type": "DoublePana", "pana": "227"},
      {"game_type": "DoublePana", "pana": "335"},
      {"game_type": "DoublePana", "pana": "344"},
      {"game_type": "DoublePana", "pana": "399"},
      {"game_type": "DoublePana", "pana": "588"},
      {"game_type": "DoublePana", "pana": "669"},
      {"game_type": "DoublePana", "pana": "200"},
      {"game_type": "DoublePana", "pana": "110"},
      {"game_type": "DoublePana", "pana": "228"},
      {"game_type": "DoublePana", "pana": "255"},
      {"game_type": "DoublePana", "pana": "336"},
      {"game_type": "DoublePana", "pana": "499"},
      {"game_type": "DoublePana", "pana": "660"},
      {"game_type": "DoublePana", "pana": "688"},
      {"game_type": "DoublePana", "pana": "778"},
      {"game_type": "DoublePana", "pana": "300"},
      {"game_type": "DoublePana", "pana": "166"},
      {"game_type": "DoublePana", "pana": "229"},
      {"game_type": "DoublePana", "pana": "337"},
      {"game_type": "DoublePana", "pana": "355"},
      {"game_type": "DoublePana", "pana": "445"},
      {"game_type": "DoublePana", "pana": "599"},
      {"game_type": "DoublePana", "pana": "779"},
      {"game_type": "DoublePana", "pana": "788"},
      {"game_type": "DoublePana", "pana": "400"},
      {"game_type": "DoublePana", "pana": "112"},
      {"game_type": "DoublePana", "pana": "220"},
      {"game_type": "DoublePana", "pana": "266"},
      {"game_type": "DoublePana", "pana": "338"},
      {"game_type": "DoublePana", "pana": "446"},
      {"game_type": "DoublePana", "pana": "455"},
      {"game_type": "DoublePana", "pana": "699"},
      {"game_type": "DoublePana", "pana": "770"},
      {"game_type": "DoublePana", "pana": "500"},
      {"game_type": "DoublePana", "pana": "113"},
      {"game_type": "DoublePana", "pana": "122"},
      {"game_type": "DoublePana", "pana": "177"},
      {"game_type": "DoublePana", "pana": "339"},
      {"game_type": "DoublePana", "pana": "366"},
      {"game_type": "DoublePana", "pana": "447"},
      {"game_type": "DoublePana", "pana": "799"},
      {"game_type": "DoublePana", "pana": "889"},
      {"game_type": "DoublePana", "pana": "600"},
      {"game_type": "DoublePana", "pana": "114"},
      {"game_type": "DoublePana", "pana": "277"},
      {"game_type": "DoublePana", "pana": "330"},
      {"game_type": "DoublePana", "pana": "448"},
      {"game_type": "DoublePana", "pana": "466"},
      {"game_type": "DoublePana", "pana": "556"},
      {"game_type": "DoublePana", "pana": "880"},
      {"game_type": "DoublePana", "pana": "899"},
      {"game_type": "DoublePana", "pana": "700"},
      {"game_type": "DoublePana", "pana": "115"},
      {"game_type": "DoublePana", "pana": "133"},
      {"game_type": "DoublePana", "pana": "188"},
      {"game_type": "DoublePana", "pana": "223"},
      {"game_type": "DoublePana", "pana": "377"},
      {"game_type": "DoublePana", "pana": "449"},
      {"game_type": "DoublePana", "pana": "557"},
      {"game_type": "DoublePana", "pana": "566"},
      {"game_type": "DoublePana", "pana": "800"},
      {"game_type": "DoublePana", "pana": "116"},
      {"game_type": "DoublePana", "pana": "224"},
      {"game_type": "DoublePana", "pana": "233"},
      {"game_type": "DoublePana", "pana": "288"},
      {"game_type": "DoublePana", "pana": "440"},
      {"game_type": "DoublePana", "pana": "477"},
      {"game_type": "DoublePana", "pana": "558"},
      {"game_type": "DoublePana", "pana": "990"},
      {"game_type": "DoublePana", "pana": "900"},
      {"game_type": "DoublePana", "pana": "117"},
      {"game_type": "DoublePana", "pana": "144"},
      {"game_type": "DoublePana", "pana": "199"},
      {"game_type": "DoublePana", "pana": "225"},
      {"game_type": "DoublePana", "pana": "388"},
      {"game_type": "DoublePana", "pana": "559"},
      {"game_type": "DoublePana", "pana": "577"},
      {"game_type": "DoublePana", "pana": "667"},
      {"game_type": "TripalPana", "pana": "000"},
      {"game_type": "TripalPana", "pana": "777"},
      {"game_type": "TripalPana", "pana": "444"},
      {"game_type": "TripalPana", "pana": "111"},
      {"game_type": "TripalPana", "pana": "888"},
      {"game_type": "TripalPana", "pana": "555"},
      {"game_type": "TripalPana", "pana": "222"},
      {"game_type": "TripalPana", "pana": "999"},
      {"game_type": "TripalPana", "pana": "666"},
      {"game_type": "TripalPana", "pana": "333"},
    ];

    for (var i in b) {
      {
        if (i['pana']!.contains(u.first) &&
            i['pana']!.contains(u.last) &&
            u.first != u.last) {
          log("If Call for diffrant number", name: "cycle pattin IF");
          a.add(i);
        } else if (i['pana']!.contains(u[0] + u[1]) && u[0] == u[1]) {
          log("else Call for diffrant number", name: "cycle pattin Else");
          a.add(i);
        }
      }
    }

    log(a.toString(), name: "Cycle  Patti");
    a.sort((a, b) => a["pana"]!.compareTo(b['pana']!));
    return a;
  }
}
