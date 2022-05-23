import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/splash/controllers/splash_controller.dart';

class SplashModule extends IModuleFactory {
  @override
  void register() {
    di.registerFactory(() => SplashController());
  }
}
