import 'package:flutter/material.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/service_module.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';

class SplashController extends IController {
  SplashController();
  @override
  void dispose() {}

  @override
  Future<void> init(BuildContext context) async {
    await ServiceModule().starting();
    Navigator.pushNamedAndRemoveUntil(
      context,
      di.get<Global>().usuario != null ? HomePage.route : LoginPage.route,
      (route) => false,
    );
  }
}
