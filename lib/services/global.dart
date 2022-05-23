import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/widgets/loading_padrao.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Global extends GetxService {
  late PackageInfo packageInfo;
  bool isLoading = false;
  late Box box;
  String app = "Anote";
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  List lisCoisa = [].obs;
  List lisCoisaComp = [].obs;
  List lisComp = [].obs;
  UserP? usuario;
  int hora = 12;
  int dia = 12;
  String? tema;
  String? codigoList;
  String? codigoUser;
  String? codigRead;
  Color primary = const Color(0xFF212121);
  Color primaryLight = const Color(0xFF484848);
  Color primaryDark = const Color(0xFF000000);
  Color secondary = const Color(0xFF2195f2);
  Color secondaryLight = const Color(0xFF6ec5ff);
  Color secondaryDark = const Color(0xFF0068bf);

  Future<Global> inicia() async {
    packageInfo = await PackageInfo.fromPlatform();
    await Hive.initFlutter();
    box = await Hive.openBox('global');
    tema = box.get("tema", defaultValue: "Original");
    var auxi = box.get("user", defaultValue: '');
    if (box.get('fezLogin', defaultValue: false)) {
      usuario = UserP.fromJson(json.decode(auxi));
    }

    return this;
  }

  void load() {
    Get.dialog(
      LoadPadrao(),
      barrierColor: Colors.white,
      barrierDismissible: false,
    );
  }

  Color getPrimary() {
    switch (tema) {
      case 'Original':
        return const Color.fromRGBO(255, 64, 111, 1);

      case "Dark":
        return primary;

      case "Azul":
        return const Color.fromRGBO(89, 165, 216, 1);

      case "Roxo":
        return const Color.fromRGBO(90, 24, 154, 1);

      default:
        return Colors.white;
    }
  }

  Color getSecondary() {
    switch (tema) {
      case 'Original':
        return const Color.fromRGBO(255, 128, 111, 1);
      case "Dark":
        return primaryLight;
      case "Azul":
        return const Color.fromRGBO(145, 229, 246, 1);
      case "Roxo":
        return const Color.fromRGBO(157, 78, 221, 1);
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
}
