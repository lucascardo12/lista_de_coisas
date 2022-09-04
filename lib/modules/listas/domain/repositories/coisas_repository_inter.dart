import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';

abstract class ICoisasRepository {
  String get idCollection;
  final IRemoteDataBase remoteDataBase;

  ICoisasRepository(this.remoteDataBase);

  Future<List<Coisas>> list({
    required String idUser,
  });

  Future<void> createUpdate({
    required String idUser,
    required Coisas object,
  });

  Future<void> remove({
    required String idUser,
    required String idDoc,
  });

  Future<Coisas?> get({
    required String idUser,
    required String idDoc,
  });
}
