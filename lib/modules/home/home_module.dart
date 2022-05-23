import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/compartilha_controller.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';

class HomeModule extends IModuleFactory {
  @override
  void register() {
    di.registerFactory(() => CompartilhaController(gb: di(), banco: di()));
    di.registerFactory(() => HomeController(gb: di(), banco: di(), admob: di()));
  }
}
