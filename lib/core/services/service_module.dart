import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/core/services/hive_db.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/services/admob.dart';
import 'package:listadecoisa/core/services/banco.dart';
import 'package:listadecoisa/core/services/global.dart';

class ServiceModule {
  void register() {
    di.registerLazySingleton<ILocalDatabase>(() => LocalDatabaseHive());
    di.registerLazySingleton(() => AdMob());
    di.registerLazySingleton(() => Global());
    di.registerLazySingleton<IRemoteDataBase>(() => BancoFire());
  }

  Future<void> starting() async {
    await di.get<Global>().start();
    await di.get<AdMob>().start();
    await di.get<IRemoteDataBase>().start();
  }
}
