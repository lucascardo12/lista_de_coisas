import 'package:listadecoisa/core/interfaces/module_factory_interface.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/listas/domain/repositories/coisas_repository_inter.dart';
import 'package:listadecoisa/modules/listas/infra/coisas_repository.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';

class ListasModule extends IModuleFactory {
  @override
  void register() {
    //register repository
    di.registerFactory<ICoisasRepository>(() => CoisasRepository(di()));
    //register controllers
    di.registerFactory(
      () => ListasController(
        gb: di(),
        coisasRepository: di(),
        admob: di(),
        compartilhaRepository: di(),
      ),
    );
  }
}
