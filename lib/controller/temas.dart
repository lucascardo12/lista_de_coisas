import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/global.dart' as global;

Color primary = new Color(0xFF212121);
Color primaryLight = new Color(0xFF484848);
Color primaryDark = new Color(0xFF000000);
Color secondary = new Color(0xFF2195f2);
Color secondaryLight = new Color(0xFF6ec5ff);
Color secondaryDark = new Color(0xFF0068bf);

Color getPrimary() {
  switch (global.tema) {
    case 'Original':
      return Color.fromRGBO(255, 64, 111, 1);
      break;
    case "Dark":
      return primary;
      break;
    case "Azul":
      return Color.fromRGBO(89, 165, 216, 1);
      break;
    case "Roxo":
      return Color.fromRGBO(90, 24, 154, 1);
      break;
    default:
      return null;
      break;
  }
}

Color getSecondary() {
  switch (global.tema) {
    case 'Original':
      return Color.fromRGBO(255, 128, 111, 1);
      break;
    case "Dark":
      return primaryLight;
      break;
    case "Azul":
      return Color.fromRGBO(145, 229, 246, 1);
      break;
    case "Roxo":
      return Color.fromRGBO(157, 78, 221, 1);
      break;
    default:
      return null;
      break;
  }
}

Color getWhiteOrBlack() {
  switch (global.tema) {
    case 'Original':
      return Colors.white;
      break;
    case "Dark":
      return Colors.white;
      break;
    case "Azul":
      return Colors.white;
      break;
    case "Roxo":
      return Colors.white;
      break;
    default:
      return null;
      break;
  }
}
