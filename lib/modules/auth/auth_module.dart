import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/cadastro_controller.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/login_controller.dart';

class AuthModule extends IModuleFactory {
  @override
  void register() {
    di.registerFactory(() => CadastroController(banco: di(), gb: di()));
    di.registerFactory(() => LoginController(banco: di(), gb: di()));
  }
}
