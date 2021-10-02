import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Global extends GetxService {
  final InAppReview inAppReview = InAppReview.instance;
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
  Color primary = Color(0xFF212121);
  Color primaryLight = Color(0xFF484848);
  Color primaryDark = Color(0xFF000000);
  Color secondary = Color(0xFF2195f2);
  Color secondaryLight = Color(0xFF6ec5ff);
  Color secondaryDark = Color(0xFF0068bf);

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
    print('load');
    Get.dialog(
      LoadPadrao(),
      barrierColor: Colors.white,
      barrierDismissible: false,
    );
  }

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
}
