import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/core/interfaces/service_interface.dart';
import 'package:listadecoisa/core/services/crashlytics_service.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/organisms/loading_padrao.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Global extends IService {
  final AuthService auth;
  final CrashlyticsService crashlyticsService;

  late PackageInfo packageInfo;
  late Box box;
  User? usuario;
  int hora = 12;
  int dia = 12;
  ListViewType listViewType = ListViewType.list;

  Global(this.auth, this.crashlyticsService);

  @override
  Future<void> start() async {
    packageInfo = await PackageInfo.fromPlatform();
    await Hive.initFlutter();
    box = await Hive.openBox('global');
    listViewType = ListViewType.fromString(box.get('listViewType'));
    if (box.get('fezLogin', defaultValue: false)) {
      usuario = auth.currentUser;
      crashlyticsService.setUserIdentifier(usuario!.uid);
    }
  }

  void load(BuildContext context) {
    AppHelps.defaultDialog(
      context: context,
      barrierColor: Colors.white,
      child: LoadPadrao(),
    );
  }
}
