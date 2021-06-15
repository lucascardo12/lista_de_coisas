import 'package:flutter/material.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/compartilha.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/controller/banco.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoading = false;
late SharedPreferences prefs;
String app = "Anote";
bool isSwitched = false;
bool isSwitched2 = false;
bool isSwitched3 = false;
List<Coisas> lisCoisa = [];
List<Coisas> lisCoisaComp = [];
List<Compartilha> lisComp = [];
UserP? usuario;
BancoFire banco = new BancoFire();
int hora = 12;
int dia = 12;
String? tema;
String? codigoList;
String? codigoUser;
String? codigRead;
Color primary = new Color(0xFF212121);
Color primaryLight = new Color(0xFF484848);
Color primaryDark = new Color(0xFF000000);
Color secondary = new Color(0xFF2195f2);
Color secondaryLight = new Color(0xFF6ec5ff);
Color secondaryDark = new Color(0xFF0068bf);

Color getPrimary() {
  switch (tema) {
    case 'Original':
      return Color.fromRGBO(255, 64, 111, 1);

    case "Dark":
      return primary;

    case "Azul":
      return Color.fromRGBO(89, 165, 216, 1);

    case "Roxo":
      return Color.fromRGBO(90, 24, 154, 1);

    default:
      return Colors.white;
  }
}

Color getSecondary() {
  switch (tema) {
    case 'Original':
      return Color.fromRGBO(255, 128, 111, 1);
    case "Dark":
      return primaryLight;
    case "Azul":
      return Color.fromRGBO(145, 229, 246, 1);
    case "Roxo":
      return Color.fromRGBO(157, 78, 221, 1);
    default:
      return Colors.white;
  }
}

Color getWhiteOrBlack() {
  switch (tema) {
    case 'Original':
      return Colors.white;

    case "Dark":
      return Colors.white;

    case "Azul":
      return Colors.white;

    case "Roxo":
      return Colors.white;

    default:
      return Colors.white;
  }
}
