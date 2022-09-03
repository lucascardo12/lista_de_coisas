import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/cadastro_controller.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/login_controller.dart';

class AuthModule extends IModuleFactory {
  @override
  void register() {
    //register services
    di.registerFactory(() => AuthService(di(), di()));
    //register controllers
    di.registerFactory(() => CadastroController(banco: di(), gb: di(), authService: di()));
    di.registerFactory(() => LoginController(banco: di(), gb: di(), authService: di()));
  }
}
