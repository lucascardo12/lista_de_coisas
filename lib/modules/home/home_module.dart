import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/home/domain/repositories/compartilha_repository_inter.dart';
import 'package:listadecoisa/modules/home/infra/compartilha_repository.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/compartilha_controller.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';

class HomeModule extends IModuleFactory {
  @override
  void register() {
    //register repository
    di.registerFactory<ICompartilhaRepository>(() => CompartilhaRepository(di()));
    //register controllers
    di.registerFactory(
      () => CompartilhaController(
        gb: di(),
        coisasRepository: di(),
        compartilhaRepository: di(),
        remoteDataBase: di(),
      ),
    );
    di.registerFactory(
      () => HomeController(
        admob: di(),
        authService: di(),
        coisasRepository: di(),
        compartilhaRepository: di(),
        global: di(),
        localDatabase: di(),
      ),
    );
  }
}
