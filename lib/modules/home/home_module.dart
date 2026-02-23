import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';

class HomeModule extends IModuleFactory {
  @override
  void register() {
    //register repository
    di.registerFactory(
      () => HomeController(
        authService: di(),
        coisasRepository: di(),
        global: di(),
        localDatabase: di(),
      ),
    );
  }
}
