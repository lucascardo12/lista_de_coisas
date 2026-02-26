import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/core/services/hive_db.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/services/banco.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/crashlytics_service.dart';

class ServiceModule {
  void register() {
    di.registerLazySingleton<ILocalDatabase>(() => LocalDatabaseHive());
    di.registerLazySingleton(() => Global());
    di.registerLazySingleton<IRemoteDataBase>(() => BancoFire());
    di.registerLazySingleton(() => CrashlyticsService());
  }

  Future<void> starting() async {
    await di.get<CrashlyticsService>().initialize();
    await di.get<Global>().start();
    await di.get<IRemoteDataBase>().start();
    await di.get<ILocalDatabase>().starts();
  }
}
