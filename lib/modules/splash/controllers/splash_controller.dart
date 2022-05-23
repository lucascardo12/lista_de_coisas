import 'package:flutter/material.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/services/service_module.dart';

class SplashController extends IController {
  SplashController();
  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    ServiceModule().starting(context, true);
  }
}
