import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/core/interfaces/service_interface.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/organisms/loading_padrao.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Global extends IService {
  late PackageInfo packageInfo;
  late Box box;
  UserP? usuario;
  int hora = 12;
  int dia = 12;
  var tema = ValueNotifier('');
  ListViewType listViewType = ListViewType.list;
  Color primary = const Color(0xFF212121);
  Color primaryLight = const Color(0xFF484848);
  Color primaryDark = const Color(0xFF000000);
  Color secondary = const Color(0xFF2195f2);
  Color secondaryLight = const Color(0xFF6ec5ff);
  Color secondaryDark = const Color(0xFF0068bf);

  @override
  Future<void> start() async {
    packageInfo = await PackageInfo.fromPlatform();
    await Hive.initFlutter();
    box = await Hive.openBox('global');
    tema.value = box.get('tema', defaultValue: 'Original');
    listViewType = ListViewType.fromString(box.get('listViewType'));
    final auxi = box.get('user', defaultValue: '');
    if (box.get('fezLogin', defaultValue: false)) {
      usuario = UserP.fromJson(json.decode(auxi));
    }
  }

  void load(BuildContext context) {
    AppHelps.defaultDialog(
      context: context,
      barrierColor: Colors.white,
      child: LoadPadrao(),
    );
  }

  Color getPrimary() {
    switch (tema.value) {
      case 'Original':
        return const Color.fromRGBO(255, 64, 111, 1);

      case 'Dark':
        return primary;

      case 'Azul':
        return const Color.fromRGBO(89, 165, 216, 1);

      case 'Roxo':
        return const Color.fromRGBO(90, 24, 154, 1);

      default:
        return const Color.fromRGBO(255, 64, 111, 1);
    }
  }

  Color getSecondary() {
    switch (tema.value) {
      case 'Original':
        return const Color.fromRGBO(255, 128, 111, 1);
      case 'Dark':
        return primaryLight;
      case 'Azul':
        return const Color.fromRGBO(145, 229, 246, 1);
      case 'Roxo':
        return const Color.fromRGBO(157, 78, 221, 1);
      default:
        return const Color.fromRGBO(255, 128, 111, 1);
    }
  }

  Color getWhiteOrBlack() {
    switch (tema.value) {
      case 'Original':
        return Colors.white;

      case 'Dark':
        return Colors.white;

      case 'Azul':
        return Colors.white;

      case 'Roxo':
        return Colors.white;

      default:
        return Colors.white;
    }
  }
}
