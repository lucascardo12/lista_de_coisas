import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';

class ListasModule extends IModuleFactory {
  @override
  void register() {
    di.registerFactory(() => ListasController(gb: di(), banco: di(), admob: di()));
  }
}
