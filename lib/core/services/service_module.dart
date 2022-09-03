import 'package:flutter/material.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/core/services/admob.dart';
import 'package:listadecoisa/core/services/banco.dart';
import 'package:listadecoisa/core/services/global.dart';

class ServiceModule {
  void register() {
    di.registerLazySingleton(() => AdMob());
    di.registerLazySingleton(() => Global());
    di.registerLazySingleton(() => BancoFire());
  }

  Future<void> starting(BuildContext context, bool mounted) async {
    var gb = di.get<Global>();
    await gb.start();
    await di.get<AdMob>().start();
    await di.get<BancoFire>().start();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      gb.usuario != null ? HomePage.route : LoginPage.route,
      (route) => false,
    );
  }
}
